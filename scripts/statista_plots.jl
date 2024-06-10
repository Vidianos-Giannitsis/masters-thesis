# This file attempts to recreate the statista plots in Julia so they
# conform to the color theme used in my thesis and also to have larger
# font size because they are not at all readable

using Plots, CairoMakie

# FW produced worldwide by sector
nums = [931, 118, 244, 569]
labels = ["Total", "Retail", "Food Service", "Household"]

fw_prod = bar(200:200:800, nums, yticks = (200:200:800, labels), orientation = :h, xticks = (0:200:1000), xlabel = "Waste in million metric tons", title = "Total food waste produced worldwide in 2019, by sector\n Data provided by Statista", size = (900, 600), legend = false, fillcolor = ["#E36F47", "#009AFA", "#009AFA", "#009AFA"], ytickfontsize = 14, xtickfontsize = 12, titlefontsize = 16, xlabelfontsize = 14)
annotate!(466, 200, text("931", :white))
annotate!(122, 600, text("244", :white))
annotate!(59, 400, text("118", :white))
annotate!(285, 800, text("569", :white))
savefig(fw_prod, plotsdir("statistics", "fw_by_sector_julia.svg"))

# Pie waste treatment
labels = ["Recycling", "Backfilling", "Energy recovery", "Landfilled", "Other disposal", "Incineration without\n energy recovery"]
nums = [39.2, 14.6, 6.4, 31.3, 8.1, 0.5]
colors = palette(:default)[1:6]

waste_treat = Figure(size = (650, 500))
Label(waste_treat[1,1:2], "Distribution of waste treatment technologies\n in the European Union in 2020.\n Data provided by Statista", fontsize = 22)
ax, plt = Makie.pie(waste_treat[2,1], nums, color = colors)
hidedecorations!(ax)
hidespines!(ax)
Legend(waste_treat[2,2], [PolyElement(color=c) for c in colors], labels, framevisible=false, labelsize = 20)
save(plotsdir("statistics", "waste_treatment_technology_dist.png"), waste_treat)
