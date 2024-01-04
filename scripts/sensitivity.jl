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

using Interpolations, GlobalSensitivity, Statistics

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
    for i in 1:200
        lact_sens = gsa(lact_interp, Morris(), bounds)

        acet_sens = gsa(acet_interp, Morris(), bounds)

        prop_sens = gsa(prop_interp, Morris(), bounds)

        eth_sens = gsa(eth_interp, Morris(), bounds)

        push!(sens_mean_vector, [lact_sens.means, acet_sens.means, prop_sens.means, eth_sens.means])
    end

    return mean(sens_mean_vector)
end

sens_bounds = [[0,8],[35,40]]
sens_bound_35 = [[0,8],[35,35.1]]
sens_bound_40 = [[0,8],[39.9,40]]
sens_bound_low = [[0,2],[35,40]]
sens_bound_high = [[2, 8],[35,40]]

total_sens = sens_analysis(sens_bounds)
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

# We also want to visualize these results. Heatmaps are a good way of
# making this visualization and the CairoMakie package provides nice
# behaviour for this.
using CairoMakie

# We need one Matrix instead of Vectors of vectors for the data
total_sens2 = vcat(total_sens[1], total_sens[2], total_sens[3], total_sens[4])
sens_35_2 = vcat(sens_35[1], sens_35[2], sens_35[3], sens_35[4])[:,1]
sens_40_2 = vcat(sens_40[1], sens_40[2], sens_40[3], sens_40[4])[:,1]
sens_temp = hcat(sens_35_2, sens_40_2)
sens_low2 = vcat(sens_low[1], sens_low[2], sens_low[3], sens_low[4])
sens_high2 = vcat(sens_high[1], sens_high[2], sens_high[3], sens_high[4])

x_label = ["Lactate", "Acetate", "Propionate", "Ethanol"]
y_label = ["Mix Amount", "Temperature"]

# Make the figures
gs_fig = Figure(size = (600, 400))
ax, hm = CairoMakie.heatmap(gs_fig[1,1], total_sens2, axis = (xticks = (1:4, x_label), yticks = (1:2, y_label), title = "Global Sensitivity Analysis"))
Colorbar(gs_fig[1, 2], hm)
save(plotsdir("sensitivity/global_sens.png"), gs_fig)

sfig_temp = Figure(size = (600, 400))
ax1, hm1 = CairoMakie.heatmap(sfig_temp[1,1], sens_temp, axis = (xticks = (1:4, x_label), yticks = (1:2, ["35 C", "40 C"]), title = "Sensitivity to mix amount in specific temperature"))
Colorbar(sfig_temp[1, 2], hm1)
save(plotsdir("sensitivity/temp_sens.png"), sfig_temp)

sens_low_fig = Figure(size = (600, 400))
ax, hm = CairoMakie.heatmap(sens_low_fig[1,1], sens_low2, axis = (xticks = (1:4, x_label), yticks = (1:2, y_label), title = "Sensitivity in mix amounts 0-2 ml"))
Colorbar(sens_low_fig[1, 2], hm)
save(plotsdir("sensitivity/sens_low.png"), sens_low_fig)

sens_high_fig = Figure(size = (600, 400))
ax, hm = CairoMakie.heatmap(sens_high_fig[1,1], sens_high2, axis = (xticks = (1:4, x_label), yticks = (1:2, y_label), title = "Sensitivity in mix amounts 2-8 ml"))
Colorbar(sens_high_fig[1, 2], hm)
save(plotsdir("sensitivity/sens_high.png"), sens_high_fig)

