
t = [0, 24, 48, 72]
plot_label = ["0 mL" "1 mL" "2 mL" "4 mL" "8 mL"]

# Data reading and processing
df0_area = CSV.read("hplc_area_28_11_0.csv", DataFrame)
create_conc_table(df0_area, "hplc_conc_28_11_0.csv")
df0_conc = CSV.read("hplc_conc_28_11_0.csv", DataFrame)

df1_area = CSV.read("hplc_area_28_11_1.csv", DataFrame)
create_conc_table(df1_area, "hplc_conc_28_11_1.csv")
df1_conc = CSV.read("hplc_conc_28_11_1.csv", DataFrame)

df2_area = CSV.read("hplc_area_28_11_2.csv", DataFrame)
create_conc_table(df2_area, "hplc_conc_28_11_2.csv")
df2_conc = CSV.read("hplc_conc_28_11_2.csv", DataFrame)

df4_area = CSV.read("hplc_area_28_11_4.csv", DataFrame)
create_conc_table(df4_area, "hplc_conc_28_11_4.csv")
df4_conc = CSV.read("hplc_conc_28_11_4.csv", DataFrame)

df8_area = CSV.read("hplc_area_28_11_8.csv", DataFrame)
create_conc_table(df8_area, "hplc_conc_28_11_8.csv")
df8_conc = CSV.read("hplc_conc_28_11_8.csv", DataFrame)

df2310_1_conc = CSV.read("hplc_conc_23_10_1_comp.csv", DataFrame)
df2310_2_conc = CSV.read("hplc_conc_23_10_2_comp.csv", DataFrame)

df1011_0_conc = CSV.read("hplc_conc_10_11_0.csv", DataFrame)
df1011_1_conc = CSV.read("hplc_conc_10_11_1.csv", DataFrame)
df1011_2_conc = CSV.read("hplc_conc_10_11_2.csv", DataFrame)
df1011_4_conc = CSV.read("hplc_conc_10_11_4.csv", DataFrame)
df1011_8_conc = CSV.read("hplc_conc_10_11_8.csv", DataFrame)

# Bar Plots
#
#
suc_groupedbar = groupedbar(t, [df0_conc.Sucrose df1_conc.Sucrose df2_conc.Sucrose df4_conc.Sucrose df8_conc.Sucrose], label = plot_label,
                            xticks = t, title = "Sucrose Concentration",
                            xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar, "sucrose_bar_28_11.png")

gluc_groupedbar = groupedbar(t, [df0_conc.Glucose df1_conc.Glucose df2_conc.Glucose df4_conc.Glucose df8_conc.Glucose], label = plot_label,
                             xticks = t, title = "Glucose Concentration",
                             xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar, "glucose_bar_28_11.png")

fruc_groupedbar = groupedbar(t, [df0_conc.Fructose df1_conc.Fructose df2_conc.Fructose df4_conc.Fructose df8_conc.Fructose], label = plot_label,
                             xticks = t, title = "Fructose Concentration",
                             xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar, "fructose_bar_28_11.png")

lact_groupedbar = groupedbar(t, [df0_conc.Lactate df1_conc.Lactate df2_conc.Lactate df4_conc.Lactate df8_conc.Lactate], label = plot_label,
                             xticks = t, title = "Lactate Concentration",
                             xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar, "lactate_bar_28_11.png")

