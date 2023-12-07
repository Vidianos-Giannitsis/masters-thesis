using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("hplc_analysis.jl"))
include(srcdir("filenames.jl"))

date = "23_10"
df2310_1_conc = process_area_data2(get_area_csv(date, "1"), get_conc_csv(date, "1"))
t1 = df2310_1_conc.Time

df2310_2_conc = process_area_data2(get_area_csv(date, "2"), get_conc_csv(date, "2"))
t2 = df2310_2_conc.Time

plot_type = "scatter"

suc_scatter = scatter(t1, [df2310_1_conc.Sucrose], label = "1", title = "Sucrose Concentration",
		      xlabel = "Time (h)", ylabel = "Sucrose (g/l)", markersize = 6)
scatter!(t2, df2310_2_conc.Sucrose, label = "2", markersize = 6)
savefig(suc_scatter, get_plot_name("sucrose", date, plot_type))

gluc_scatter = scatter(t1, [df2310_1_conc.Glucose], label = "1", title = "Glucose Concentration",
		      xlabel = "Time (h)", ylabel = "Glucose (g/l)", markersize = 6)
scatter!(t2, df2310_2_conc.Glucose, label = "2", markersize = 6)
savefig(gluc_scatter, get_plot_name("glucose", date, plot_type))

fruc_scatter = scatter(t1, [df2310_1_conc.Fructose], label = "1", title = "Fructose Concentration",
		      xlabel = "Time (h)", ylabel = "Fructose (g/l)", markersize = 6)
scatter!(t2, df2310_2_conc.Fructose, label = "2", markersize = 6)
savefig(fruc_scatter, get_plot_name("fructose", date, plot_type))

lact_scatter = scatter(t1, [df2310_1_conc.Lactate], label = "1", title = "Lactate Concentration",
		      xlabel = "Time (h)", ylabel = "Lactate (g/l)", markersize = 6)
scatter!(t2, df2310_2_conc.Lactate, label = "2", markersize = 6)
savefig(lact_scatter, get_plot_name("lactate", date, plot_type))

ac_scatter = scatter(t1, [df2310_1_conc.Acetate], label = "1", title = "Acetate Concentration",
		      xlabel = "Time (h)", ylabel = "Acetate (g/l)", markersize = 6)
scatter!(t2, df2310_2_conc.Acetate, label = "2", markersize = 6)
savefig(ac_scatter, get_plot_name("acetate", date, plot_type))

prop_scatter = scatter(t1, [df2310_1_conc.Propionate], label = "1", title = "Propionate Concentration",
		      xlabel = "Time (h)", ylabel = "Propionate (g/l)", markersize = 6)
scatter!(t2, df2310_2_conc.Propionate, label = "2", markersize = 6)
savefig(prop_scatter, get_plot_name("propionate", date, plot_type))

eth_scatter = scatter(t1, [df2310_1_conc.Ethanol], label = "1", title = "Ethanol Concentration",
		      xlabel = "Time (h)", ylabel = "Ethanol (g/l)", markersize = 6)
scatter!(t2, df2310_2_conc.Ethanol, label = "2", markersize = 6)
savefig(eth_scatter, get_plot_name("ethanol", date, plot_type))

scatter_final = plot(suc_scatter, gluc_scatter, fruc_scatter,
			 lact_scatter, ac_scatter, prop_scatter,
			 eth_scatter, layout = 9, size = (1350, 900))
savefig(scatter_final, get_plot_name("final", date, plot_type))


df2310_1_total = map(sum, eachrow(df2310_1_conc[:, 2:8]))
df2310_2_total = map(sum, eachrow(df2310_2_conc[:, 2:8]))

df2310_1_sugars = map(sum, eachrow(df2310_1_conc[:, 2:4]))
df2310_2_sugars = map(sum, eachrow(df2310_2_conc[:, 2:4]))

df2310_1_prod = map(sum, eachrow(df2310_1_conc[:, 5:8]))
df2310_2_prod = map(sum, eachrow(df2310_2_conc[:, 5:8]))


date = "23_10"
plot_type = "scatter"

total_conc_2310 = plot(t1, df2310_1_total, title = "Total Concentration",
		       xlabel = "Time (h)", ylabel = "Concentration (g/l)",
		       linecolor = "#009AFA", label = "(1)")
plot!(t2, df2310_2_total, title = "Total Concentration",
      xlabel = "Time (h)", ylabel = "Concentration (g/l)",
      linecolor = "#E36F47", label = "(2)")
scatter!(t1, df2310_1_total, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_total, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(total_conc_2310, get_plot_name("total_conc", date, plot_type))

sugars_conc_2310 = plot(t1, df2310_1_sugars, title = "Sugars Concentration",
			  xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			  linecolor = "#009AFA", label = "(1)")
plot!(t2, df2310_2_sugars, title = "Sugars Concentration",
      xlabel = "Time (h)", ylabel = "Concentration (g/l)",
      linecolor = "#E36F47", label = "(2)")
scatter!(t1, df2310_1_sugars, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_sugars, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(sugars_conc_2310, get_plot_name("sugars_conc", date, plot_type))

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
savefig(prod_conc_2310, get_plot_name("product_conc", date, plot_type))

final_plot_2310 = plot(sugars_conc_2310, prod_conc_2310, total_conc_2310,
		       size = (1200, 800))
savefig(final_plot_2310, get_plot_name("total_plots", date, plot_type))
