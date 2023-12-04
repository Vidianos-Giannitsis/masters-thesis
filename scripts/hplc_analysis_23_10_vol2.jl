using DrWatson
@quickactivate "Masters_Thesis"

using CSV, DataFrames, StatsPlots

df2310_1_conc = CSV.read(datadir("exp_pro/hplc_conc_23_10_1.csv"), DataFrame)
t1 = df2310_1_conc.Time
select!(df2310_1_conc, Not(:Time))
df2310_2_conc = CSV.read(datadir("exp_pro/hplc_conc_23_10_2.csv"), DataFrame)
t2 = df2310_2_conc.Time
select!(df2310_2_conc, Not(:Time))

df2310_1_total = map(sum, eachrow(df2310_1_conc))
df2310_2_total = map(sum, eachrow(df2310_2_conc))

df2310_1_sugars = map(sum, eachrow(df2310_1_conc[:, 1:3]))
df2310_2_sugars = map(sum, eachrow(df2310_2_conc[:, 1:3]))

df2310_1_prod = map(sum, eachrow(df2310_1_conc[:, 4:7]))
df2310_2_prod = map(sum, eachrow(df2310_2_conc[:, 4:7]))

total_conc_2310 = plot(t1, df2310_1_total, title = "Total Concentration",
                       xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                       linecolor = "#009AFA", label = "(1)")
plot!(t2, df2310_2_total, title = "Total Concentration",
      xlabel = "Time (h)", ylabel = "Concentration (g/l)",
      linecolor = "#E36F47", label = "(2)")
scatter!(t1, df2310_1_total, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_total, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(total_conc_2310, plotsdir("23_10/total_conc_23_10.png"))

sugars_conc_2310 = plot(t1, df2310_1_sugars, title = "Sugars Concentration",
                          xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                          linecolor = "#009AFA", label = "(1)")
plot!(t2, df2310_2_sugars, title = "Sugars Concentration",
      xlabel = "Time (h)", ylabel = "Concentration (g/l)",
      linecolor = "#E36F47", label = "(2)")
scatter!(t1, df2310_1_sugars, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_sugars, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(sugars_conc_2310, plotsdir("23_10/sugars_conc_23_10_1.png"))

prod_conc_2310 = plot(t1, df2310_1_prod, title = "Product Concentration",
                        xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                        linecolor = "#009AFA", legend = :bottomright,
                        label = "(1)")
plot!(t2, df2310_2_prod, title = "Product Concentration",
      xlabel = "Time (h)", ylabel = "Concentration (g/l)",
      linecolor = "#E36F47", legend = :bottomright,
      label = "(2)")
scatter!(t1, df2310_1_prod, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_prod, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(prod_conc_2310, plotsdir("23_10/prod_conc_23_10_1.png"))

final_plot_2310 = plot(sugars_conc_2310, prod_conc_2310, total_conc_2310,
                       size = (1200, 800))
savefig(final_plot_2310, plotsdir("23_10/total_plots_23_10.png"))

