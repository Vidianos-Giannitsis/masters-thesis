using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("hplc_analysis.jl"))
include(srcdir("filenames.jl"))

date = "28_11"


mix_amount = ["0", "1", "2", "4", "8"]
t = [0, 24, 48, 72]

df0_conc = process_area_data(get_area_csv(date, mix_amount[1]), get_conc_csv(date, mix_amount[1]))
df1_conc = process_area_data(get_area_csv(date, mix_amount[2]), get_conc_csv(date, mix_amount[2]))
df2_conc = process_area_data(get_area_csv(date, mix_amount[3]), get_conc_csv(date, mix_amount[3]))
df4_conc = process_area_data(get_area_csv(date, mix_amount[4]), get_conc_csv(date, mix_amount[4]))
df8_conc = process_area_data(get_area_csv(date, mix_amount[5]), get_conc_csv(date, mix_amount[5]))

plot_type = "scatter"
plot_label = ["0 ml" "1 ml" "2 ml" "4 ml" "8 ml"]

suc_scatter = scatter(t, [df0_conc.Sucrose df1_conc.Sucrose df2_conc.Sucrose df4_conc.Sucrose df8_conc.Sucrose], label = plot_label,
		    xticks = t, title = "Sucrose Concentration",
		    xlabel = "Time (h)", ylabel = "Sucrose (g/l)", markersize = 6)
savefig(suc_scatter, get_plot_name("sucrose", date, plot_type))

gluc_scatter = scatter(t, [df0_conc.Glucose df1_conc.Glucose df2_conc.Glucose df4_conc.Glucose df8_conc.Glucose], label = plot_label,
		       xticks = t, title = "Glucose Concentration",
		       xlabel = "Time (h)", ylabel = "Glucose (g/l)", markersize = 6)
savefig(gluc_scatter, get_plot_name("glucose", date, plot_type))

fruc_scatter = scatter(t, [df0_conc.Fructose df1_conc.Fructose df2_conc.Fructose df4_conc.Fructose df8_conc.Fructose], label = plot_label,
		       xticks = t, title = "Fructose Concentration",
		       xlabel = "Time (h)", ylabel = "Fructose (g/l)", markersize = 6)
savefig(fruc_scatter, get_plot_name("fructose", date, plot_type))

lact_scatter = scatter(t, [df0_conc.Lactate df1_conc.Lactate df2_conc.Lactate df4_conc.Lactate df8_conc.Lactate], label = plot_label,
		       xticks = t, title = "Lactate Concentration",
		       xlabel = "Time (h)", ylabel = "Lactate (g/l)", markersize = 6)
savefig(lact_scatter, get_plot_name("lactate", date, plot_type))

ac_scatter = scatter(t, [df0_conc.Acetate df1_conc.Acetate df2_conc.Acetate df4_conc.Acetate df8_conc.Acetate], label = plot_label,
		     xticks = t, title = "Acetate Concentration",
		     xlabel = "Time (h)", ylabel = "Acetate (g/l)", markersize = 6)
savefig(ac_scatter, get_plot_name("acetate", date, plot_type))

prop_scatter = scatter(t, [df0_conc.Propionate df1_conc.Propionate df2_conc.Propionate df4_conc.Propionate df8_conc.Propionate], label = plot_label,
		       xticks = t, title = "Propionate Concentration",
		       xlabel = "Time (h)", ylabel = "Propionate (g/l)", markersize = 6)
savefig(prop_scatter, get_plot_name("propionate", date, plot_type))

eth_scatter = scatter(t, [df0_conc.Ethanol df1_conc.Ethanol df2_conc.Ethanol df4_conc.Ethanol df8_conc.Ethanol], label = plot_label,
		      xticks = t, title = "Ethanol Concentration",
		      xlabel = "Time (h)", ylabel = "Ethanol (g/l)", markersize = 6)
savefig(eth_scatter, get_plot_name("ethanol", date, plot_type))

