using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("filenames.jl"))
using CSV, DataFrames, Statistics, Distributions

include(scriptsdir("hypothesis_sensitivity_preprocessing.jl"))

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

# For the Morris sensitivity analysis, we need one Matrix instead of
# Vectors of vectors for each data set. Furthermore, the data from the
# sensitivity analyses in the two temperatures, don't need to be
# plotted separately, as its going to be one row each, compared to the
# others being two rows (one for mix amount sensitivity and one for
# temperature).
total_sens2 = vcat(total_sens[1], total_sens[2], total_sens[3], total_sens[4])
sens_35_2 = vcat(sens_35[1], sens_35[2], sens_35[3], sens_35[4])[:,1]
sens_40_2 = vcat(sens_40[1], sens_40[2], sens_40[3], sens_40[4])[:,1]
sens_temp = hcat(sens_35_2, sens_40_2)
sens_low2 = vcat(sens_low[1], sens_low[2], sens_low[3], sens_low[4])
sens_high2 = vcat(sens_high[1], sens_high[2], sens_high[3], sens_high[4])

# For the Sobol data, we just want to add a column containing the
# interaction, which for this system can be 1 - the sum of the other
# terms.
total_sens_sobol_data = vcat(total_sens_sobol, [1 - sum(total_sens_sobol[:, i]) for i in 1:4]')
sens_low_sobol_data = vcat(sens_low_sobol, [1 - sum(sens_low_sobol[:, i]) for i in 1:4]')
sens_high_sobol_data = vcat(sens_high_sobol, [1 - sum(sens_high_sobol[:, i]) for i in 1:4]')

names = ["Mix Amount", "Temperature", "Interaction"]

# Save the data of the Morris analysis
total_sens_morris_table = Tables.table(hcat(names[1:2], total_sens2'), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "total_sens_morris.csv"), total_sens_morris_table)
total_sens_morris_df = DataFrame(total_sens_morris_table)

sens_low_morris_table = Tables.table(hcat(names[1:2], sens_low2'), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "sens_low_morris.csv"), sens_low_morris_table)
sens_low_morris_df = DataFrame(sens_low_morris_table)

sens_high_morris_table = Tables.table(hcat(names[1:2], sens_high2'), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "sens_high_morris.csv"), sens_high_morris_table)
sens_high_morris_df = DataFrame(sens_high_morris_table)

temp_sens_morris_table = Tables.table(hcat(["35 C", "40 C"], sens_temp'), header = [:Temperature, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "temp_sens_morris.csv"), temp_sens_morris_table)
temp_sens_morris_df = DataFrame(temp_sens_morris_table)

# Save the data of the Sobol analysis.
total_sens_sobol_table = Tables.table(hcat(names, total_sens_sobol_data), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "total_sens_sobol.csv"), total_sens_sobol_table)
total_sens_sobol_df = DataFrame(total_sens_sobol_table)

sens_low_sobol_table = Tables.table(hcat(names, sens_low_sobol_data), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "low_sens_sobol.csv"), sens_low_sobol_table)
sens_low_sobol_df = DataFrame(sens_low_sobol_table)

sens_high_sobol_table = Tables.table(hcat(names, sens_high_sobol_data), header = [:Variable, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "high_sens_sobol.csv"), sens_high_sobol_table)
sens_high_sobol_df = DataFrame(sens_high_sobol_table)

using CairoMakie

x_label = ["Lactate", "Acetate", "Propionate", "Ethanol"]
y_label = ["Mix Amount", "Temperature"]

# Make the Morris plots
gs_fig = Figure(size = (600, 400))
ax, hm = CairoMakie.heatmap(gs_fig[1,1], total_sens2, axis = (xticks = (1:4, x_label), yticks = (1:2, y_label), title = "Global Sensitivity Analysis"))
Colorbar(gs_fig[1, 2], hm)
save(plotsdir("sensitivity/global_morris.png"), gs_fig)

sfig_temp = Figure(size = (600, 400))
ax1, hm1 = CairoMakie.heatmap(sfig_temp[1,1], sens_temp, axis = (xticks = (1:4, x_label), yticks = (1:2, ["35 C", "40 C"]), title = "Sensitivity to mix amount in specific temperature"))
Colorbar(sfig_temp[1, 2], hm1)
save(plotsdir("sensitivity/temp_morris.png"), sfig_temp)

sens_low_fig = Figure(size = (600, 400))
ax, hm = CairoMakie.heatmap(sens_low_fig[1,1], sens_low2, axis = (xticks = (1:4, x_label), yticks = (1:2, y_label), title = "Sensitivity in mix amounts 0-2 ml"))
Colorbar(sens_low_fig[1, 2], hm)
save(plotsdir("sensitivity/morris_low.png"), sens_low_fig)

sens_high_fig = Figure(size = (600, 400))
ax, hm = CairoMakie.heatmap(sens_high_fig[1,1], sens_high2, axis = (xticks = (1:4, x_label), yticks = (1:2, y_label), title = "Sensitivity in mix amounts 2-8 ml"))
Colorbar(sens_high_fig[1, 2], hm)
save(plotsdir("sensitivity/morris_high.png"), sens_high_fig)

# Make the Sobol plots
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
