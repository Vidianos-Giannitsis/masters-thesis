date = "28_11"
mix_amount = ["0", "1", "2", "4", "8"]
t = [0, 24, 48, 72]

df0_conc = process_area_data(get_area_csv(date, mix_amount[1]), get_conc_csv(date, mix_amount[1]))
df1_conc = process_area_data(get_area_csv(date, mix_amount[2]), get_conc_csv(date, mix_amount[2]))
df2_conc = process_area_data(get_area_csv(date, mix_amount[3]), get_conc_csv(date, mix_amount[3]))
df4_conc = process_area_data(get_area_csv(date, mix_amount[4]), get_conc_csv(date, mix_amount[4]))
df8_conc = process_area_data(get_area_csv(date, mix_amount[5]), get_conc_csv(date, mix_amount[5]))

df2310_1_conc = CSV.read(datadir("exp_pro/hplc_conc_23_10_1_comp.csv"), DataFrame)
df2310_2_conc = CSV.read(datadir("exp_pro/hplc_conc_23_10_2_comp.csv"), DataFrame)

df1011_0_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_0.csv"), DataFrame)
df1011_1_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_1.csv"), DataFrame)
df1011_2_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_2.csv"), DataFrame)
df1011_4_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_4.csv"), DataFrame)
df1011_8_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_8.csv"), DataFrame)


suc_groupedbar = groupedbar(t, [df1011_2_conc.Sucrose df2_conc.Sucrose df2310_1_conc.Sucrose df2310_2_conc.Sucrose], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
			    xticks = t, title = "Sucrose Concentration",
			    xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar, plotsdir("35_40_45_comp/sucrose_bar_comp_2.png"))

gluc_groupedbar = groupedbar(t, [df1011_2_conc.Glucose df2_conc.Glucose df2310_1_conc.Glucose df2310_2_conc.Glucose], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
			     xticks = t, title = "Glucose Concentration",
			     xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar, plotsdir("35_40_45_comp/glucose_bar_comp_2.png"))

fruc_groupedbar = groupedbar(t, [df1011_2_conc.Fructose df2_conc.Fructose df2310_1_conc.Fructose df2310_2_conc.Fructose], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
			     xticks = t, title = "Fructose Concentration",
			     xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar, plotsdir("35_40_45_comp/fructose_bar_comp_2.png"))

lact_groupedbar = groupedbar(t, [df1011_2_conc.Lactate df2_conc.Lactate df2310_1_conc.Lactate df2310_2_conc.Lactate], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
			     xticks = t, title = "Lactate Concentration",
			     xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar, plotsdir("35_40_45_comp/lactate_bar_comp_2.png"))