pH_scatter = scatter(t, [df0_conc.pH df1_conc.pH df2_conc.pH df4_conc.pH df8_conc.pH], label = plot_label,
		     xticks = t, title = "pH-t",
		     xlabel = "Time (h)", ylabel = "pH", markersize = 6, ylims = (3.5, 4.5))
savefig(pH_scatter, get_plot_name("pH", date, plot_type))

scatter_final = plot(suc_scatter, gluc_scatter, fruc_scatter,
			 lact_scatter, ac_scatter, prop_scatter,
			 eth_scatter, pH_scatter,
			 layout = 9, size = (1350, 900))
savefig(scatter_final, get_plot_name("final", date, plot_type))

plot_type = "scatter"

conc_scatter_0 = scatter(t, [df0_conc.Sucrose df0_conc.Glucose df0_conc.Fructose df0_conc.Lactate df0_conc.Acetate df0_conc.Propionate df0_conc.Ethanol],
			 label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 0 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			 markersize = 6)
savefig(conc_scatter_0, get_plot_name("conc_0", date, plot_type))

conc_scatter_1 = scatter(t, [df1_conc.Sucrose df1_conc.Glucose df1_conc.Fructose df1_conc.Lactate df1_conc.Acetate df1_conc.Propionate df1_conc.Ethanol],
			 label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 1 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			 markersize = 6)
savefig(conc_scatter_1, get_plot_name("conc_1", date, plot_type))

conc_scatter_2 = scatter(t, [df2_conc.Sucrose df2_conc.Glucose df2_conc.Fructose df2_conc.Lactate df2_conc.Acetate df2_conc.Propionate df2_conc.Ethanol],
			 label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 2 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			 markersize = 6)
savefig(conc_scatter_2, get_plot_name("conc_2", date, plot_type))

conc_scatter_4 = scatter(t, [df4_conc.Sucrose df4_conc.Glucose df4_conc.Fructose df4_conc.Lactate df4_conc.Acetate df4_conc.Propionate df4_conc.Ethanol],
			 label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 4 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			 markersize = 6)
savefig(conc_scatter_4, get_plot_name("conc_4", date, plot_type))

conc_scatter_8 = scatter(t, [df8_conc.Sucrose df8_conc.Glucose df8_conc.Fructose df8_conc.Lactate df8_conc.Acetate df8_conc.Propionate df8_conc.Ethanol],
			 label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 8 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			 markersize = 6)
savefig(conc_scatter_8, get_plot_name("conc_8", date, plot_type))

conc_scatter = scatter(conc_scatter_0, conc_scatter_1, conc_scatter_2, conc_scatter_4, conc_scatter_8, layout = 5, size = (1500, 900))
savefig(conc_scatter, get_plot_name("conc", date, plot_type))

plot_type = "bar"
plot_label = ["0 ml" "1 ml" "2 ml" "4 ml" "8 ml"]

suc_groupedbar = groupedbar(t, [df0_conc.Sucrose df1_conc.Sucrose df2_conc.Sucrose df4_conc.Sucrose df8_conc.Sucrose], label = plot_label,
		    xticks = t, title = "Sucrose Concentration",
		    xlabel = "Time (h)", ylabel = "Sucrose (g/l)", markersize = 6)
savefig(suc_groupedbar, get_plot_name("sucrose", date, plot_type))

gluc_groupedbar = groupedbar(t, [df0_conc.Glucose df1_conc.Glucose df2_conc.Glucose df4_conc.Glucose df8_conc.Glucose], label = plot_label,
		       xticks = t, title = "Glucose Concentration",
		       xlabel = "Time (h)", ylabel = "Glucose (g/l)", markersize = 6)
savefig(gluc_groupedbar, get_plot_name("glucose", date, plot_type))

fruc_groupedbar = groupedbar(t, [df0_conc.Fructose df1_conc.Fructose df2_conc.Fructose df4_conc.Fructose df8_conc.Fructose], label = plot_label,
		       xticks = t, title = "Fructose Concentration",
		       xlabel = "Time (h)", ylabel = "Fructose (g/l)", markersize = 6)
