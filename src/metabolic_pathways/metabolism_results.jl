using DataFrames, SparseArrays, Tables
include(srcdir("metabolic_pathways"))

function sugar_production_metabolism(st, df, p, v)
    mass_st = conc_to_mass(st, v)
    suc_st = sucrose_hydrolysis(mass_st)

    gluc_prod = suc_st.glucose - mass_st.glucose
    fruc_prod = suc_st.fructose - mass_st.fructose

    gluc_percent = gluc_prod/suc_st.glucose
    fruc_percent = fruc_prod/suc_st.fructose
    fruc_cons_percent = 1 - df[4,4]*v/suc_st.fructose

    return([gluc_percent, fruc_percent, -fruc_cons_percent])
end

function sugar_consumption_metabolism(st, df, p, v; init_pyr = 0, pyr_flux = 0)
    mass_st = conc_to_mass(st, v)
    suc_goal = (; sucrose = df[4, 2])
    gluc_goal = (; glucose = df[4, 3])
    fruc_goal = (; fructose = df[4, 4])

    # Sucrose is hydrolyzed
    suc_st = sucrose_hydrolysis(mass_st, goal = suc_goal)

    # Glucose goes into either glycolysis or heterolactic fermentation
    het_goal = (; glucose = (suc_st.glucose - (suc_st.glucose - gluc_goal.glucose)*p[1]))
    glyc_goal = (; glucose = (suc_st.glucose - (suc_st.glucose - gluc_goal.glucose)*(1-p[1])))
    het_st = ethanol_heterolactate(suc_st, goal = het_goal)
    glyc_st = glycolysis(suc_st, goal = glyc_goal)
    gluc_pyr = glyc_st.pyruvate

    pyr_st = merge(suc_st,
		   (glucose = gluc_goal.glucose,
		    ethanol = het_st.ethanol,
		    lactate = het_st.lactate,
		    co2 = het_st.co2,
		    pyruvate = het_st.pyruvate + glyc_st.pyruvate - suc_st.pyruvate,
		    hydrogen = het_st.hydrogen + glyc_st.hydrogen - suc_st.hydrogen))

    # Fructose is also hydrolyzed
    fruc_st = fructolysis(pyr_st, goal = fruc_goal)

    initial_pyr = fruc_st.pyruvate
    gluc_percent = gluc_pyr/initial_pyr
    fruc_percent = 1 - gluc_percent
    pyr_percent = [gluc_percent, fruc_percent]

    # Check if there is any oxygen in the reactor and if there is
    # consume the according pyruvate
    ox_st = merge(fruc_st, (; oxygen = p[5]))
    new_st = aerobic_pyruvate_oxidation(ox_st)

    if init_pyr != 0
	return new_st, initial_pyr
    elseif pyr_flux != 0
	return pyr_percent
    else
	return new_st
    end
end

function pyruvate_ox_consumption(st, df, p, v)
    new_st, initial_pyr = sugar_consumption_metabolism(st, df, p, v, init_pyr = 1)
    final_pyr = new_st.pyruvate
    (initial_pyr - final_pyr)/initial_pyr
end

function pyruvate_cons_dist(st, df, p, v)
    # Find which percentage of pyruvate is not consumed aerobically
    # using pyruvate_ox_consumption.
    pyr_amount = pyruvate_ox_consumption(st, df, p, v)

    # Find how much pyruvate was consumed in acetate-ethanol type
    # fermentation
    aceteth = 1 - p[2] - p[3] - p[4]

    # Calculate the amounts based on the total pyruvate and not that
    # after oxidation.
    acet_amount = p[2]*pyr_amount
    lact_amount = p[3]*pyr_amount
    eth_amount = p[4]*pyr_amount
    aceteth_amount = aceteth*pyr_amount

    # Return a vector showing the pyruvate consumption distribution
    # between its five reactions.
    return([1-pyr_amount, acet_amount, lact_amount, eth_amount, aceteth_amount])
end