ac_groupedbar = groupedbar(t, [df1011_2_conc.Acetate df2_conc.Acetate df2310_1_conc.Acetate df2310_2_conc.Acetate], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
			   xticks = t, title = "Acetate Concentration",
			   xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(ac_groupedbar, plotsdir("35_40_45_comp/acetate_bar_comp_2.png"))

prop_groupedbar = groupedbar(t, [df1011_2_conc.Propionate df2_conc.Propionate df2310_1_conc.Propionate df2310_2_conc.Propionate], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
			     xticks = t, title = "Propionate Concentration",
			     xlabel = "Time (h)", ylabel = "Propionate (g/l)", legend = :bottomleft)
savefig(prop_groupedbar, plotsdir("35_40_45_comp/propionate_bar_comp_2.png"))

eth_groupedbar = groupedbar(t, [df1011_2_conc.Ethanol df2_conc.Ethanol df2310_1_conc.Ethanol df2310_2_conc.Ethanol], label = ["35 C" "40 C" "45 C (1)" "45 C (2)"],
			    xticks = t, title = "Ethanol Concentration",
			    xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar, plotsdir("35_40_45_comp/ethanol_bar_comp_2.png"))

grouped_bar_comp = plot(suc_groupedbar, gluc_groupedbar, fruc_groupedbar,
			 lact_groupedbar, ac_groupedbar, prop_groupedbar,
			 eth_groupedbar, layout = 7, size = (1400, 900))
savefig(grouped_bar_comp, plotsdir("35_40_45_comp/grouped_bar_comp_2.png"))


suc_groupedbar_0 = groupedbar(t, [df0_conc.Sucrose df1011_0_conc.Sucrose], label = ["40 C" "35 C"],
			    xticks = t, title = "Sucrose Concentration",
			    xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar_0, plotsdir("35_40_comp/sucrose_bar_comp_0.png"))

gluc_groupedbar_0 = groupedbar(t, [df0_conc.Glucose df1011_0_conc.Glucose], label = ["40 C" "35 C"],
			    xticks = t, title = "Glucose Concentration",
			    xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar_0, plotsdir("35_40_comp/glucose_bar_comp_0.png"))

fruc_groupedbar_0 = groupedbar(t, [df0_conc.Fructose df1011_0_conc.Fructose], label = ["40 C" "35 C"],
			    xticks = t, title = "Fructose Concentration",
			    xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar_0, plotsdir("35_40_comp/fructose_bar_comp_0.png"))

lact_groupedbar_0 = groupedbar(t, [df0_conc.Lactate df1011_0_conc.Lactate], label = ["40 C" "35 C"],
			    xticks = t, title = "Lactate Concentration",
			    xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar_0, plotsdir("35_40_comp/lactate_bar_comp_0.png"))

acet_groupedbar_0 = groupedbar(t, [df0_conc.Acetate df1011_0_conc.Acetate], label = ["40 C" "35 C"],
			    xticks = t, title = "Acetate Concentration",
			    xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(acet_groupedbar_0, plotsdir("35_40_comp/acetate_bar_comp_0.png"))

prop_groupedbar_0 = groupedbar(t, [df0_conc.Propionate df1011_0_conc.Propionate], label = ["40 C" "35 C"],
			    xticks = t, title = "Propionate Concentration",
			    xlabel = "Time (h)", ylabel = "Propionate (g/l)")
savefig(prop_groupedbar_0, plotsdir("35_40_comp/propionate_bar_comp_0.png"))

eth_groupedbar_0 = groupedbar(t, [df0_conc.Ethanol df1011_0_conc.Ethanol], label = ["40 C" "35 C"],
			    xticks = t, title = "Ethanol Concentration",
			    xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar_0, plotsdir("35_40_comp/ethanol_bar_comp_0.png"))

grouped_bar_comp_0 = plot(suc_groupedbar_0, gluc_groupedbar_0, fruc_groupedbar_0,
			 lact_groupedbar_0, acet_groupedbar_0, prop_groupedbar_0,
			 eth_groupedbar_0, layout = 9, size = (1400, 900))
savefig(grouped_bar_comp_0, plotsdir("35_40_comp/grouped_bar_comp_0.png"))

suc_groupedbar_1 = groupedbar(t, [df1_conc.Sucrose df1011_1_conc.Sucrose], label = ["40 C" "35 C"],
			    xticks = t, title = "Sucrose Concentration",
			    xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar_1, plotsdir("35_40_comp/sucrose_bar_comp_1.png"))

gluc_groupedbar_1 = groupedbar(t, [df1_conc.Glucose df1011_1_conc.Glucose], label = ["40 C" "35 C"],
			    xticks = t, title = "Glucose Concentration",
			    xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar_1, plotsdir("35_40_comp/glucose_bar_comp_1.png"))

fruc_groupedbar_1 = groupedbar(t, [df1_conc.Fructose df1011_1_conc.Fructose], label = ["40 C" "35 C"],
			    xticks = t, title = "Fructose Concentration",
			    xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar_1, plotsdir("35_40_comp/fructose_bar_comp_1.png"))

lact_groupedbar_1 = groupedbar(t, [df1_conc.Lactate df1011_1_conc.Lactate], label = ["40 C" "35 C"],
			    xticks = t, title = "Lactate Concentration",
			    xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar_1, plotsdir("35_40_comp/lactate_bar_comp_1.png"))

acet_groupedbar_1 = groupedbar(t, [df1_conc.Acetate df1011_1_conc.Acetate], label = ["40 C" "35 C"],
			    xticks = t, title = "Acetate Concentration",
			    xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(acet_groupedbar_1, plotsdir("35_40_comp/acetate_bar_comp_1.png"))

prop_groupedbar_1 = groupedbar(t, [df1_conc.Propionate df1011_1_conc.Propionate], label = ["40 C" "35 C"],
			    xticks = t, title = "Propionate Concentration",
			    xlabel = "Time (h)", ylabel = "Propionate (g/l)")
savefig(prop_groupedbar_1, plotsdir("35_40_comp/propionate_bar_comp_1.png"))

eth_groupedbar_1 = groupedbar(t, [df1_conc.Ethanol df1011_1_conc.Ethanol], label = ["40 C" "35 C"],
			    xticks = t, title = "Ethanol Concentration",
			    xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar_1, plotsdir("35_40_comp/ethanol_bar_comp_1.png"))

grouped_bar_comp_1 = plot(suc_groupedbar_1, gluc_groupedbar_1, fruc_groupedbar_1,
			 lact_groupedbar_1, acet_groupedbar_1, prop_groupedbar_1,
			 eth_groupedbar_1, layout = 7, size = (1400, 900))
savefig(grouped_bar_comp_1, plotsdir("35_40_comp/grouped_bar_comp_1.png"))

suc_groupedbar_4 = groupedbar(t, [df4_conc.Sucrose df1011_4_conc.Sucrose], label = ["40 C" "35 C"],
			    xticks = t, title = "Sucrose Concentration",
			    xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar_4, plotsdir("35_40_comp/sucrose_bar_comp_4.png"))

gluc_groupedbar_4 = groupedbar(t, [df4_conc.Glucose df1011_4_conc.Glucose], label = ["40 C" "35 C"],
			    xticks = t, title = "Glucose Concentration",
			    xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar_4, plotsdir("35_40_comp/glucose_bar_comp_4.png"))

fruc_groupedbar_4 = groupedbar(t, [df4_conc.Fructose df1011_4_conc.Fructose], label = ["40 C" "35 C"],
			    xticks = t, title = "Fructose Concentration",
			    xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar_4, plotsdir("35_40_comp/fructose_bar_comp_4.png"))

lact_groupedbar_4 = groupedbar(t, [df4_conc.Lactate df1011_4_conc.Lactate], label = ["40 C" "35 C"],
			    xticks = t, title = "Lactate Concentration",
			    xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar_4, plotsdir("35_40_comp/lactate_bar_comp_4.png"))

acet_groupedbar_4 = groupedbar(t, [df4_conc.Acetate df1011_4_conc.Acetate], label = ["40 C" "35 C"],
			    xticks = t, title = "Acetate Concentration",
			    xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(acet_groupedbar_4, plotsdir("35_40_comp/acetate_bar_comp_4.png"))

prop_groupedbar_4 = groupedbar(t, [df4_conc.Propionate df1011_4_conc.Propionate], label = ["40 C" "35 C"],
			    xticks = t, title = "Propionate Concentration",
			    xlabel = "Time (h)", ylabel = "Propionate (g/l)")
savefig(prop_groupedbar_4, plotsdir("35_40_comp/propionate_bar_comp_4.png"))

eth_groupedbar_4 = groupedbar(t, [df4_conc.Ethanol df1011_4_conc.Ethanol], label = ["40 C" "35 C"],
			    xticks = t, title = "Ethanol Concentration",
			    xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar_4, plotsdir("35_40_comp/ethanol_bar_comp_4.png"))

grouped_bar_comp_4 = plot(suc_groupedbar_4, gluc_groupedbar_4, fruc_groupedbar_4,
			 lact_groupedbar_4, acet_groupedbar_4, prop_groupedbar_4,
			 eth_groupedbar_4, layout = 7, size = (1400, 900))
savefig(grouped_bar_comp_4, plotsdir("35_40_comp/grouped_bar_comp_4.png"))

suc_groupedbar_8 = groupedbar(t, [df8_conc.Sucrose df1011_8_conc.Sucrose], label = ["40 C" "35 C"],
			    xticks = t, title = "Sucrose Concentration",
			    xlabel = "Time (h)", ylabel = "Sucrose (g/l)")
savefig(suc_groupedbar_8, plotsdir("35_40_comp/sucrose_bar_comp_8.png"))

gluc_groupedbar_8 = groupedbar(t, [df8_conc.Glucose df1011_8_conc.Glucose], label = ["40 C" "35 C"],
			    xticks = t, title = "Glucose Concentration",
			    xlabel = "Time (h)", ylabel = "Glucose (g/l)")
savefig(gluc_groupedbar_8, plotsdir("35_40_comp/glucose_bar_comp_8.png"))

fruc_groupedbar_8 = groupedbar(t, [df8_conc.Fructose df1011_8_conc.Fructose], label = ["40 C" "35 C"],
			    xticks = t, title = "Fructose Concentration",
			    xlabel = "Time (h)", ylabel = "Fructose (g/l)")
savefig(fruc_groupedbar_8, plotsdir("35_40_comp/fructose_bar_comp_8.png"))

lact_groupedbar_8 = groupedbar(t, [df8_conc.Lactate df1011_8_conc.Lactate], label = ["40 C" "35 C"],
			    xticks = t, title = "Lactate Concentration",
			    xlabel = "Time (h)", ylabel = "Lactate (g/l)")
savefig(lact_groupedbar_8, plotsdir("35_40_comp/lactate_bar_comp_8.png"))

acet_groupedbar_8 = groupedbar(t, [df8_conc.Acetate df1011_8_conc.Acetate], label = ["40 C" "35 C"],
			    xticks = t, title = "Acetate Concentration",
			    xlabel = "Time (h)", ylabel = "Acetate (g/l)")
savefig(acet_groupedbar_8, plotsdir("35_40_comp/acetate_bar_comp_8.png"))

prop_groupedbar_8 = groupedbar(t, [df8_conc.Propionate df1011_8_conc.Propionate], label =["40 C" "35 C"],
			    xticks = t, title = "Propionate Concentration",
			    xlabel = "Time (h)", ylabel = "Propionate (g/l)")
savefig(prop_groupedbar_8, plotsdir("35_40_comp/propionate_bar_comp_8.png"))

eth_groupedbar_8 = groupedbar(t, [df8_conc.Ethanol df1011_8_conc.Ethanol], label = ["40 C" "35 C"],
			    xticks = t, title = "Ethanol Concentration",
			    xlabel = "Time (h)", ylabel = "Ethanol (g/l)")
savefig(eth_groupedbar_8, plotsdir("35_40_comp/ethanol_bar_comp_8.png"))

grouped_bar_comp_8 = plot(suc_groupedbar_8, gluc_groupedbar_8, fruc_groupedbar_8,
			 lact_groupedbar_8, acet_groupedbar_8, prop_groupedbar_8,
			 eth_groupedbar_8, layout = 7, size = (1400, 900))
savefig(grouped_bar_comp_8, plotsdir("35_40_comp/grouped_bar_comp_8.png"))
