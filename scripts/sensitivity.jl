using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("filenames.jl"))
using CSV, DataFrames

# Read all the data
exp_35 = "10_11"
exp_40 = "28_11"
exp_45 = "23_10"
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

# Experiment @45 C (take only one of the two)
df45 = CSV.read(get_conc_csv(exp_45, mix_amount[3]), DataFrame)

# Take the maximum value of each product in each df
prod35_0 = map(maximum, eachcol(df35_0[:, 5:8]))
prod35_1 = map(maximum, eachcol(df35_1[:, 5:8]))
prod35_2 = map(maximum, eachcol(df35_2[:, 5:8]))
prod35_4 = map(maximum, eachcol(df35_4[:, 5:8]))
prod35_8 = map(maximum, eachcol(df35_8[:, 5:8]))

prod40_0 = map(maximum, eachcol(df40_0[:, 5:8]))
prod40_1 = map(maximum, eachcol(df40_1[:, 5:8]))
prod40_2 = map(maximum, eachcol(df40_2[:, 5:8]))
prod40_4 = map(maximum, eachcol(df40_4[:, 5:8]))
prod40_8 = map(maximum, eachcol(df40_8[:, 5:8]))

prod45 = map(maximum, eachcol(df45[:, 5:8]))

prod = hcat(prod35_0, prod35_1, prod35_2, prod35_4, prod35_8, prod40_0, prod40_1, prod40_2, prod40_4, prod40_8)

# Collect the 4 vectors which have the output variable in every condition
lact = prod[1,:]
acet = prod[2,:]
prop = prod[3,:]
eth = prod[4,:]

nodes = ([0.0, 1.0, 2.0, 4.0, 8.0], [35, 40])
lact_itp = interpolate(nodes, reshape(lact, 5, 2), Gridded(Linear()))
acet_itp = interpolate(nodes, reshape(acet, 5, 2), Gridded(Linear()))
prop_itp = interpolate(nodes, reshape(prop, 5, 2), Gridded(Linear()))
eth_itp = interpolate(nodes, reshape(eth, 5, 2), Gridded(Linear()))

function lact_interp(x)
    lact_itp(x[1], x[2])
end

function acet_interp(x)
    acet_itp(x[1], x[2])
end

function prop_interp(x)
    prop_itp(x[1], x[2])
end

function eth_interp(x)
    eth_itp(x[1], x[2])
end

function sens_analysis(bounds)
    sens_mean_vector = []
#    sens_dev_vector = []
    for i in 1:100
        lact_sens = gsa(lact_interp, Morris(), bounds)

        acet_sens = gsa(acet_interp, Morris(), bounds)

        prop_sens = gsa(prop_interp, Morris(), bounds)

        eth_sens = gsa(eth_interp, Morris(), bounds)

        push!(sens_mean_vector, [lact_sens.means, acet_sens.means, prop_sens.means, eth_sens.means])
#        push!(sens_dev_vector, [lact_sens.variances, acet_sens.variances, prop_sens.variances, eth_sens.variances])
    end

    return mean(sens_mean_vector)
end

sens_bound_35 = [[0,8],[35,35.5]]
sens_bounds2 = [[0,8],[35,40]]
sens_bound_40 = [[0,8],[39.5,40]]
sens_bound_low = [[0,2],[35,40]]
sens_bound_high = [[2, 8],[35,40]]

total_sens = sens_analysis(sens_bounds2)
sens_35 = sens_analysis(sens_bound_35)
sens_40 = sens_analysis(sens_bound_40)
sens_low = sens_analysis(sens_bound_low)
sens_high = sens_analysis(sens_bound_high)

# Conclusions: The total sensitivity shows that lactate is positively
# correlated with both mix amount and temperature. Acetate is
# negatively correlated with mix amount and positively with
# temperature, propionate is slightly positively correlated with mix
# amount and a bit more with temperature. Ethanol shows little to no
# correlation with mix amount and negative correlation with
# temperature. However, the ethanol correlation is existent and in
# reality is positive until 2 ml mix and negative after. This can be
# shown if we do a sensitivity analysis with bounds [0,2] and [2,8].

# In low mix amounts, lactate and ethanol have much more positive
# correlation, propionate has higher positive correlation and acetate
# has similarly negative correlation. In high mix amounts, acetate,
# propionate and ethanol have negative correlation and lactate a small
# positive one. This further proves the assumption that increasing the
# mix amount after 2 ml isn't helpful. Concerning temperature in these
# subdomains, its effect is similar. Notable differences are that in
# low mix amounts, acetate doesn't seem to be associated with
# temperature and propionate shows a slightly negative correlation in
# low mix amounts.