function acetate_dist(st, df, p, v)
    new_st = sugar_consumption_metabolism(st, df, p, v)
    aceteth_amount = 1 - p[2] - p[3] - p[4]

    acet_goal = (; pyruvate = (new_st.pyruvate - new_st.pyruvate*p[2]))
    aceteth_goal = (; pyruvate = (new_st.pyruvate - new_st.pyruvate*aceteth_amount))

    acet_st = pyruv_to_acetate(new_st, goal = acet_goal)
    aceteth_st = acetate_ethanol_fermentation(new_st, goal = aceteth_goal)

    acet_prod = acet_st.acetate - new_st.acetate
    aceteth_prod = aceteth_st.acetate - new_st.acetate
    total_acet = df[4, 6]*v

    init_percent = new_st.acetate/total_acet
    acet_percent = acet_prod/total_acet
    aceteth_percent = aceteth_prod/total_acet

    return([acet_percent, aceteth_percent, 1 - acet_percent - aceteth_percent - init_percent])
end

function lactate_dist(st, df, p, v)
    new_st = sugar_consumption_metabolism(st, df, p, v)
    het_lact = new_st.lactate - minimum(df[:, 5])*v

    lact_goal = (; pyruvate = (new_st.pyruvate - new_st.pyruvate*p[3]))
    lact_st = pyruv_to_lact(new_st, goal = lact_goal)

    total_lact = lact_st.lactate
    lact_amount = total_lact - new_st.lactate

    final_lact = df[4, 5]*v

    het_percent = het_lact/total_lact
    lact_percent = lact_amount/total_lact
    lact_cons_percent = 1 - final_lact/total_lact

    return([het_percent, lact_percent, -lact_cons_percent])
end

function ethanol_dist(st, df, p, v)
    new_st = sugar_consumption_metabolism(st, df, p, v)
    het_eth = new_st.ethanol - df[1, 8]*v

    aceteth_amount = 1 - p[2] - p[3] - p[4]
    eth_goal = (; pyruvate = (new_st.pyruvate - new_st.pyruvate*p[4]))
    aceteth_goal = (; pyruvate = (new_st.pyruvate - new_st.pyruvate*aceteth_amount))

    eth_st = pyruv_to_ethanol(new_st, pyr_goal = eth_goal)
    aceteth_st = acetate_ethanol_fermentation(new_st, goal = aceteth_goal)

    eth_prod = eth_st.ethanol - new_st.ethanol
    aceteth_prod = aceteth_st.ethanol - new_st.ethanol
    total_eth = eth_st.ethanol + aceteth_st.ethanol - new_st.ethanol
    final_eth = df[4, 8]*v

    het_percent = het_eth/total_eth
    eth_percent = eth_prod/total_eth
    aceteth_percent = aceteth_prod/total_eth
    eth_cons_percent = 1 - final_eth/total_eth

    return([het_percent, eth_percent, aceteth_percent, -eth_cons_percent])
end

# This function is practically trivial, but this percentage is
# important
function propionate_dist(st, df, p, v)
    prop_percent = 1 - df[1, 7]/df[4, 7]
end

function initial_state_calcs(st, df, p, v)
    sugar_dist = sugar_production_metabolism(st, df, p, v)
    pyr_dist = pyruvate_cons_dist(st, df, p, v)
    acet_dist = acetate_dist(st, df, p, v)
    lact_dist = lactate_dist(st, df, p, v)
    eth_dist = ethanol_dist(st, df, p, v)
    prop_dist = propionate_dist(st, df, p, v)

    # Sucrose is not produced anywhere so the initial state is equal
    # to 100% of the total
    init_gluc = 1-sugar_dist[1]
    init_fruc = 1-sugar_dist[2]
    # Pyruvate is produced and consumed only on the reactions, so its
    # initial state is 0
    init_lact = 1 - sum(lact_dist[1:2])
    init_acet = 1 - sum(acet_dist)
    init_prop = 1 - prop_dist
    init_eth = 1 - sum(eth_dist[1:3])

    return([1, init_gluc, init_fruc, 0, init_lact, init_acet, init_prop, init_eth])
end

