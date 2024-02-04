using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("filenames.jl"))
include(srcdir("metabolic_pathways", "primitives.jl"))
include(srcdir("metabolic_pathways", "core_pathways.jl"))
include(srcdir("metabolic_pathways", "compound_pathways.jl"))
include(srcdir("metabolic_pathways", "acetogenesis.jl"))
using CSV, DataFrames

# Read all the data
exp_35 = "10_11"
exp_40 = "28_11"
mix_amount = ["0", "1", "2", "4", "8"]

# Experiment @35 C
df35_0 = CSV.read(get_conc_csv(exp_35, mix_amount[1]), DataFrame)
df35_1 = CSV.read(get_conc_csv(exp_35, mix_amount[2]), DataFrame)
df35_2 = CSV.read(get_conc_csv(exp_35, mix_amount[3]), DataFrame)
df35_4 = CSV.read(get_conc_csv(exp_35, mix_amount[4]), DataFrame)
df35_8 = CSV.read(get_conc_csv(exp_35, mix_amount[5]), DataFrame)

# Experiment @40 C
df40_0 = CSV.read(get_conc_csv(exp_40, mix_amount[1]), DataFrame)
df40_1 = CSV.read(get_conc_csv(exp_40, mix_amount[2]), DataFrame)
df40_2 = CSV.read(get_conc_csv(exp_40, mix_amount[3]), DataFrame)
df40_4 = CSV.read(get_conc_csv(exp_40, mix_amount[4]), DataFrame)
df40_8 = CSV.read(get_conc_csv(exp_40, mix_amount[5]), DataFrame)