ac_groupedbar = groupedbar(t, [df0_conc.Acetate df1_conc.Acetate df2_conc.Acetate df4_conc.Acetate df8_conc.Acetate], label = plot_label,
                           xticks = t, title = "Acetate Concentration",
                           xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(ac_groupedbar, "acetate_bar_28_11.png")

prop_groupedbar = groupedbar(t, [df0_conc.Propionate df1_conc.Propionate df2_conc.Propionate df4_conc.Propionate df8_conc.Propionate], label = plot_label,
                             xticks = t, title = "Propionate Concentration",
                             xlabel = "Time (h)", ylabel = "Propionate (g/l)", legend = :bottomleft)
savefig(prop_groupedbar, "propionate_bar_28_11.png")

eth_groupedbar = groupedbar(t, [df0_conc.Ethanol df1_conc.Ethanol df2_conc.Ethanol df4_conc.Ethanol df8_conc.Ethanol], label = plot_label,
                            xticks = t, title = "Ethanol Concentration",
                            xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar, "ethanol_bar_28_11.png")

pH_groupedbar = groupedbar(t, [df0_conc.pH df1_conc.pH df2_conc.pH df4_conc.pH df8_conc.pH], label = plot_label,
                           xticks = t, title = "pH-t",
                           xlabel = "Time (h)", ylabel = "pH", ylims = (3.9, 4.6), legend = :bottomleft)
savefig(pH_groupedbar, "pH_bar_28_11.png")

ec_groupedbar = groupedbar(t, [df0_conc.EC df1_conc.EC df2_conc.EC df4_conc.EC df8_conc.EC], label = plot_label,
                           xticks = t, title = "Electrical Conductivity",
                           xlabel = "Time (h)", ylabel = "EC (mS/cm)", legend = :bottomleft)
savefig(ec_groupedbar, "ec_bar_28_11.png")

grouped_bar_final = plot(suc_groupedbar, gluc_groupedbar, fruc_groupedbar,
                         lact_groupedbar, ac_groupedbar, prop_groupedbar,
                         eth_groupedbar, pH_groupedbar, ec_groupedbar,
                         layout = 9, size = (1350, 900))
savefig(grouped_bar_final, "grouped_bar_final_28_11.png")

# Bar Plots by concentration
#
#
conc_groupedbar_0 = groupedbar(t, [df0_conc.Sucrose df0_conc.Glucose df0_conc.Fructose df0_conc.Lactate df0_conc.Acetate df0_conc.Propionate df0_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 0 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6)
savefig(conc_groupedbar_0, "conc_groupedbar_0_28_11.png")

conc_groupedbar_1 = groupedbar(t, [df1_conc.Sucrose df1_conc.Glucose df1_conc.Fructose df1_conc.Lactate df1_conc.Acetate df1_conc.Propionate df1_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 1 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6)
savefig(conc_groupedbar_1, "conc_groupedbar_1_28_11.png")

conc_groupedbar_2 = groupedbar(t, [df2_conc.Sucrose df2_conc.Glucose df2_conc.Fructose df2_conc.Lactate df2_conc.Acetate df2_conc.Propionate df2_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 2 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6, legend = :top)
savefig(conc_groupedbar_2, "conc_groupedbar_2_28_11.png")

conc_groupedbar_4 = groupedbar(t, [df4_conc.Sucrose df4_conc.Glucose df4_conc.Fructose df4_conc.Lactate df4_conc.Acetate df4_conc.Propionate df4_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 4 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6)
savefig(conc_groupedbar_4, "conc_groupedbar_4_28_11.png")

conc_groupedbar_8 = groupedbar(t, [df8_conc.Sucrose df8_conc.Glucose df8_conc.Fructose df8_conc.Lactate df8_conc.Acetate df8_conc.Propionate df8_conc.Ethanol],
                         label = ["Sucrose" "Glucose" "Fructose" "Lactate" "Acetate" "Propionate" "Ethanol"], xticks = t, title = "Concentrations for sample with 8 mL mix", xlabel = "Time (h)", ylabel = "Concentration (g/l)",
                         markersize = 6, legend = :top)
savefig(conc_groupedbar_8, "conc_groupedbar_8_28_11.png")

conc_groupedbar = plot(conc_groupedbar_0, conc_groupedbar_1, conc_groupedbar_2, conc_groupedbar_4, conc_groupedbar_8, layout = 5, size = (1500, 900))
savefig(conc_groupedbar, "conc_groupedbar_28_11.png")

# Comparison plots with previous experiment
suc_groupedbar = groupedbar(t, [df1011_2_conc.Sucrose df2_conc.Sucrose df2310_1_conc.Sucrose df2310_2_conc.Sucrose], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
                            xticks = t, title = "Sucrose Concentration",
                            xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar, "sucrose_bar_comp_2.png")

gluc_groupedbar = groupedbar(t, [df1011_2_conc.Glucose df2_conc.Glucose df2310_1_conc.Glucose df2310_2_conc.Glucose], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
                             xticks = t, title = "Glucose Concentration",
                             xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar, "glucose_bar_comp_2.png")

fruc_groupedbar = groupedbar(t, [df1011_2_conc.Fructose df2_conc.Fructose df2310_1_conc.Fructose df2310_2_conc.Fructose], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
                             xticks = t, title = "Fructose Concentration",
                             xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar, "fructose_bar_comp_2.png")

lact_groupedbar = groupedbar(t, [df1011_2_conc.Lactate df2_conc.Lactate df2310_1_conc.Lactate df2310_2_conc.Lactate], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
                             xticks = t, title = "Lactate Concentration",
                             xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar, "lactate_bar_comp_2.png")

ac_groupedbar = groupedbar(t, [df1011_2_conc.Acetate df2_conc.Acetate df2310_1_conc.Acetate df2310_2_conc.Acetate], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
                           xticks = t, title = "Acetate Concentration",
                           xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(ac_groupedbar, "acetate_bar_comp_2.png")

prop_groupedbar = groupedbar(t, [df1011_2_conc.Propionate df2_conc.Propionate df2310_1_conc.Propionate df2310_2_conc.Propionate], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
                             xticks = t, title = "Propionate Concentration",
                             xlabel = "Time (h)", ylabel = "Propionate (g/l)", legend = :bottomleft)
savefig(prop_groupedbar, "propionate_bar_comp_2.png")

eth_groupedbar = groupedbar(t, [df1011_2_conc.Ethanol df2_conc.Ethanol df2310_1_conc.Ethanol df2310_2_conc.Ethanol], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
                            xticks = t, title = "Ethanol Concentration",
                            xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar, "ethanol_bar_comp_2.png")

grouped_bar_comp = plot(suc_groupedbar, gluc_groupedbar, fruc_groupedbar,
                         lact_groupedbar, ac_groupedbar, prop_groupedbar,
                         eth_groupedbar, layout = 7, size = (1400, 900))
savefig(grouped_bar_comp, "grouped_bar_comp_2.png")

# Comparison without the kinetics
suc_groupedbar_0 = groupedbar(t, [df0_conc.Sucrose df1011_0_conc.Sucrose], label = ["40 C" "35 C"],
                            xticks = t, title = "Sucrose Concentration",
                            xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar_0, "sucrose_bar_comp_0.png")

gluc_groupedbar_0 = groupedbar(t, [df0_conc.Glucose df1011_0_conc.Glucose], label = ["40 C" "35 C"],
                            xticks = t, title = "Glucose Concentration",
                            xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar_0, "glucose_bar_comp_0.png")

fruc_groupedbar_0 = groupedbar(t, [df0_conc.Fructose df1011_0_conc.Fructose], label = ["40 C" "35 C"],
                            xticks = t, title = "Fructose Concentration",
                            xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar_0, "fructose_bar_comp_0.png")

lact_groupedbar_0 = groupedbar(t, [df0_conc.Lactate df1011_0_conc.Lactate], label = ["40 C" "35 C"],
                            xticks = t, title = "Lactate Concentration",
                            xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar_0, "lactate_bar_comp_0.png")

acet_groupedbar_0 = groupedbar(t, [df0_conc.Acetate df1011_0_conc.Acetate], label = ["40 C" "35 C"],
                            xticks = t, title = "Acetate Concentration",
                            xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(acet_groupedbar_0, "acetate_bar_comp_0.png")

prop_groupedbar_0 = groupedbar(t, [df0_conc.Propionate df1011_0_conc.Propionate], label = ["40 C" "35 C"],
                            xticks = t, title = "Propionate Concentration",
                            xlabel = "Time (h)", ylabel = "Propionate (g/l)")
savefig(prop_groupedbar_0, "propionate_bar_comp_0.png")

eth_groupedbar_0 = groupedbar(t, [df0_conc.Ethanol df1011_0_conc.Ethanol], label = ["40 C" "35 C"],
                            xticks = t, title = "Ethanol Concentration",
                            xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar_0, "ethanol_bar_comp_0.png")

grouped_bar_comp_0 = plot(suc_groupedbar_0, gluc_groupedbar_0, fruc_groupedbar_0,
                         lact_groupedbar_0, acet_groupedbar_0, prop_groupedbar_0,
                         eth_groupedbar_0, layout = 9, size = (1400, 900))
savefig(grouped_bar_comp_0, "grouped_bar_comp_0.png")

suc_groupedbar_1 = groupedbar(t, [df1_conc.Sucrose df1011_1_conc.Sucrose], label = ["40 C" "35 C"],
                            xticks = t, title = "Sucrose Concentration",
                            xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar_1, "sucrose_bar_comp_1.png")

gluc_groupedbar_1 = groupedbar(t, [df1_conc.Glucose df1011_1_conc.Glucose], label = ["40 C" "35 C"],
                            xticks = t, title = "Glucose Concentration",
                            xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar_1, "glucose_bar_comp_1.png")

fruc_groupedbar_1 = groupedbar(t, [df1_conc.Fructose df1011_1_conc.Fructose], label = ["40 C" "35 C"],
                            xticks = t, title = "Fructose Concentration",
                            xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar_1, "fructose_bar_comp_1.png")

lact_groupedbar_1 = groupedbar(t, [df1_conc.Lactate df1011_1_conc.Lactate], label = ["40 C" "35 C"],
                            xticks = t, title = "Lactate Concentration",
                            xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar_1, "lactate_bar_comp_1.png")

acet_groupedbar_1 = groupedbar(t, [df1_conc.Acetate df1011_1_conc.Acetate], label = ["40 C" "35 C"],
                            xticks = t, title = "Acetate Concentration",
                            xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(acet_groupedbar_1, "acetate_bar_comp_1.png")

prop_groupedbar_1 = groupedbar(t, [df1_conc.Propionate df1011_1_conc.Propionate], label = ["40 C" "35 C"],
                            xticks = t, title = "Propionate Concentration",
                            xlabel = "Time (h)", ylabel = "Propionate (g/l)")
savefig(prop_groupedbar_1, "propionate_bar_comp_1.png")

eth_groupedbar_1 = groupedbar(t, [df1_conc.Ethanol df1011_1_conc.Ethanol], label = ["40 C" "35 C"],
                            xticks = t, title = "Ethanol Concentration",
                            xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar_1, "ethanol_bar_comp_1.png")

grouped_bar_comp_1 = plot(suc_groupedbar_1, gluc_groupedbar_1, fruc_groupedbar_1,
                         lact_groupedbar_1, acet_groupedbar_1, prop_groupedbar_1,
                         eth_groupedbar_1, layout = 7, size = (1400, 900))
savefig(grouped_bar_comp_1, "grouped_bar_comp_1.png")

suc_groupedbar_4 = groupedbar(t, [df4_conc.Sucrose df1011_4_conc.Sucrose], label = ["40 C" "35 C"],
                            xticks = t, title = "Sucrose Concentration",
                            xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar_4, "sucrose_bar_comp_4.png")

gluc_groupedbar_4 = groupedbar(t, [df4_conc.Glucose df1011_4_conc.Glucose], label = ["40 C" "35 C"],
                            xticks = t, title = "Glucose Concentration",
                            xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar_4, "glucose_bar_comp_4.png")

fruc_groupedbar_4 = groupedbar(t, [df4_conc.Fructose df1011_4_conc.Fructose], label = ["40 C" "35 C"],
                            xticks = t, title = "Fructose Concentration",
                            xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar_4, "fructose_bar_comp_4.png")

lact_groupedbar_4 = groupedbar(t, [df4_conc.Lactate df1011_4_conc.Lactate], label = ["40 C" "35 C"],
                            xticks = t, title = "Lactate Concentration",
                            xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar_4, "lactate_bar_comp_4.png")

acet_groupedbar_4 = groupedbar(t, [df4_conc.Acetate df1011_4_conc.Acetate], label = ["40 C" "35 C"],
                            xticks = t, title = "Acetate Concentration",
                            xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(acet_groupedbar_4, "acetate_bar_comp_4.png")

prop_groupedbar_4 = groupedbar(t, [df4_conc.Propionate df1011_4_conc.Propionate], label = ["40 C" "35 C"],
                            xticks = t, title = "Propionate Concentration",
                            xlabel = "Time (h)", ylabel = "Propionate (g/l)")
savefig(prop_groupedbar_4, "propionate_bar_comp_4.png")

eth_groupedbar_4 = groupedbar(t, [df4_conc.Ethanol df1011_4_conc.Ethanol], label = ["40 C" "35 C"],
                            xticks = t, title = "Ethanol Concentration",
                            xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar_4, "ethanol_bar_comp_4.png")

grouped_bar_comp_4 = plot(suc_groupedbar_4, gluc_groupedbar_4, fruc_groupedbar_4,
                         lact_groupedbar_4, acet_groupedbar_4, prop_groupedbar_4,
                         eth_groupedbar_4, layout = 7, size = (1400, 900))
savefig(grouped_bar_comp_4, "grouped_bar_comp_4.png")

suc_groupedbar_8 = groupedbar(t, [df8_conc.Sucrose df1011_8_conc.Sucrose], label = ["40 C" "35 C"],
                            xticks = t, title = "Sucrose Concentration",
                            xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar_8, "sucrose_bar_comp_8.png")

gluc_groupedbar_8 = groupedbar(t, [df8_conc.Glucose df1011_8_conc.Glucose], label = ["40 C" "35 C"],
                            xticks = t, title = "Glucose Concentration",
                            xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar_8, "glucose_bar_comp_8.png")

fruc_groupedbar_8 = groupedbar(t, [df8_conc.Fructose df1011_8_conc.Fructose], label = ["40 C" "35 C"],
                            xticks = t, title = "Fructose Concentration",
                            xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar_8, "fructose_bar_comp_8.png")

lact_groupedbar_8 = groupedbar(t, [df8_conc.Lactate df1011_8_conc.Lactate], label = ["40 C" "35 C"],
                            xticks = t, title = "Lactate Concentration",
                            xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar_8, "lactate_bar_comp_8.png")

acet_groupedbar_8 = groupedbar(t, [df8_conc.Acetate df1011_8_conc.Acetate], label = ["40 C" "35 C"],
                            xticks = t, title = "Acetate Concentration",
                            xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(acet_groupedbar_8, "acetate_bar_comp_8.png")

prop_groupedbar_8 = groupedbar(t, [df8_conc.Propionate df1011_8_conc.Propionate], label =["40 C" "35 C"],
                            xticks = t, title = "Propionate Concentration",
                            xlabel = "Time (h)", ylabel = "Propionate (g/l)")
savefig(prop_groupedbar_8, "propionate_bar_comp_8.png")

eth_groupedbar_8 = groupedbar(t, [df8_conc.Ethanol df1011_8_conc.Ethanol], label = ["40 C" "35 C"],
                            xticks = t, title = "Ethanol Concentration",
                            xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar_8, "ethanol_bar_comp_8.png")

grouped_bar_comp_8 = plot(suc_groupedbar_8, gluc_groupedbar_8, fruc_groupedbar_8,
                         lact_groupedbar_8, acet_groupedbar_8, prop_groupedbar_8,
                         eth_groupedbar_8, layout = 7, size = (1400, 900))
savefig(grouped_bar_comp_8, "grouped_bar_comp_8.png")

# Reduction rates
#
#

df0_sucrose_red = (df0_conc.Sucrose[1] .- df0_conc.Sucrose)/df0_conc.Sucrose[1]*100
df1_sucrose_red = (df1_conc.Sucrose[1] .- df1_conc.Sucrose)/df1_conc.Sucrose[1]*100
df2_sucrose_red = (df2_conc.Sucrose[1] .- df2_conc.Sucrose)/df2_conc.Sucrose[1]*100
df4_sucrose_red = (df4_conc.Sucrose[1] .- df4_conc.Sucrose)/df4_conc.Sucrose[1]*100
df8_sucrose_red = (df8_conc.Sucrose[1] .- df8_conc.Sucrose)/df8_conc.Sucrose[1]*100

df0_glucose_red = (df0_conc.Glucose[1] .- df0_conc.Glucose)/df0_conc.Glucose[1]*100
df1_glucose_red = (df1_conc.Glucose[1] .- df1_conc.Glucose)/df1_conc.Glucose[1]*100
df2_glucose_red = (df2_conc.Glucose[1] .- df2_conc.Glucose)/df2_conc.Glucose[1]*100
df4_glucose_red = (df4_conc.Glucose[1] .- df4_conc.Glucose)/df4_conc.Glucose[1]*100
df8_glucose_red = (df8_conc.Glucose[1] .- df8_conc.Glucose)/df8_conc.Glucose[1]*100

df0_fructose_red = (df0_conc.Fructose[1] .- df0_conc.Fructose)/df0_conc.Fructose[1]*100
df1_fructose_red = (df1_conc.Fructose[1] .- df1_conc.Fructose)/df1_conc.Fructose[1]*100
df2_fructose_red = (df2_conc.Fructose[1] .- df2_conc.Fructose)/df2_conc.Fructose[1]*100
df4_fructose_red = (df4_conc.Fructose[1] .- df4_conc.Fructose)/df4_conc.Fructose[1]*100
df8_fructose_red = (df8_conc.Fructose[1] .- df8_conc.Fructose)/df8_conc.Fructose[1]*100

# Bars
sucrose_red_bar = groupedbar(t, [df0_sucrose_red df1_sucrose_red df2_sucrose_red df4_sucrose_red df8_sucrose_red], label = plot_label,
                            xticks = t, title = "Sucrose Reduction Rate",
                            xlabel = "Time (h)", ylabel = "Sucrose Reduction (%)")
savefig(sucrose_red_bar, "sucrose_red_bar_28_11.png")

glucose_red_bar = groupedbar(t, [df0_glucose_red df1_glucose_red df2_glucose_red df4_glucose_red df8_glucose_red], label = plot_label,
                            xticks = t, title = "Glucose Reduction Rate",
                            xlabel = "Time (h)", ylabel = "Glucose Reduction (%)")
savefig(glucose_red_bar, "glucose_red_bar_28_11.png")

fructose_red_bar = groupedbar(t, [df0_fructose_red df1_fructose_red df2_fructose_red df4_fructose_red df8_fructose_red], label = plot_label,
                            xticks = t, title = "Fructose Reduction Rate",
                          xlabel = "Time (h)", ylabel = "Fructose Reduction (%)",
                          ylims = (0, 100))
savefig(fructose_red_bar, "fructose_red_bar_28_11.png")

sugar_red_bar = plot(sucrose_red_bar, fructose_red_bar, glucose_red_bar, layout = (3,1), size = (900, 600))
savefig(sugar_red_bar, "sugar_red_bar_28_11.png")