function reaction_fluxes(st, df, p, v)
    sugar_dist = sugar_production_metabolism(st, df, p, v)
    pyr_dist = pyruvate_cons_dist(st, df, p, v)
    acet_dist = acetate_dist(st, df, p, v)
    lact_dist = lactate_dist(st, df, p, v)
    eth_dist = ethanol_dist(st, df, p, v)
    prop_dist = propionate_dist(st, df, p, v)

    sp_row = [1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 8, 8, 8, 8]
    sp_column = [1, 1, 2, 3, 1, 2, 2, 4, 5, 6, 7, 8, 3, 6, 9, 5, 8, 10, 9, 3, 7, 8, 10]
    sp_val = [-1, sugar_dist[1], p[1]-1, -p[1], sugar_dist[2], sugar_dist[3], 1, -pyr_dist..., lact_dist..., acet_dist..., prop_dist..., eth_dist...]

    flux_table = sparse(sp_row, sp_column, sp_val)
end

function final_state_calcs(st, df, p, v)
    sugar_dist = sugar_production_metabolism(st, df, p, v)
    pyr_dist = pyruvate_cons_dist(st, df, p, v)
    acet_dist = acetate_dist(st, df, p, v)
    lact_dist = lactate_dist(st, df, p, v)
    eth_dist = ethanol_dist(st, df, p, v)
    prop_dist = propionate_dist(st, df, p, v)

    return([0, 0, 1+sugar_dist[3], 0, 1+lact_dist[3], 1, 1, 1+eth_dist[4]])
end

function complete_fluxes(st, df, p, v)
    init_table = initial_state_calcs(st, df, p, v)
    react_table = reaction_fluxes(st, df, p, v)
    final_table = final_state_calcs(st, df, p, v)

    hcat(init_table, react_table, final_table)
end

function readable_flux_table(st, df, p, v)
    flux_table = complete_fluxes(st, df, p, v)
    row_names = ["Sucrose", "Glucose", "Fructose", "Pyruvate", "Lactate", "Acetate", "Propionate", "Ethanol"]
    column_names = reshape(["Comp", "Init", "SucHyd", "Glycolysis", "Heterolact", "PyrOx", "Acet", "Lact", "Eth", "Aceteth", "Prop", "Acetogenesis", "Final"], 1, 13)

    vcat(column_names, hcat(row_names, flux_table))
end

function max_concentrations(st, df, p, v)
    mass_st = conc_to_mass(st, v)
    max_suc = mass_st.sucrose

    gluc_goal = (; glucose = df[4, 3])
    fruc_goal = (; fructose = df[4, 4])

    suc_st = sucrose_hydrolysis(mass_st)
    max_gluc = suc_st.glucose
    max_fruc = suc_st.fructose

    # Add all the reactions up to pyruvate oxidation so that we can
    # properly do the rest
    het_goal = (; glucose = (suc_st.glucose - (suc_st.glucose - gluc_goal.glucose)*p[1]))
    glyc_goal = (; glucose = (suc_st.glucose - (suc_st.glucose - gluc_goal.glucose)*(1-p[1])))
    het_st = ethanol_heterolactate(suc_st, goal = het_goal)
    glyc_st = glycolysis(suc_st, goal = glyc_goal)

    pyr_st = merge(suc_st,
		   (glucose = gluc_goal.glucose,
		    ethanol = het_st.ethanol,
		    lactate = het_st.lactate,
		    co2 = het_st.co2,
		    pyruvate = het_st.pyruvate + glyc_st.pyruvate - suc_st.pyruvate,
		    hydrogen = het_st.hydrogen + glyc_st.hydrogen - suc_st.hydrogen))

    fruc_st = fructolysis(pyr_st, goal = fruc_goal)

    # This is the point we get the max pyruvate
    max_pyr = fruc_st.pyruvate

    ox_st = merge(fruc_st, (; oxygen = p[5]))
    new_st = aerobic_pyruvate_oxidation(ox_st)

    # Lactate fermentation yields the maximum lactate
    lact_goal = (; pyruvate = (new_st.pyruvate - new_st.pyruvate*p[3]))
    lact_st = pyruv_to_lact(new_st, goal = lact_goal)
    max_lact = lact_st.lactate

    aceteth_amount = 1 - p[2] - p[3] - p[4]
    eth_goal = (; pyruvate = (new_st.pyruvate - new_st.pyruvate*p[4]))
    aceteth_goal = (; pyruvate = (new_st.pyruvate - new_st.pyruvate*aceteth_amount))

    eth_st = pyruv_to_ethanol(new_st, pyr_goal = eth_goal)
    aceteth_st = acetate_ethanol_fermentation(new_st, goal = aceteth_goal)

    # No need to fully merge the two reaction, we just want to see the
    # max ethanol
    max_eth = eth_st.ethanol + aceteth_st.ethanol - new_st.ethanol

    # Propionate and Acetate are not consumed so we can just get them
    # from the dataframe
    max_acet = df[4, 6]*v
    max_prop = df[4, 7]*v

    return([max_suc, max_gluc, max_fruc, max_pyr, max_lact, max_acet, max_prop, max_eth]./v)
