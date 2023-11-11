
t = [0, 24, 48]
plot_label = ["0 mL" "1 mL" "2 mL" "4 mL" "8 mL"]

# Data reading and processing
df0_area = CSV.read("hplc_area_10_11_0.csv", DataFrame)
create_conc_table(df0_area, "hplc_conc_10_11_0.csv")
df0_conc = CSV.read("hplc_conc_10_11_0.csv", DataFrame)

df1_area = CSV.read("hplc_area_10_11_1.csv", DataFrame)
create_conc_table(df1_area, "hplc_conc_10_11_1.csv")
df1_conc = CSV.read("hplc_conc_10_11_1.csv", DataFrame)

df2_area = CSV.read("hplc_area_10_11_2.csv", DataFrame)
create_conc_table(df2_area, "hplc_conc_10_11_2.csv")
df2_conc = CSV.read("hplc_conc_10_11_2.csv", DataFrame)

df4_area = CSV.read("hplc_area_10_11_4.csv", DataFrame)
create_conc_table(df4_area, "hplc_conc_10_11_4.csv")
df4_conc = CSV.read("hplc_conc_10_11_4.csv", DataFrame)

df8_area = CSV.read("hplc_area_10_11_8.csv", DataFrame)
create_conc_table(df8_area, "hplc_conc_10_11_8.csv")
df8_conc = CSV.read("hplc_conc_10_11_8.csv", DataFrame)

df2310_conc = CSV.read("hplc_conc_23_10_comp.csv", DataFrame)

# Scatter Plots by Substance
#
#
suc_scatter = scatter(t, [df0_conc.Sucrose df1_conc.Sucrose df2_conc.Sucrose df4_conc.Sucrose df8_conc.Sucrose], label = plot_label,
                      xticks = t, title = "Sucrose Concentration",
                      xlabel = "Time (h)", ylabel = "Sucrose (g/l)", markersize = 6)
savefig(suc_scatter, "sucrose_scatter_10_11.png")

gluc_scatter = scatter(t, [df0_conc.Glucose df1_conc.Glucose df2_conc.Glucose df4_conc.Glucose df8_conc.Glucose], label = plot_label,
                       xticks = t, title = "Glucose Concentration",
                       xlabel = "Time (h)", ylabel = "Glucose (g/l)", markersize = 6)
savefig(gluc_scatter, "glucose_scatter_10_11.png")

fruc_scatter = scatter(t, [df0_conc.Fructose df1_conc.Fructose df2_conc.Fructose df4_conc.Fructose df8_conc.Fructose], label = plot_label,
                       xticks = t, title = "Fructose Concentration",
                       xlabel = "Time (h)", ylabel = "Fructose (g/l)", markersize = 6)
savefig(fruc_scatter, "fructose_scatter_10_11.png")

lact_scatter = scatter(t, [df0_conc.Lactate df1_conc.Lactate df2_conc.Lactate df4_conc.Lactate df8_conc.Lactate], label = plot_label,
                       xticks = t, title = "Lactate Concentration",
                       xlabel = "Time (h)", ylabel = "Lactate (g/l)", markersize = 6)
savefig(lact_scatter, "lactate_scatter_10_11.png")

ac_scatter = scatter(t, [df0_conc.Acetate df1_conc.Acetate df2_conc.Acetate df4_conc.Acetate df8_conc.Acetate], label = plot_label,
                     xticks = t, title = "Acetate Concentration",
                     xlabel = "Time (h)", ylabel = "Acetate (g/l)", markersize = 6)
savefig(ac_scatter, "acetate_scatter_10_11.png")

prop_scatter = scatter(t, [df0_conc.Propionate df1_conc.Propionate df2_conc.Propionate df4_conc.Propionate df8_conc.Propionate], label = plot_label,
                       xticks = t, title = "Propionate Concentration",
                       xlabel = "Time (h)", ylabel = "Propionate (g/l)", markersize = 6)
savefig(prop_scatter, "propionate_scatter_10_11.png")

eth_scatter = scatter(t, [df0_conc.Ethanol df1_conc.Ethanol df2_conc.Ethanol df4_conc.Ethanol df8_conc.Ethanol], label = plot_label,
                      xticks = t, title = "Ethanol Concentration",
                      xlabel = "Time (h)", ylabel = "Ethanol (g/l)", markersize = 6)
savefig(eth_scatter, "ethanol_scatter_10_11.png")

