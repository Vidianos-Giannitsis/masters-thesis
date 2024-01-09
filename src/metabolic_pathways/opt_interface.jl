function mixed_culture_fermentation(st; gluc_goal = (; glucose = 0.0), suc_goal = (; sucrose = 0.0), lact_cons_goal = (; lactate = 0.0), fruc_goal = (; fructose = 0.0), pyr_goal = (; pyruvate = 0.0), acet_amount = 0.5, lact_amount = 0.5, het_amount = 1.0, eth_amount = 0.0, feed_oxygen = 0.0)
    # Sucrose is hydrolyzed
    suc_st = sucrose_hydrolysis(st, goal = suc_goal)

    # Glucose goes into either glycolysis or heterolactic fermentation
    het_goal = (; glucose = (suc_st.glucose - (suc_st.glucose - gluc_goal.glucose)*het_amount))
    glyc_goal = (; glucose = (suc_st.glucose - (suc_st.glucose - gluc_goal.glucose)*(1-het_amount)))
    het_st = ethanol_heterolactate(suc_st, goal = het_goal)
    glyc_st = glycolysis(suc_st, goal = glyc_goal)

    pyr_st = merge(suc_st,
		   (glucose = gluc_goal.glucose,
		    ethanol = het_st.ethanol,
		    lactate = het_st.lactate,
		    co2 = het_st.co2,
		    pyruvate = het_st.pyruvate + glyc_st.pyruvate - suc_st.pyruvate,
		    hydrogen = het_st.hydrogen + glyc_st.hydrogen - suc_st.hydrogen))

    # Fructose is also hydrolyzed
    fruc_st = fructolysis(pyr_st, goal = fruc_goal)

    # Check if there is any oxygen in the reactor and if there is
    # consume the according pyruvate
    ox_st = merge(fruc_st, (; oxygen = feed_oxygen))
    new_st = aerobic_pyruvate_oxidation(ox_st)

    # Then, pyruvate is converted to the various products
    aceteth_amount = 1 - lact_amount - acet_amount - eth_amount
    acet_goal = (; pyruvate = (new_st.pyruvate - (new_st.pyruvate - pyr_goal.pyruvate)*acet_amount))
    lact_prod_goal = (; pyruvate = (new_st.pyruvate - (new_st.pyruvate - pyr_goal.pyruvate)*lact_amount))
    aceteth_goal = (; pyruvate = (new_st.pyruvate - (new_st.pyruvate - pyr_goal.pyruvate)*aceteth_amount))
    eth_goal = (; pyruvate = (new_st.pyruvate - (new_st.pyruvate - pyr_goal.pyruvate)*eth_amount))

    aceteth_st = acetate_ethanol_fermentation(new_st, goal =aceteth_goal)
    acet_st = pyruv_to_acetate(new_st, goal = acet_goal)
    lact_st = pyruv_to_lact(new_st, goal = lact_prod_goal)
    eth_st = pyruv_to_ethanol(new_st, pyr_goal = eth_goal)

    prod_st = merge(new_st,
		   (pyruvate = pyr_goal.pyruvate,
		    acetate = acet_st.acetate + aceteth_st.acetate - new_st.acetate,
		    ethanol = aceteth_st.ethanol + eth_st.ethanol - new_st.ethanol,
		    lactate = lact_st.lactate,
		    co2 = acet_st.co2 + aceteth_st.co2 + eth_st.co2 - 2new_st.co2,
		    hydrogen = acet_st.hydrogen + aceteth_st.hydrogen + lact_st.hydrogen - 2new_st.hydrogen))

    prop_st = lact_to_propionate(prod_st, goal = lact_cons_goal)
end


function mixed_culture_optimization(init_st, final_st, p, v)
    init_mass = conc_to_mass(init_st, v)
    final_mass = final_st.*v
    mixed_culture_fermentation(init_mass, suc_goal = (; sucrose = final_mass[1]), gluc_goal = (; glucose = final_mass[2]), fruc_goal = (; fructose = final_mass[3]), lact_cons_goal = (; lactate = final_mass[4]), het_amount = p[1], acet_amount = p[2], lact_amount = p[3], eth_amount = p[4], feed_oxygen = p[5])
end

function fermentation_loss(init_st, final_st, p, v)
    model = mixed_culture_optimization(init_st, final_st, p, v)

    model_mass = [model.acetate, model.propionate, model.ethanol]
    exp_mass = final_st[5:7].*v
    sum(abs2, (model_mass .- exp_mass))
end

function mixed_culture_predictor(init_st, final_st, p, v)
    mass_st = mixed_culture_optimization(init_st, final_st, p, v)
    conc_st = mass_to_conc(mass_st, v)

    loss = fermentation_loss(init_st, final_st, p, v)
    println("For the parameter set ", p, " we get the effluent \n", conc_st, " and a loss of ", loss, " with the experimental data.")
end
