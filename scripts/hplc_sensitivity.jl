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

# Define the labels
name_matrix = ["Lactate - Mix Amount", "Acetate - Mix Amount", "Propionate - Mix Amount", "Ethanol - Mix Amount", "Lactate - Temperature", "Acetate - Temperature", "Propionate - Temperature", "Ethanol - Temperature"]

# Sort the data and their labels
reshaped_sens_total = reshape(total_sens2, 1:8)
sorted_indices_total = sortperm(abs.(reshaped_sens_total))

sorted_sens_total = reshaped_sens_total[sorted_indices_total]
sorted_names_total = name_matrix[sorted_indices_total]

# Define an x-range
xrange_total = LinRange(minimum(sorted_sens_total), maximum(sorted_sens_total), 8)

# Define colors based on the sign of sensitivity values
colors_total = ifelse.(sorted_sens_total .< 0, "#440154", "#DCE319")

# Create the tornado plot
global_tornado = bar(xrange_total, sorted_sens_total, color = colors_total,
		     xlabel = "Sensitivity", yticks = (xrange_total, sorted_names_total),
		     orientation = :h, legend = false,
		     title = "Global Sensitivity Analysis",
		     size = (700, 800), tickfontsize = 12, guidefontsize = 14,
		     left_margin = 6Plots.mm, titlefontsize = 18)
savefig(global_tornado, plotsdir("sensitivity", "global_tornado.png"))

# Do this for the low mix amount domain
reshaped_sens_low = reshape(sens_low2, 1:8)
sorted_indices_low = sortperm(abs.(reshaped_sens_low))

sorted_sens_low = reshaped_sens_low[sorted_indices_low]
sorted_names_low = name_matrix[sorted_indices_low]

# Define an x-range
xrange_low = LinRange(minimum(sorted_sens_low), maximum(sorted_sens_low), 8)

# Define colors based on the sign of sensitivity values
colors_low = ifelse.(sorted_sens_low .< 0, "#440154", "#DCE319")

# Create the tornado plot
low_tornado = bar(xrange_low, sorted_sens_low, color = colors_low,
		  xlabel = "Sensitivity", yticks = (xrange_low, sorted_names_low),
		  orientation = :h, legend = false,
		  title = "Sensitivity Analysis - Mix Amounts 0-2 ml",
		  size = (700, 800), tickfontsize = 12, guidefontsize = 14,
		  left_margin = 6Plots.mm, titlefontsize = 15)
savefig(low_tornado, plotsdir("sensitivity", "tornado_low.png"))

# And the high mix amount domain
reshaped_sens_high = reshape(sens_high2, 1:8)
sorted_indices_high = sortperm(abs.(reshaped_sens_high))

sorted_sens_high = reshaped_sens_high[sorted_indices_high]
sorted_names_high = name_matrix[sorted_indices_high]

# Define an x-range
xrange_high = LinRange(minimum(sorted_sens_high), maximum(sorted_sens_high), 8)

# Define colors based on the sign of sensitivity values
colors_high = ifelse.(sorted_sens_high .< 0, "#440154", "#DCE319")

# Create the tornado plot
high_tornado = bar(xrange_high, sorted_sens_high, color = colors_high,
		   xlabel = "Sensitivity", yticks = (xrange_high, sorted_names_high),
		   orientation = :h, legend = false,
		   title = "Sensitivity Analysis - Mix Amounts 2-8 ml",
		   size = (700, 800), tickfontsize = 12, guidefontsize = 14,
		   left_margin = 6Plots.mm, titlefontsize = 15)
savefig(high_tornado, plotsdir("sensitivity", "tornado_high.png"))

high_torn_pres = bar(xrange_high, sorted_sens_high, color = colors_high,
		     xlabel = "Sensitivity",
		     yticks = (xrange_high, sorted_names_high),
		     orientation = :h, legend = false,
		     title = "Mix Amounts 2-8 ml",
		     size = (900, 1000), tickfontsize = 20, xlabelfontsize = 20,
		     left_margin = 9Plots.mm, titlefontsize = 32,
		     right_margin = 4Plots.mm)
savefig(high_torn_pres, plotsdir("sensitivity", "tornado_high.svg"))


# We also want to do a tornado plot of the sensitivity analysis
# performed for each temperature. Theoretically, the sensitivity we
# have is how each parameter affects the system on its own, but making
# the domain smaller (studying each temperature separately) also gave
# interesting results.

name_matrix2 = ["Lactate - 35 C", "Acetate - 35 C", "Propionate - 35 C", "Ethanol - 35 C", "Lactate - 40 C", "Acetate - 40 C", "Propionate - 40 C", "Ethanol - 40 C"]

# Sort the data and their labels
reshaped_sens_temp = reshape(sens_temp, 1:8)
sorted_indices_temp = sortperm(abs.(reshaped_sens_temp))

sorted_sens_temp = reshaped_sens_temp[sorted_indices_temp]
sorted_names_temp = name_matrix2[sorted_indices_temp]

# Define an x-range
xrange_temp = LinRange(minimum(sorted_sens_temp), maximum(sorted_sens_temp), 8)

# Define colors based on the sign of sensitivity values
colors_temp = ifelse.(sorted_sens_temp .< 0, "#440154", "#DCE319")

# Create the tornado plot
temp_tornado = bar(xrange_temp, sorted_sens_temp, color = colors_temp,
		   xlabel = "Sensitivity to Mix Amount",
		   yticks = (xrange_temp, sorted_names_temp),
		   orientation = :h, legend = false,
		   title = "Sensitivity Analysis - Discrete Temperature Ranges",
		   size = (700, 800), tickfontsize = 12,
		   left_margin = 4Plots.mm)
savefig(temp_tornado, plotsdir("sensitivity", "temperature_tornado.png"))

temp_tornado_poster = bar(xrange_temp, sorted_sens_temp, color = colors_temp,
			  xlabel = "Sensitivity to Mix Amount",
			  yticks = (xrange_temp, sorted_names_temp),
			  orientation = :h, legend = false,
			  title = "Discrete Temperatures",
			  size = (800, 900), tickfontsize = 20,
			  xlabelfontsize = 20, titlefontsize = 32,
			  left_margin = 8Plots.mm)
savefig(temp_tornado_poster, plotsdir("sensitivity", "temperature_tornado.svg"))
