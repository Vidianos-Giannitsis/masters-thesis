date = "23_10"
df2310_1_conc = process_area_data2(get_area_csv(date, "1"), get_conc_csv(date, "1"))
t1 = df2310_1_conc.Time

df2310_2_conc = process_area_data2(get_area_csv(date, "2"), get_conc_csv(date, "2"))
t2 = df2310_2_conc.Time

V1 = [800, 788.83, 777.65, 766.48, 755.3, 744.13, 732.95, 708.95, 697.1, 685.25, 662.6, 650.75, 638.9, 614.9, 603.05, 591.2, 567.2, 555.35, 543.45, 513.45, 500.0]./1000
select!(df2310_1_conc, Not(:Time))
df2310_1_mass = df2310_1_conc.*V1

V2 = [800, 788.83, 775.63, 752.305, 740.46, 728.61, 705.96, 694.11, 682.26, 658.26, 646.41, 634.56, 610.56, 598.71, 586.86, 556.86, 543.56]./1000
select!(df2310_2_conc, Not(:Time))
df2310_2_mass = df2310_2_conc.*V2

df2310_1_total = map(sum, eachrow(df2310_1_mass))
df2310_2_total = map(sum, eachrow(df2310_2_mass))

df2310_1_sugars = map(sum, eachrow(df2310_1_mass[:, 1:3]))
df2310_2_sugars = map(sum, eachrow(df2310_2_mass[:, 1:3]))

df2310_1_prod = map(sum, eachrow(df2310_1_mass[:, 4:7]))
df2310_2_prod = map(sum, eachrow(df2310_2_mass[:, 4:7]))


plot_type = "mass_scatter"

suc_scatter = scatter(t1, [df2310_1_conc.Sucrose], label = "1", title = "Sucrose Mass",
		      xlabel = "Time (h)", ylabel = "Sucrose (g)", markersize = 6)
scatter!(t2, df2310_2_conc.Sucrose, label = "2", markersize = 6)
savefig(suc_scatter, get_plot_name("sucrose", date, plot_type))

gluc_scatter = scatter(t1, [df2310_1_conc.Glucose], label = "1", title = "Glucose Mass",
		      xlabel = "Time (h)", ylabel = "Glucose (g)", markersize = 6)
scatter!(t2, df2310_2_conc.Glucose, label = "2", markersize = 6)
savefig(gluc_scatter, get_plot_name("glucose", date, plot_type))

fruc_scatter = scatter(t1, [df2310_1_conc.Fructose], label = "1", title = "Fructose Mass",
		      xlabel = "Time (h)", ylabel = "Fructose (g)", markersize = 6)
scatter!(t2, df2310_2_conc.Fructose, label = "2", markersize = 6)
savefig(fruc_scatter, get_plot_name("fructose", date, plot_type))

lact_scatter = scatter(t1, [df2310_1_conc.Lactate], label = "1", title = "Lactate Mass",
		      xlabel = "Time (h)", ylabel = "Lactate (g)", markersize = 6)
scatter!(t2, df2310_2_conc.Lactate, label = "2", markersize = 6)
savefig(lact_scatter, get_plot_name("lactate", date, plot_type))

ac_scatter = scatter(t1, [df2310_1_conc.Acetate], label = "1", title = "Acetate Mass",
		      xlabel = "Time (h)", ylabel = "Acetate (g)", markersize = 6)
scatter!(t2, df2310_2_conc.Acetate, label = "2", markersize = 6)
savefig(ac_scatter, get_plot_name("acetate", date, plot_type))

prop_scatter = scatter(t1, [df2310_1_conc.Propionate], label = "1", title = "Propionate Mass",
		      xlabel = "Time (h)", ylabel = "Propionate (g)", markersize = 6)
scatter!(t2, df2310_2_conc.Propionate, label = "2", markersize = 6)
savefig(prop_scatter, get_plot_name("propionate", date, plot_type))

eth_scatter = scatter(t1, [df2310_1_conc.Ethanol], label = "1", title = "Ethanol Mass",
		      xlabel = "Time (h)", ylabel = "Ethanol (g)", markersize = 6)
scatter!(t2, df2310_2_conc.Ethanol, label = "2", markersize = 6)
savefig(eth_scatter, get_plot_name("ethanol", date, plot_type))

scatter_final = plot(suc_scatter, gluc_scatter, fruc_scatter,
			 lact_scatter, ac_scatter, prop_scatter,
			 eth_scatter, layout = 9, size = (1350, 900))
savefig(scatter_final, get_plot_name("final", date, plot_type))


plot_type = "mass"

total_mass_2310 = plot(t1, df2310_1_total, title = "Total Mass",
		       xlabel = "Time (h)", ylabel = "Mass (g)",
		       linecolor = "#009AFA", label = "(1)")
plot!(t2, df2310_2_total, title = "Total Mass",
      xlabel = "Time (h)", ylabel = "Mass (g)",
      linecolor = "#E36F47", label = "(2)")
scatter!(t1, df2310_1_total, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_total, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(total_mass_2310, get_plot_name("total", date, plot_type))

sugars_mass_2310 = plot(t1, df2310_1_sugars, title = "Sugars Mass",
			  xlabel = "Time (h)", ylabel = "Mass (g)",
			  linecolor = "#009AFA", label = "(1)")
plot!(t2, df2310_2_sugars, title = "Sugars Mass",
      xlabel = "Time (h)", ylabel = "Mass (g)",
      linecolor = "#E36F47", label = "(2)")
scatter!(t1, df2310_1_sugars, markersize = 6, markercolor = "#009AFA", label = "(1)")
scatter!(t2, df2310_2_sugars, markersize = 6, markercolor = "#E36F47", label = "(2)")
savefig(sugars_mass_2310, get_plot_name("sugars", date, plot_type))

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
savefig(prod_mass_2310, get_plot_name("product", date, plot_type))

final_plot_2310 = plot(sugars_mass_2310, prod_mass_2310, total_mass_2310,
		       size = (1200, 800))
savefig(final_plot_2310, get_plot_name("total_plots", date, plot_type))

comp_plot_2310 = plot(sugars_conc_2310, prod_conc_2310, total_conc_2310,
		      sugars_mass_2310, prod_mass_2310, total_mass_2310,
		      size = (1200, 800), layout = (2,3))
savefig(comp_plot_2310, get_plot_name("total_comp_conc", date, plot_type))