savefig(fruc_groupedbar, get_plot_name("fructose", date, plot_type))

lact_groupedbar = groupedbar(t, [df0_conc.Lactate df1_conc.Lactate df2_conc.Lactate df4_conc.Lactate df8_conc.Lactate], label = plot_label,
		       xticks = t, title = "Lactate Concentration",
		       xlabel = "Time (h)", ylabel = "Lactate (g/l)", markersize = 6)
savefig(lact_groupedbar, get_plot_name("lactate", date, plot_type))

ac_groupedbar = groupedbar(t, [df0_conc.Acetate df1_conc.Acetate df2_conc.Acetate df4_conc.Acetate df8_conc.Acetate], label = plot_label,
		     xticks = t, title = "Acetate Concentration",
		     xlabel = "Time (h)", ylabel = "Acetate (g/l)", markersize = 6)
savefig(ac_groupedbar, get_plot_name("acetate", date, plot_type))

prop_groupedbar = groupedbar(t, [df0_conc.Propionate df1_conc.Propionate df2_conc.Propionate df4_conc.Propionate df8_conc.Propionate], label = plot_label,
		       xticks = t, title = "Propionate Concentration",
		       xlabel = "Time (h)", ylabel = "Propionate (g/l)", markersize = 6)
savefig(prop_groupedbar, get_plot_name("propionate", date, plot_type))

eth_groupedbar = groupedbar(t, [df0_conc.Ethanol df1_conc.Ethanol df2_conc.Ethanol df4_conc.Ethanol df8_conc.Ethanol], label = plot_label,
		      xticks = t, title = "Ethanol Concentration",
		      xlabel = "Time (h)", ylabel = "Ethanol (g/l)", markersize = 6)
savefig(eth_groupedbar, get_plot_name("ethanol", date, plot_type))

pH_groupedbar = groupedbar(t, [df0_conc.pH df1_conc.pH df2_conc.pH df4_conc.pH df8_conc.pH], label = plot_label,
		     xticks = t, title = "pH-t",
		     xlabel = "Time (h)", ylabel = "pH", markersize = 6, ylims = (3.5, 4.5))
savefig(pH_groupedbar, get_plot_name("pH", date, plot_type))

groupedbar_final = plot(suc_groupedbar, gluc_groupedbar, fruc_groupedbar,
			 lact_groupedbar, ac_groupedbar, prop_groupedbar,
			 eth_groupedbar, pH_groupedbar,
			 layout = 9, size = (1350, 900))
savefig(groupedbar_final, get_plot_name("final", date, plot_type))

plot_type = "bar"

conc_groupedbar_0 = groupedbar(t, [df0_conc.Sucrose df0_conc.Glucose df0_conc.Fructose df0_conc.Lactate df0_conc.Acetate df0_conc.Propionate df0_conc.Ethanol],
			       label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 0 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			 markersize = 6)
savefig(conc_groupedbar_0, get_plot_name("conc_0", date, plot_type))

conc_groupedbar_1 = groupedbar(t, [df1_conc.Sucrose df1_conc.Glucose df1_conc.Fructose df1_conc.Lactate df1_conc.Acetate df1_conc.Propionate df1_conc.Ethanol],
			       label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 1 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			       markersize = 6)
savefig(conc_groupedbar_1, get_plot_name("conc_1", date, plot_type))

conc_groupedbar_2 = groupedbar(t, [df2_conc.Sucrose df2_conc.Glucose df2_conc.Fructose df2_conc.Lactate df2_conc.Acetate df2_conc.Propionate df2_conc.Ethanol],
			       label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 2 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			       markersize = 6)
savefig(conc_groupedbar_2, get_plot_name("conc_2", date, plot_type))

