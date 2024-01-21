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

function morris_sens_analysis(bounds)
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

function sobol_sens_analysis(bounds)
    lact_sens = gsa(lact_interp, Sobol(), bounds, samples = 500)
    acet_sens = gsa(acet_interp, Sobol(), bounds, samples = 500)
    prop_sens = gsa(prop_interp, Sobol(), bounds, samples = 500)
    eth_sens = gsa(eth_interp, Sobol(), bounds, samples = 500)

    S1_res = hcat(lact_sens.S1, acet_sens.S1, prop_sens.S1, eth_sens.S1)
end

sens_bounds = [[0,8],[35,40]]
sens_bound_35 = [[0,8],[35,35.1]]
sens_bound_40 = [[0,8],[39.9,40]]
sens_bound_low = [[0,2],[35,40]]
sens_bound_high = [[2, 8],[35,40]]

total_sens = morris_sens_analysis(sens_bounds)
sens_35 = morris_sens_analysis(sens_bound_35)
sens_40 = morris_sens_analysis(sens_bound_40)
sens_low = morris_sens_analysis(sens_bound_low)
sens_high = morris_sens_analysis(sens_bound_high)

total_sens_sobol = sobol_sens_analysis(sens_bounds)
sens_low_sobol = sobol_sens_analysis(sens_bound_low)
sens_high_sobol = sobol_sens_analysis(sens_bound_high)

total_sens_sobol_data = vcat(total_sens_sobol, [1 - sum(total_sens_sobol[:, i]) for i in 1:4]')
sens_low_sobol_data = vcat(sens_low_sobol, [1 - sum(sens_low_sobol[:, i]) for i in 1:4]')
sens_high_sobol_data = vcat(sens_high_sobol, [1 - sum(sens_high_sobol[:, i]) for i in 1:4]')

names = ["Mix Amount", "Temperature", "Interaction"]
total_sens_sobol_table = Tables.table(hcat(names, total_sens_sobol_data), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "total_sens_sobol.csv"), total_sens_sobol_table)
total_sens_sobol_df = DataFrame(total_sens_sobol_table)

sens_low_sobol_table = Tables.table(hcat(names, sens_low_sobol_data), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "low_sens_sobol.csv"), sens_low_sobol_table)
sens_low_sobol_df = DataFrame(sens_low_sobol_table)

sens_high_sobol_table = Tables.table(hcat(names, sens_high_sobol_data), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "high_sens_sobol.csv"), sens_high_sobol_table)
sens_high_sobol_df = DataFrame(sens_high_sobol_table)

# Conclusions: The total sensitivity shows that lactate is positively
# correlated with both mix amount and temperature. Acetate is
# negatively correlated with mix amount and positively with
# temperature, propionate is slightly positively correlated with mix
# amount and a bit more with temperature. Ethanol shows little to no
# correlation with mix amount and negative correlation with
# temperature. However, the ethanol correlation is existent and in
# reality is positive until 2 ml mix and negative after. This can be
# shown if we do a sensitivity analysis with bounds [0,2] and [2,8].

# From the Sobol analysis, we can see that lactate is more correlated
# with mix amount than temperature (56% by mix amount, 22% by
# temperature), acetate is significantly correlated (60%) with
# temperature and much less with mix amount, propionate's variability
# is only 30% from temperature and 15% from mix amount, with the
# majority being due to the interaction. Ethanol is almost only
# correlated with temperature as 85% of its variability is on that.

# In low mix amounts, lactate and ethanol have much more positive
# correlation, propionate has higher positive correlation and acetate
# has similarly negative correlation. The Sobol's analysis shows that
# besides ethanol, which remains strongly correlated with temperature,
# the rest of the variables have much less correlation with
# it. Lactate is 90% from mix amount, acetate, 76% and propionate 50%,
# which however also has a 35% dependence from mix amount (varying
# from 0 to 2).

# In high mix amounts, acetate, propionate and ethanol have negative
# correlation and lactate a small positive one. From the Sobol's
# analysis, acetate's variability in mix amounts between 2 and 8 is
# purely based on temperature (99%) and propionates by 86%, although
# ANOVA showed that mix amount has a significant difference in
# both. Lactate in this case has a 22% variability by mix amount and
# 42% by temperature. This strengthens the hypothesis that increasing
# the mix amount beyond 2 ml is insignificant for everything besides
# Lactate and even then, its not worth the added costs. Concerning
# temperature in these subdomains, its effect is similar. Notable
# differences are that in low mix amounts, acetate doesn't seem to be
# associated with temperature and propionate shows a slightly negative
# correlation in low mix amounts.

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