# 35 C
v = 0.8
init_st35_0 = (sucrose = df35_0.Sucrose[1], glucose = df35_0.Glucose[1],
	    fructose = df35_0.Fructose[1], lactate = df35_0.Lactate[2],
	    acetate = df35_0.Acetate[1], propionate = df35_0.Propionate[2],
	    ethanol = df35_0.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass35_0 = conc_to_mass(init_st35_0, v)

init_st35_1 = (sucrose = df35_1.Sucrose[1], glucose = df35_1.Glucose[1],
	    fructose = df35_1.Fructose[1], lactate = df35_1.Lactate[2],
	    acetate = df35_1.Acetate[2], propionate = df35_1.Propionate[2],
	    ethanol = df35_1.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass35_1 = conc_to_mass(init_st35_1, v)

init_st35_2 = (sucrose = df35_2.Sucrose[1], glucose = df35_2.Glucose[1],
	    fructose = df35_2.Fructose[1], lactate = df35_2.Lactate[1],
	    acetate = df35_2.Acetate[1], propionate = df35_2.Propionate[1],
	    ethanol = df35_2.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass35_2 = conc_to_mass(init_st35_2, v)

init_st35_4 = (sucrose = df35_4.Sucrose[1], glucose = df35_4.Glucose[1],
	    fructose = df35_4.Fructose[1], lactate = df35_4.Lactate[1],
	    acetate = df35_4.Acetate[2], propionate = df35_4.Propionate[1],
	    ethanol = df35_4.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass35_4 = conc_to_mass(init_st35_4, v)

init_st35_8 = (sucrose = df35_8.Sucrose[1], glucose = df35_8.Glucose[1],
	    fructose = df35_8.Fructose[1], lactate = df35_8.Lactate[1],
	    acetate = df35_8.Acetate[2], propionate = df35_8.Propionate[1],
	    ethanol = df35_8.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass35_8 = conc_to_mass(init_st35_8, v)

# 40C
v = 0.8
init_st40_0 = (sucrose = df40_0.Sucrose[1], glucose = df40_0.Glucose[1],
	    fructose = df40_0.Fructose[1], lactate = df40_0.Lactate[2],
	    acetate = df40_0.Acetate[1], propionate = df40_0.Propionate[2],
	    ethanol = df40_0.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass40_0 = conc_to_mass(init_st40_0, v)

init_st40_1 = (sucrose = df40_1.Sucrose[1], glucose = df40_1.Glucose[1],
	    fructose = df40_1.Fructose[1], lactate = df40_1.Lactate[2],
	    acetate = df40_1.Acetate[2], propionate = df40_1.Propionate[2],
	    ethanol = df40_1.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass40_1 = conc_to_mass(init_st40_1, v)

init_st40_2 = (sucrose = df40_2.Sucrose[1], glucose = df40_2.Glucose[1],
	    fructose = df40_2.Fructose[1], lactate = df40_2.Lactate[1],
	    acetate = df40_2.Acetate[1], propionate = df40_2.Propionate[1],
	    ethanol = df40_2.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass40_2 = conc_to_mass(init_st40_2, v)

init_st40_4 = (sucrose = df40_4.Sucrose[1], glucose = df40_4.Glucose[1],
	    fructose = df40_4.Fructose[1], lactate = df40_4.Lactate[1],
	    acetate = df40_4.Acetate[2], propionate = df40_4.Propionate[1],
	    ethanol = df40_4.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass40_4 = conc_to_mass(init_st40_4, v)

init_st40_8 = (sucrose = df40_8.Sucrose[1], glucose = df40_8.Glucose[1],
	    fructose = df40_8.Fructose[1], lactate = df40_8.Lactate[1],
	    acetate = df40_8.Acetate[2], propionate = df40_8.Propionate[1],
	    ethanol = df40_8.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
	    pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass40_8 = conc_to_mass(init_st40_8, v)

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

    # We know that hydrogen will be produced by the reaction producing
    # acetate and consumed by the ones producing lactate and
    # ethanol. We also know that in some cases the fructolytic
    # hydrogen (which is the only hydrogen that exists in `new_st`)
    # may not be enough. For this reason, we precompute the hydrogen
    # that will be produced.
    acet_st = pyruv_to_acetate(new_st, goal = acet_goal)
    # Aceteth can also be computed here as its hydrogen neutral (one
    # reaction produces and one consumes) so its results will be the
    # same in either state.
    aceteth_st = acetate_ethanol_fermentation(new_st, goal = aceteth_goal)

    hyd_st = merge(new_st, (; hydrogen = acet_st.hydrogen))

    # Then compute the other 2 states with this hyd_st as the input.
    lact_st = pyruv_to_lact(hyd_st, goal = lact_prod_goal)
    eth_st = pyruv_to_ethanol(hyd_st, pyr_goal = eth_goal)

    # Then merge the 4 states with the initial one, taking care to
    # compute the correct hydrogen state.
    prod_st = merge(new_st,
		   (pyruvate = pyr_goal.pyruvate,
		    acetate = acet_st.acetate + aceteth_st.acetate - new_st.acetate,
		    ethanol = aceteth_st.ethanol + eth_st.ethanol - new_st.ethanol,
		    lactate = lact_st.lactate,
		    co2 = acet_st.co2 + aceteth_st.co2 + eth_st.co2 - 2new_st.co2,
		    hydrogen = lact_st.hydrogen + eth_st.hydrogen - hyd_st.hydrogen))

    # With this trick, we have circumvented the problem that hydrogen
    # may not be sufficient for all reactions if one doesn't recognize
    # the changes of the other (which is necessary to write the fluxes
    # this way) but have the same results as if all of them happened
    # at the same time.

    prop_st = lact_to_propionate(prod_st, goal = lact_cons_goal)
end

include(srcdir("metabolic_pathways", "opt_interface.jl"))

# Define the specialized loss function with signature f(u, p) which is
# what the Optimization interface accepts and also a predictor
# function which is also specialized and helps us with testing.
loss_35_0(u, p) = fermentation_loss(init_st35_0, df35_0, u, 0.8)
predictor_35_0(u) = mixed_culture_predictor(init_st35_0, df35_0, u, 0.8)

using Optimization, OptimizationOptimJL

# u0 can be taken basically randomly and if its not too bad, the
# algorithm will converge.
u0 = [0.89, 0.12, 0.09, 0.18, 0.86]

# The bounds were originally necessary, as the system couldn't
# converge outside of a very specific domain due to errors popping up,
# but after introducing error handling and saying that we should
# handle what would be an error by just attributing a high loss to it,
# this isn't necessary. In this first demonstrative example however,
# these bounds are kept to show that the problem with and without
# bounds gives very similar results.
lbound = [0.8, 0.0, 0.00, 0.0, 0.0]
ubound = [1.0, 0.3, 0.3, 0.6, 2.0]

adtype = Optimization.AutoForwardDiff()
optf = Optimization.OptimizationFunction(loss_35_0, adtype)

optprob = Optimization.OptimizationProblem(optf, u0, lb = lbound, ub = ubound)

sol35_0 = solve(optprob, Optim.BFGS())
predictor_35_0(sol35_0.u)

# After adding error handling to the loss function, the optimizer will
# reach the correct solution even without bounds and will not error
# out in them.
opt_unbound = Optimization.OptimizationProblem(optf, u0)

# An interesting problem is that if this is ran with the above u0, it
# fails to find the optimum. However, if a new u0 is defined, which is
# closer to the solution of the bounded optimization problem, the
# system will indeed converge. This shows that the optimizer without
# bounds is more sensitive to initial conditions and care should be
# taken to get a good result.
sol2 = solve(opt_unbound, Optim.BFGS())
# Returns failure

# Rerun the problem with a slightly dislocated version of sol1
new_prob = Optimization.OptimizationProblem(optf, sol1.u .+ 0.1.*rand())
sol3 = solve(new_prob, Optim.BFGS())
# Converges properly

# Note that this isn't the exact same solution as sol1 (which is
# expected as we are studying a very complex system which is very
# likely to have multiple local minima), but since both have a very
# small loss function and also are not far from each other, either one
# can be accepted as correct.

predictor_35_0(sol3.u)

loss_35_1(u, p) = fermentation_loss(init_st35_1, df35_1, u, 0.8)
predictor_35_1(u) = mixed_culture_predictor(init_st35_1, df35_1, u, 0.8)

# First, let's try to solve an unbounded optimization problem using
# the solution of the above as the initial condition.
optf_35_1 = OptimizationFunction(loss_35_1, adtype)
optprob_35_1 = OptimizationProblem(optf_35_1, sol35_0.u)

sol35_1 = solve(optprob_35_1, Optim.BFGS())

df35_2[4, 8] = df35_2[3, 8]
loss_35_2(u, p) = fermentation_loss(init_st35_2, df35_2, u, 0.8)
predictor_35_2(u) = mixed_culture_predictor(init_st35_2, df35_2, u, 0.8)

u0 = [0.85, 1e-5, 0.2, 0.79, 1.2]
lbound = [0.6, 0.0, 0.0, 0.0, 0.0]
ubound = [1.0, 0.05, 0.5, 0.99, 1.8]

optf_35_2 = OptimizationFunction(loss_35_2, adtype)
optprob_35_2 = OptimizationProblem(optf_35_2, u0, lb = lbound, ub = ubound)

sol35_2 = solve(optprob_35_2, Optim.BFGS())

df35_4[4, 8] = df35_4[3, 8]
loss_35_4(u, p) = fermentation_loss(init_st35_4, df35_4, u, 0.8)
predictor_35_4(u) = mixed_culture_predictor(init_st35_4, df35_4, u, 0.8)

u0 = [0.85, 1e-5, 0.3, 0.5, 1.3]
lbound = [0.6, 0.0, 0.0, 0.0, 1.0]
ubound = [1.0, 0.05, 0.5, 0.9, 1.8]

optf_35_4 = OptimizationFunction(loss_35_4, adtype)
optprob_35_4 = OptimizationProblem(optf_35_4, u0, lb = lbound, ub = ubound)

sol35_4 = solve(optprob_35_4, Optim.BFGS())

df35_8[4, 8] = df35_8[2, 8]
loss_35_8(u, p) = fermentation_loss(init_st35_8, df35_8, u, 0.8)
predictor_35_8(u) = mixed_culture_predictor(init_st35_8, df35_8, u, 0.8)

u0 = [0.85, 1e-5, 0.3, 0.5, 1.3]
lbound = [0.6, 0.0, 0.0, 0.0, 1.0]
ubound = [1.0, 0.05, 0.5, 0.9, 1.8]

optf_35_8 = OptimizationFunction(loss_35_8, adtype)
optprob_35_8 = OptimizationProblem(optf_35_8, u0, lb= lbound, ub = ubound)

sol35_8 = solve(optprob_35_8, Optim.BFGS())

loss_40_0(u, p) = fermentation_loss(init_st40_0, df40_0, u, 0.8)
predictor_40_0(u) = mixed_culture_predictor(init_st40_0, df40_0, u, 0.8)

u0 = [0.85, 0.16, 0.1, 1e-5, 0.3]
lbound = [0.8, 0.0, 0.0, 0.0, 0.0]
ubound = [1.0, 0.3, 0.3, 0.1, 1.0]

optf_40_0 = OptimizationFunction(loss_40_0, adtype)
optprob_40_0 = OptimizationProblem(optf_40_0, u0, lb = lbound, ub = ubound)

sol40_0 = solve(optprob_40_0, Optim.BFGS())

loss_40_1(u, p) = fermentation_loss(init_st40_1, df40_1, u, 0.8)
predictor_40_1(u) = mixed_culture_predictor(init_st40_1, df40_1, u, 0.8)

u0 = [0.89, 0.16, 0.1, 0.1, 0.3]
lbound = [0.8, 0.0, 0.0, 0.0, 0.0]
ubound = [1.0, 0.5, 0.5, 0.3, 1.5]

optf_40_1 = OptimizationFunction(loss_40_1, adtype)
optprob_40_1 = OptimizationProblem(optf_40_1, u0, lb = lbound, ub = ubound)

sol40_1 = solve(optprob_40_1, Optim.BFGS())

loss_40_2(u, p) = fermentation_loss(init_st40_2, df40_2, u, 0.8)
predictor_40_2(u) = mixed_culture_predictor(init_st40_2, df40_2, u, 0.8)

u0 = [0.85, 0.45, 0.5, 0.03, 1.0]
lbound = [0.8, 0.0, 0.0, 0.0, 0.0]
ubound = [1.0, 0.5, 0.6, 0.3, 1.5]

optf_40_2 = OptimizationFunction(loss_40_2, adtype)
optprob_40_2 = OptimizationProblem(optf_40_2, u0, lb = lbound, ub = ubound)

sol40_2 = solve(optprob_40_2, Optim.BFGS())

loss_40_4(u, p) = fermentation_loss(init_st40_4, df40_4, u, 0.8)
predictor_40_4(u) = mixed_culture_predictor(init_st40_4, df40_4, u, 0.8)

u0 = [0.85, 0.45, 0.50, 0.03, 1.0]
lbound = [0.8, 0.0, 0.0, 0.0, 0.0]
ubound = [1.0, 0.5, 0.6, 0.3, 1.5]

optf_40_4 = OptimizationFunction(loss_40_4, adtype)
optprob_40_4 = OptimizationProblem(optf_40_4, u0, lb = lbound, ub = ubound)

sol40_4 = solve(optprob_40_4, Optim.BFGS())

loss_40_8(u, p) = fermentation_loss(init_st40_8, df40_8, u, 0.8)
predictor_40_8(u) = mixed_culture_predictor(init_st40_8, df40_8, u, 0.8)

u0 = [0.85, 0.3, 0.50, 0.03, 0.8]
lbound = [0.7, 0.0, 0.0, 0.0, 0.0]
ubound = [1.0, 0.4, 0.7, 0.3, 1.5]

optf_40_8 = OptimizationFunction(loss_40_8, adtype)
optprob_40_8 = OptimizationProblem(optf_40_8, u0, lb = lbound, ub = ubound)

sol40_8 = solve(optprob_40_8, Optim.BFGS())

components = ["init_st", "df", "sol"]
temp = ["35", "40"]
mix_amount = ["0", "1", "2", "4", "8"]
v = 0.8

var_names = String[]
for comp in components
    for T in temp
	for amount in mix_amount
	    push!(var_names, comp*T*"_"*amount)
	end
    end
end

symbol_vars = reshape(Symbol.(var_names), 10, 3)

v_array = Symbol[]
[push!(v_array, :v) for i in 1:10]

final_symbols = hcat(symbol_vars, v_array)

key_names = String[]
for T in temp
    for amount in mix_amount
	push!(key_names, T*"_"*amount)
    end
end

final_values = eval.(final_symbols)
[final_values[i, 3] = final_values[i, 3].u for i in 1:10]

evaled_dict = Dict([(key_names[i], final_values[i, :]) for i in 1:10])

wsave(datadir("simulations", "metabolic_pathways.jld2"), evaled_dict)