# Another subdomain where there is a point in studying the sensitivity
# is temperature. In 40 C, lactate is more strongly associated with
# mix amount, acetate is positively associated (as it is significantly
# produced) and propionate is more positively associated with it. In
# 35 C, acetate shows its negative correlation more and propionate
# also has a small negative correlation. Ethanol on the other hand
# shows a more significant positive correlation with mix amount.

## ML TEST, DIDNT WORK
# Then create the input matrix
X = [35.0 0.0; 35.0 1.0; 35.0 2.0; 35.0 4.0; 35.0 8.0; 40.0 0.0; 40.0 1.0; 40.0 2.0; 40.0 4.0; 40.0 8.0]
X_df = DataFrame(X, [:Temp, :Mix])

# Now that we have the data, we can test various regression algorithms
# and see which works best
using MLJ

# First let's see how linear correlation does (probably not well)
using GLM, MLJGLMInterface
LinearRegressor = @load LinearRegressor pkg = GLM
lm = LinearRegressor()
cv=CV(nfolds=6)

lact_lm = machine(lm, X_df, lact)
fit!(lact_lm)
lm_rep = report(lact_lm)
lm_eval = evaluate!(lact_lm, resampling=cv, measure=[rms, l1, l2])
lm_lact_hat = MLJ.predict_mean(lact_lm, X_df)
lm_rsq = RSquared()(lm_lact_hat, lact)
# R^2 = 0.36

# Let's try decision tree regression
using DecisionTree
DecisionTreeRegressor = @load DecisionTreeRegressor pkg = DecisionTree
rng_seed = 34

dt = DecisionTreeRegressor(rng = rng_seed)
lact_dt = machine(dt, X_df, lact) |> fit!
dt_eval = evaluate!(lact_dt, resampling=cv, measure = [rms, l1, l2])
lact_hat = MLJ.predict_mean(lact_dt, X_df)
dt_rsq = RSquared()(lact_hat, lact)
# Performs even worse

# Let's use XGBoost
using XGBoost
XGBoostRegressor = @load XGBoostRegressor pkg=XGBoost

xgb = XGBoostRegressor(eta = 0.3, max_depth = 3, num_parallel_tree =10,
                       subsample = 0.6, lambda = 0.8)
lact_xgb = machine(xgb, X_df, lact) |> fit!
xgb_lact_eval = evaluate!(lact_xgb, resampling=cv, measure = [rms, l1, l2])
xgb_lact_hat = MLJ.predict(lact_xgb, X_df)
xgb_lact_rsq = RSquared()(xgb_lact_hat, lact)
# Gets very good performance after playing around with the hyperparameters

# Let's see if the others will work well with this parameter set
acet_xgb = machine(xgb, X_df, acet) |> fit!
xgb_acet_eval = evaluate!(acet_xgb, resampling=cv, measure = [rms, l1, l2])
xgb_acet_hat = MLJ.predict(acet_xgb, X_df)
xgb_acet_rsq = RSquared()(xgb_acet_hat, acet)

prop_xgb = machine(xgb, X_df, prop) |> fit!
xgb_prop_eval = evaluate!(prop_xgb, resampling=cv, measure = [rms, l1, l2])
xgb_prop_hat = MLJ.predict(prop_xgb, X_df)
xgb_prop_rsq = RSquared()(xgb_prop_hat, prop)

eth_xgb = machine(xgb, X_df, eth) |> fit!
xgb_eth_eval = evaluate!(eth_xgb, resampling=cv, measure = [rms, l1, l2])
xgb_eth_hat = MLJ.predict(eth_xgb, X_df)
xgb_eth_rsq = RSquared()(xgb_eth_hat, eth)

function predict_conc(x, model)
    reshaped_x = reshape(x, :, 2)
    table_x = Tables.table(reshaped_x)
    df = DataFrame(table_x)
    
    MLJ.predict_mean(model, df)
end

function predict_lact(x)
    predict_conc(x, lact_lm)
end

function predict_acet(x)
    predict_conc(x, acet_xgb)
end

function predict_prop(x)
    predict_conc(x, prop_xgb)
end

function predict_eth(x)
    predict_conc(x, eth_xgb)
end

using GlobalSensitivity
bounds = [[35,40],[0,8]]
lact_sens = gsa(predict_lact, Morris(), bounds)
acet_sens = gsa(predict_acet, Morris(), bounds)
prop_sens = gsa(predict_prop, Morris(), bounds)
eth_sens = gsa(predict_eth, Morris(), bounds)

sens = [lact_sens.means, acet_sens.means, prop_sens.means, eth_sens.means]

x = [35.0 2.0; 36.0 2.0; 37.0 2.0; 38.0 2.0; 39 2.0; 40 2.0]

