
df2310_1_area = CSV.read("hplc_area_23_10_1.csv", DataFrame)
create_conc_table2(df2310_1_area, "hplc_conc_23_10_1.csv")
df2310_1_conc = CSV.read("hplc_conc_23_10_1.csv", DataFrame)

df2310_2_area = CSV.read("hplc_area_23_10_2.csv", DataFrame)
create_conc_table2(df2310_2_area, "hplc_conc_23_10_2.csv")
df2310_2_conc = CSV.read("hplc_conc_23_10_2.csv", DataFrame)

t1 = df2310_1_conc.Time
t2 = df2310_2_conc.Time

# Scatter Plots
suc_scatter = scatter(t1, [df1_conc.Sucrose], label = "1", title = "Sucrose Concentration",
                      xlabel = "Time (h)", ylabel = "Sucrose (g/l)", markersize = 6)
scatter!(t2, df2_conc.Sucrose, label = "2", markersize = 6)
savefig(suc_scatter, "sucrose_scatter_23_10.png")

gluc_scatter = scatter(t1, [df1_conc.Glucose], label = "1", title = "Glucose Concentration",
                      xlabel = "Time (h)", ylabel = "Glucose (g/l)", markersize = 6)
scatter!(t2, df2_conc.Glucose, label = "2", markersize = 6)
savefig(gluc_scatter, "glucose_scatter_23_10.png")

fruc_scatter = scatter(t1, [df1_conc.Fructose], label = "1", title = "Fructose Concentration",
                      xlabel = "Time (h)", ylabel = "Fructose (g/l)", markersize = 6)
scatter!(t2, df2_conc.Fructose, label = "2", markersize = 6)
savefig(fruc_scatter, "fructose_scatter_23_10.png")

lact_scatter = scatter(t1, [df1_conc.Lactate], label = "1", title = "Lactate Concentration",
                      xlabel = "Time (h)", ylabel = "Lactate (g/l)", markersize = 6)
scatter!(t2, df2_conc.Lactate, label = "2", markersize = 6)
savefig(lact_scatter, "lactate_scatter_23_10.png")

ac_scatter = scatter(t1, [df1_conc.Acetate], label = "1", title = "Acetate Concentration",
                      xlabel = "Time (h)", ylabel = "Acetate (g/l)", markersize = 6)
scatter!(t2, df2_conc.Acetate, label = "2", markersize = 6)
savefig(ac_scatter, "acetate_scatter_23_10.png")

prop_scatter = scatter(t1, [df1_conc.Propionate], label = "1", title = "Propionate Concentration",
                      xlabel = "Time (h)", ylabel = "Propionate (g/l)", markersize = 6)
scatter!(t2, df2_conc.Propionate, label = "2", markersize = 6)
savefig(prop_scatter, "propionate_scatter_23_10.png")

eth_scatter = scatter(t1, [df1_conc.Ethanol], label = "1", title = "Ethanol Concentration",
                      xlabel = "Time (h)", ylabel = "Ethanol (g/l)", markersize = 6)
scatter!(t2, df2_conc.Ethanol, label = "2", markersize = 6)
savefig(eth_scatter, "ethanol_scatter_23_10.png")

scatter_final = plot(suc_scatter, gluc_scatter, fruc_scatter,
                         lact_scatter, ac_scatter, prop_scatter,
                         eth_scatter, layout = 9, size = (1350, 900))
savefig(scatter_final, "scatter_final_23_10.png")

df2310_1_sucrose_red = (df2310_1_conc.Sucrose[1] .- df2310_1_conc.Sucrose)/df2310_1_conc.Sucrose[1]*100
df2310_2_sucrose_red = (df2310_2_conc.Sucrose[1] .- df2310_2_conc.Sucrose)/df2310_2_conc.Sucrose[1]*100

df2310_1_glucose_red = (df2310_1_conc.Glucose[1] .- df2310_1_conc.Glucose)/df2310_1_conc.Glucose[1]*100
df2310_2_glucose_red = (df2310_2_conc.Glucose[1] .- df2310_2_conc.Glucose)/df2310_2_conc.Glucose[1]*100

df2310_1_fructose_red = (df2310_1_conc.Fructose[1] .- df2310_1_conc.Fructose)/df2310_1_conc.Fructose[1]*100
df2310_2_fructose_red = (df2310_2_conc.Fructose[1] .- df2310_2_conc.Fructose)/df2310_2_conc.Fructose[1]*100

sucrose_red_scatter = scatter(t1, df2310_1_sucrose_red, label = "1",
                              title = "Sucrose Reduction Rate",
                              xlabel = "Time (h)", ylabel = "Sucrose Reduction (%)",
                              markersize = 6)
scatter!(t2, df2310_2_sucrose_red, label = "2", markersize = 6)
savefig(sucrose_red_scatter, "sucrose_red_scatter_23_10.png")

glucose_red_scatter = scatter(t1, df2310_1_glucose_red, label = "1",
                              title = "Glucose Reduction Rate",
                              xlabel = "Time (h)", ylabel = "Glucose Reduction (%)",
                              markersize = 6)
scatter!(t2, df2310_2_glucose_red, label = "2", markersize = 6)
savefig(glucose_red_scatter, "glucose_red_scatter_23_10.png")

fructose_red_scatter = scatter(t1, df2310_1_fructose_red, label = "1",
                              title = "Fructose Reduction Rate",
                              xlabel = "Time (h)", ylabel = "Fructose Reduction (%)",
                              markersize = 6)
scatter!(t2, df2310_2_fructose_red, label = "2", markersize = 6)
savefig(fructose_red_scatter, "fructose_red_scatter_23_10.png")

sugar_red_scatter = plot(sucrose_red_scatter, fructose_red_scatter, glucose_red_scatter, layout = (3,1), size = (900, 600))
savefig(sugar_red_scatter, "sugar_red_scatter_23_10.png")