colors = Makie.wong_colors()[1:3]

sobol_tot_fig = Figure(size = (600, 400))
Label(sobol_tot_fig[1,1:3], "Decomposition of Total Variance to the effect of Mix Amount, Temperature and their Interaction")
ax1, plt = pie(sobol_tot_fig[2,1], total_sens_sobol_data[:,1], color = colors, axis = (aspect=DataAspect(), title = "Lactate"))
ax2, plt = pie(sobol_tot_fig[2,2], total_sens_sobol_data[:,2], color = colors, axis = (aspect=DataAspect(), title = "Acetate"))
ax3, plt = pie(sobol_tot_fig[3,1], total_sens_sobol_data[:,3], color = colors, axis = (aspect=DataAspect(), title = "Propionate"))
ax4, plt = pie(sobol_tot_fig[3,2], total_sens_sobol_data[:,4], color = colors, axis = (aspect=DataAspect(), title = "Ethanol"))
hidedecorations!(ax1)
hidedecorations!(ax2)
hidedecorations!(ax3)
hidedecorations!(ax4)
hidespines!(ax1)
hidespines!(ax2)
hidespines!(ax3)
hidespines!(ax4)
Legend(sobol_tot_fig[3,3], [PolyElement(color=c) for c in colors], names, framevisible=false)
save(plotsdir("sensitivity/global_sobol.png"), sobol_tot_fig)

sobol_low_fig = Figure(size = (600, 400))
Label(sobol_low_fig[1,1:3], "Decomposition of Total Variance to the effect of Mix Amount, Temperature and their Interaction\n Results for mix amounts between 0-2 ml")
ax1, plt = pie(sobol_low_fig[2,1], sens_low_sobol_data[:,1], color = colors, axis = (aspect=DataAspect(), title = "Lactate"))
ax2, plt = pie(sobol_low_fig[2,2], sens_low_sobol_data[:,2], color = colors, axis = (aspect=DataAspect(), title = "Acetate"))
ax3, plt = pie(sobol_low_fig[3,1], sens_low_sobol_data[:,3], color = colors, axis = (aspect=DataAspect(), title = "Propionate"))
ax4, plt = pie(sobol_low_fig[3,2], sens_low_sobol_data[:,4], color = colors, axis = (aspect=DataAspect(), title = "Ethanol"))
hidedecorations!(ax1)
hidedecorations!(ax2)
hidedecorations!(ax3)
hidedecorations!(ax4)
hidespines!(ax1)
hidespines!(ax2)
hidespines!(ax3)
hidespines!(ax4)
Legend(sobol_low_fig[3,3], [PolyElement(color=c) for c in colors], names, framevisible=false)
save(plotsdir("sensitivity/low_sobol.png"), sobol_low_fig)

sobol_high_fig = Figure(size = (600, 400))
Label(sobol_high_fig[1,1:3], "Decomposition of Total Variance to the effect of Mix Amount, Temperature and their Interaction\n Results for mix amounts between 2-8 ml")
ax1, plt = pie(sobol_high_fig[2,1], sens_high_sobol_data[:,1], color = colors, axis = (aspect=DataAspect(), title = "Lactate"))
ax2, plt = pie(sobol_high_fig[2,2], sens_high_sobol_data[:,2], color = colors, axis = (aspect=DataAspect(), title = "Acetate"))
ax3, plt = pie(sobol_high_fig[3,1], sens_high_sobol_data[:,3], color = colors, axis = (aspect=DataAspect(), title = "Propionate"))
ax4, plt = pie(sobol_high_fig[3,2], sens_high_sobol_data[:,4], color = colors, axis = (aspect=DataAspect(), title = "Ethanol"))
hidedecorations!(ax1)
hidedecorations!(ax2)
hidedecorations!(ax3)
hidedecorations!(ax4)
hidespines!(ax1)
hidespines!(ax2)
hidespines!(ax3)
hidespines!(ax4)
Legend(sobol_high_fig[3,3], [PolyElement(color=c) for c in colors], names, framevisible=false)
save(plotsdir("sensitivity/high_sobol.png"), sobol_high_fig)