conc_groupedbar_4 = groupedbar(t, [df4_conc.Sucrose df4_conc.Glucose df4_conc.Fructose df4_conc.Lactate df4_conc.Acetate df4_conc.Propionate df4_conc.Ethanol],
			       label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 4 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			       markersize = 6)
savefig(conc_groupedbar_4, get_plot_name("conc_4", date, plot_type))

conc_groupedbar_8 = groupedbar(t, [df8_conc.Sucrose df8_conc.Glucose df8_conc.Fructose df8_conc.Lactate df8_conc.Acetate df8_conc.Propionate df8_conc.Ethanol],
			       label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 8 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
			       markersize = 6)
savefig(conc_groupedbar_8, get_plot_name("conc_8", date, plot_type))

conc_groupedbar = plot(conc_groupedbar_0, conc_groupedbar_1, conc_groupedbar_2, conc_groupedbar_4, conc_groupedbar_8, layout = 5, size = (1500, 900))
savefig(conc_groupedbar, get_plot_name("conc", date, plot_type))


df0_total = map(sum, eachrow(df0_conc[:, 2:8]))
df1_total = map(sum, eachrow(df1_conc[:, 2:8]))
df2_total = map(sum, eachrow(df2_conc[:, 2:8]))
df4_total = map(sum, eachrow(df4_conc[:, 2:8]))
df8_total = map(sum, eachrow(df8_conc[:, 2:8]))

df0_sugars = map(sum, eachrow(df0_conc[:, 2:4]))
df1_sugars = map(sum, eachrow(df1_conc[:, 2:4]))
df2_sugars = map(sum, eachrow(df2_conc[:, 2:4]))
df4_sugars = map(sum, eachrow(df4_conc[:, 2:4]))
df8_sugars = map(sum, eachrow(df8_conc[:, 2:4]))

df0_prod = map(sum, eachrow(df0_conc[:, 5:8]))
df1_prod = map(sum, eachrow(df1_conc[:, 5:8]))
df2_prod = map(sum, eachrow(df2_conc[:, 5:8]))
df4_prod = map(sum, eachrow(df4_conc[:, 5:8]))
df8_prod = map(sum, eachrow(df8_conc[:, 5:8]))


plot_type = "scatter"
plot_label = ["0 ml" "1 ml" "2 ml" "4 ml" "8 ml"]
colors = ["#009AFA" "#E36F47" "#3EA44E" "#C371D2" "#AC8E18"]

total_conc = plot(t, [df0_total df1_total df2_total df4_total df8_total], title = "Total Concentration",
		  xlabel = "Time (h)", ylabel = "Concentration (g/l)", label = plot_label,
		  linecolor = colors)
scatter!(t, [df0_total df1_total df2_total df4_total df8_total], markersize = 6, label = plot_label,
	 markercolor = colors)
savefig(total_conc, get_plot_name("total_conc", date, plot_type))

sugars_conc = plot(t, [df0_sugars df1_sugars df2_sugars df4_sugars df8_sugars], title = "Sugars Concentration",
		  xlabel = "Time (h)", ylabel = "Concentration (g/l)", label = plot_label,
		  linecolor = colors)
scatter!(t, [df0_sugars df1_sugars df2_sugars df4_sugars df8_sugars], markersize = 6, label = plot_label,
	 markercolor = colors)
savefig(sugars_conc, get_plot_name("sugars_conc", date, plot_type))

prod_conc = plot(t, [df0_prod df1_prod df2_prod df4_prod df8_prod], title = "Product Concentration",
		  xlabel = "Time (h)", ylabel = "Concentration (g/l)", label = plot_label,
		  linecolor = colors, legend = :topleft)
scatter!(t, [df0_prod df1_prod df2_prod df4_prod df8_prod], markersize = 6, label = plot_label,
	 markercolor = colors)
savefig(prod_conc, get_plot_name("product_conc", date, plot_type))

final_plot = plot(sugars_conc, prod_conc, total_conc, size = (1200, 800))
savefig(final_plot, get_plot_name("total_plots", date, plot_type))