end

function absolute_flux_table(st, df, p, v)
    flux_table = complete_fluxes(st, df, p, v)
    max_concs = max_concentrations(st, df, p, v)

    conc_fluxes = flux_table.*max_concs
end

using Graphs, CairoMakie, GraphMakie

function generic_metabolic_graph()
    source = [1, 1, 2, 2, 2, 3, 4, 4, 4, 4, 5, 8]
    destination = [2, 3, 4, 5, 8, 4, 9, 6, 5, 8, 7, 6]

    G = DiGraph(9)
    [add_edge!(G, source[i], destination[i]) for i in 1:length(source)]
    labels = ["Sucrose", "Glucose", "Fructose", "Pyruvate", "Lactate", "Acetate", "Propionate", "Ethanol", "Kreb's\n Cycle"]
    edgelab = ["Hydrolysis", "Hydrolysis", "Glycolysis", "Heterolactic", "Heterolactic", "Fructolysis", "Reduction", "Acetate/Acetate-Ethanol type", "Ethanol/Acetate-Ethanol type", "Oxidation", "Reduction", "Acetogenesis"]

    return(G, labels, edgelab)
end

function get_metabolic_graph_attrs(st, df, p, v)
    concs = vcat(max_concentrations(st, df, p, v), 0.9)
    w_matrix = hcat(sortperm(concs), Vector(LinRange(30, 60, 9)))
    inds = [findall(x -> x==i, w_matrix[:, 1]) for i in 1.0:9.0]
    node_w = reduce(vcat, transpose.([w_matrix[inds[i], 2] for i in 1:9]))[:, 1]

    pyr_percent = sugar_consumption_metabolism(st, df, p, v, pyr_flux = 1)
    reactflux = reaction_fluxes(st, df, p, v)

    edge_w = [reactflux[2,1], reactflux[3,1], pyr_percent[1], reactflux[5, 3], reactflux[8,3], pyr_percent[2], -reactflux[4,4], reactflux[6,5]+reactflux[6, 8], reactflux[5, 6], reactflux[8, 7]+reactflux[8, 8], reactflux[7, 9], reactflux[6, 10]]
    col_grad = ["#440154", "#481567", "#482677", "#453781", "#404788", "#39568C", "#33638D", "#2D708E", "#287D8E", "#238A8D", "#1F968B", "#20A387", "#29AF7F", "#3CBB75", "#55C667", "#73D055", "#95D840", "#B8DE29", "#DCE319", "#FDE725"]
    edgecol = col_grad[[argmin(abs.(edge_w[i] .- col_range)) for i in 1:12]]

    return(node_w, edgecol, col_grad)
end

function generate_metabolic_graph(st, df, p, v)
    graph, node_lab, edge_lab = generic_metabolic_graph()
    node_w, edge_w, col_grad = get_metabolic_graph_attrs(st, df, p, v)

    fig = Figure(size = (900, 600))
    ax, pl = GraphMakie.graphplot(fig[1,1], graph, ilabels = node_lab, elabels = edge_lab, edge_color = edge_w, edge_width = 4, arrow_size = 20, arrow_shift = :end, node_color = "#238A8D", curve_distance = -.2, curve_distance_usage = true, elabels_fontsize = 12, elabels_distance = -9, node_size = node_w, ilabels_fontsize = 12)
    hidedecorations!(ax); hidespines!(ax)
    Colorbar(fig[1, 2], colormap = col_grad)

    return fig
end
