using DrWatson
@quickactivate "Masters_Thesis"

using CSV, DataFrames, StatsPlots

V1 = [800, 788.83, 777.65, 766.48, 755.3, 744.13, 732.95, 708.95, 697.1, 685.25, 662.6, 650.75, 638.9, 614.9, 603.05, 591.2, 567.2, 555.35, 543.45, 513.45, 500.0]./1000
df2310_1_conc = CSV.read(datadir("exp_pro/hplc_conc_23_10_1.csv"), DataFrame)
t1 = df2310_1_conc.Time
select!(df2310_1_conc, Not(:Time))
df2310_1_mass = df2310_1_conc.*V1

V2 = [800, 788.83, 775.63, 752.305, 740.46, 728.61, 705.96, 694.11, 682.26, 658.26, 646.41, 634.56, 610.56, 598.71, 586.86, 556.86, 543.56]./1000
df2310_2_conc = CSV.read(datadir("exp_pro/hplc_conc_23_10_2.csv"), DataFrame)
t2 = df2310_2_conc.Time
select!(df2310_2_conc, Not(:Time))
df2310_2_mass = df2310_2_conc.*V2

df2310_1_total = map(sum, eachrow(df2310_1_mass))
df2310_2_total = map(sum, eachrow(df2310_2_mass))

df2310_1_sugars = map(sum, eachrow(df2310_1_mass[:, 1:3]))
df2310_2_sugars = map(sum, eachrow(df2310_2_mass[:, 1:3]))

df2310_1_prod = map(sum, eachrow(df2310_1_mass[:, 4:7]))
df2310_2_prod = map(sum, eachrow(df2310_2_mass[:, 4:7]))

total_mass_2310 = plot(t1, df2310_1_total, title = "Total Mass",
                       xlabel = "Time (h)", ylabel = "Mass (g)",
                       linecolor = "#009AFA", label = "(1)")
plot!(t2, df2310_2_total, title = "Total Mass",
      xlabel = "Time (h)", ylabel = "Mass (g)",
      linecolor = "#E36F47", label = "(2)")
scatter!(t1, df2310_1_total, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_total, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(total_mass_2310, plotsdir("23_10/total_mass_23_10.png"))

sugars_mass_2310 = plot(t1, df2310_1_sugars, title = "Sugars Mass",
                          xlabel = "Time (h)", ylabel = "Mass (g)",
                          linecolor = "#009AFA", label = "(1)")
plot!(t2, df2310_2_sugars, title = "Sugars Mass",
      xlabel = "Time (h)", ylabel = "Mass (g)",
      linecolor = "#E36F47", label = "(2)")
scatter!(t1, df2310_1_sugars, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_sugars, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(sugars_mass_2310, plotsdir("23_10/sugars_mass_23_10_1.png"))

prod_mass_2310 = plot(t1, df2310_1_prod, title = "Product Mass",
                        xlabel = "Time (h)", ylabel = "Mass (g)",
                        linecolor = "#009AFA", legend = :bottomright,
                        label = "(1)")
plot!(t2, df2310_2_prod, title = "Product Mass",
      xlabel = "Time (h)", ylabel = "Mass (g)",
      linecolor = "#E36F47", legend = :bottomright,
      label = "(2)")
scatter!(t1, df2310_1_prod, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_prod, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(prod_mass_2310, plotsdir("23_10/prod_mass_23_10_1.png"))

final_plot_2310 = plot(sugars_mass_2310, prod_mass_2310, total_mass_2310,
                       size = (1200, 800))
savefig(final_plot_2310, plotsdir("23_10/total_mass_plots_23_10.png"))