pH_scatter = scatter(t, [df0_conc.pH df1_conc.pH df2_conc.pH df4_conc.pH df8_conc.pH], label = plot_label,
                     xticks = t, title = "pH-t",
                     xlabel = "Time (h)", ylabel = "pH", markersize = 6)
savefig(pH_scatter, "pH_scatter_10_11.png")

ec_scatter = scatter(t, [df0_conc.EC df1_conc.EC df2_conc.EC df4_conc.EC df8_conc.EC], label = plot_label,
                     xticks = t, title = "Electrical Conductivity",
                     xlabel = "Time (h)", ylabel = "EC (mS/cm)", markersize = 6)
savefig(ec_scatter, "ec_scatter_10_11.png")

scatter_final = plot(suc_scatter, gluc_scatter, fruc_scatter,
                         lact_scatter, ac_scatter, prop_scatter,
                         eth_scatter, pH_scatter, ec_scatter,
                         layout = 9, size = (1350, 900))
savefig(scatter_final, "scatter_final_10_11.png")

# Scatter plots by sample
conc_scatter_0 = scatter(t, [df0_conc.Sucrose df0_conc.Glucose df0_conc.Fructose df0_conc.Lactate df0_conc.Acetate df0_conc.Propionate df0_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 0 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6)
savefig(conc_scatter_0, "conc_scatter_0_10_11.png")

conc_scatter_1 = scatter(t, [df1_conc.Sucrose df1_conc.Glucose df1_conc.Fructose df1_conc.Lactate df1_conc.Acetate df1_conc.Propionate df1_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 1 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6)
savefig(conc_scatter_1, "conc_scatter_1_10_11.png")

conc_scatter_2 = scatter(t, [df2_conc.Sucrose df2_conc.Glucose df2_conc.Fructose df2_conc.Lactate df2_conc.Acetate df2_conc.Propionate df2_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 2 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6)
savefig(conc_scatter_2, "conc_scatter_2_10_11.png")

conc_scatter_4 = scatter(t, [df4_conc.Sucrose df4_conc.Glucose df4_conc.Fructose df4_conc.Lactate df4_conc.Acetate df4_conc.Propionate df4_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 4 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6)
savefig(conc_scatter_4, "conc_scatter_4_10_11.png")

conc_scatter_8 = scatter(t, [df8_conc.Sucrose df8_conc.Glucose df8_conc.Fructose df8_conc.Lactate df8_conc.Acetate df8_conc.Propionate df8_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 8 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6)
savefig(conc_scatter_8, "conc_scatter_8_10_11.png")

conc_scatter = scatter(conc_scatter_0, conc_scatter_1, conc_scatter_2, conc_scatter_4, conc_scatter_8, layout = 5, size = (1500, 900))
savefig(conc_scatter, "conc_scatter_10_11.png")

# Bar Plots
#
#
suc_groupedbar = groupedbar(t, [df0_conc.Sucrose df1_conc.Sucrose df2_conc.Sucrose df4_conc.Sucrose df8_conc.Sucrose], label = plot_label,
                            xticks = t, title = "Sucrose Concentration",
                            xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar, "sucrose_bar_10_11.png")

gluc_groupedbar = groupedbar(t, [df0_conc.Glucose df1_conc.Glucose df2_conc.Glucose df4_conc.Glucose df8_conc.Glucose], label = plot_label,
                             xticks = t, title = "Glucose Concentration",
                             xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar, "glucose_bar_10_11.png")

fruc_groupedbar = groupedbar(t, [df0_conc.Fructose df1_conc.Fructose df2_conc.Fructose df4_conc.Fructose df8_conc.Fructose], label = plot_label,
                             xticks = t, title = "Fructose Concentration",
                             xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar, "fructose_bar_10_11.png")

lact_groupedbar = groupedbar(t, [df0_conc.Lactate df1_conc.Lactate df2_conc.Lactate df4_conc.Lactate df8_conc.Lactate], label = plot_label,
                             xticks = t, title = "Lactate Concentration",
                             xlabel = "Time (h)", ylabel = "Lactate (g/l)", legend = :bottomleft)
savefig(lact_groupedbar, "lactate_bar_10_11.png")

ac_groupedbar = groupedbar(t, [df0_conc.Acetate df1_conc.Acetate df2_conc.Acetate df4_conc.Acetate df8_conc.Acetate], label = plot_label,
                           xticks = t, title = "Acetate Concentration",
                           xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(ac_groupedbar, "acetate_bar_10_11.png")

prop_groupedbar = groupedbar(t, [df0_conc.Propionate df1_conc.Propionate df2_conc.Propionate df4_conc.Propionate df8_conc.Propionate], label = plot_label,
                             xticks = t, title = "Propionate Concentration",
                             xlabel = "Time (h)", ylabel = "Propionate (g/l)", legend = :bottomleft)
savefig(prop_groupedbar, "propionate_bar_10_11.png")

eth_groupedbar = groupedbar(t, [df0_conc.Ethanol df1_conc.Ethanol df2_conc.Ethanol df4_conc.Ethanol df8_conc.Ethanol], label = plot_label,
                            xticks = t, title = "Ethanol Concentration",
                            xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar, "ethanol_bar_10_11.png")

pH_groupedbar = groupedbar(t, [df0_conc.pH df1_conc.pH df2_conc.pH df4_conc.pH df8_conc.pH], label = plot_label,
                           xticks = t, title = "pH-t",
                           xlabel = "Time (h)", ylabel = "pH", ylims = (3.9, 4.6), legend = :bottomleft)
savefig(pH_groupedbar, "pH_bar_10_11.png")

ec_groupedbar = groupedbar(t, [df0_conc.EC df1_conc.EC df2_conc.EC df4_conc.EC df8_conc.EC], label = plot_label,
                           xticks = t, title = "Electrical Conductivity",
                           xlabel = "Time (h)", ylabel = "EC (mS/cm)", legend = :bottomleft)
savefig(ec_groupedbar, "ec_bar_10_11.png")

grouped_bar_final = plot(suc_groupedbar, gluc_groupedbar, fruc_groupedbar,
                         lact_groupedbar, ac_groupedbar, prop_groupedbar,
                         eth_groupedbar, pH_groupedbar, ec_groupedbar,
                         layout = 9, size = (1350, 900))
savefig(grouped_bar_final, "grouped_bar_final_10_11.png")

# Comparison plots with previous experiment
suc_groupedbar = groupedbar(t, [df2_conc.Sucrose df2310_conc.Sucrose], label = ["35 C" "45 C"],
                            xticks = t, title = "Sucrose Concentration",
                            xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar, "sucrose_bar_comp.png")

gluc_groupedbar = groupedbar(t, [df2_conc.Glucose df2310_conc.Glucose], label = ["35 C" "45 C"],
                             xticks = t, title = "Glucose Concentration",
                             xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar, "glucose_bar_comp.png")

fruc_groupedbar = groupedbar(t, [df2_conc.Fructose df2310_conc.Fructose], label = ["35 C" "45 C"],
                             xticks = t, title = "Fructose Concentration",
                             xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar, "fructose_bar_comp.png")

lact_groupedbar = groupedbar(t, [df2_conc.Lactate df2310_conc.Lactate], label = ["35 C" "45 C"],
                             xticks = t, title = "Lactate Concentration",
                             xlabel = "Time (h)", ylabel = "Lactate (g/l)", legend = :bottomleft)
savefig(lact_groupedbar, "lactate_bar_comp.png")

ac_groupedbar = groupedbar(t, [df2_conc.Acetate df2310_conc.Acetate], label = ["35 C" "45 C"],
                           xticks = t, title = "Acetate Concentration",
                           xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(ac_groupedbar, "acetate_bar_comp.png")

prop_groupedbar = groupedbar(t, [df2_conc.Propionate df2310_conc.Propionate], label = ["35 C" "45 C"],
                             xticks = t, title = "Propionate Concentration",
                             xlabel = "Time (h)", ylabel = "Propionate (g/l)", legend = :bottomleft)
savefig(prop_groupedbar, "propionate_bar_comp.png")

eth_groupedbar = groupedbar(t, [df2_conc.Ethanol df2310_conc.Ethanol], label = ["35 C" "45 C"],
                            xticks = t, title = "Ethanol Concentration",
                            xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar, "ethanol_bar_comp.png")

grouped_bar_comp = plot(suc_groupedbar, gluc_groupedbar, fruc_groupedbar,
                         lact_groupedbar, ac_groupedbar, prop_groupedbar,
                         eth_groupedbar, layout = 9, size = (1350, 900))
savefig(grouped_bar_comp, "grouped_bar_comp.png")
