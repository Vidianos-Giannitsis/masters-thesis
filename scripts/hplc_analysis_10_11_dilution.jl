using DrWatson
@quickactivate "Masters_Thesis"

using CSV, DataFrames, StatsPlots

t = [0, 24, 48, 72]
V = [0.8, 0.79, 0.78, 0.77]
df0_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_0.csv"), DataFrame)
select!(df0_conc, Not(:pH))
select!(df0_conc, Not(:EC))
select!(df0_conc, Not(:Time))
df0_mass = df0_conc.*V

df1_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_1.csv"), DataFrame)
select!(df1_conc, Not(:pH))
select!(df1_conc, Not(:EC))
select!(df1_conc, Not(:Time))
df1_mass = df1_conc.*V

df2_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_2.csv"), DataFrame)
select!(df2_conc, Not(:pH))
select!(df2_conc, Not(:EC))
select!(df2_conc, Not(:Time))
df2_mass = df2_conc.*V

df4_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_4.csv"), DataFrame)
select!(df4_conc, Not(:pH))
select!(df4_conc, Not(:EC))
select!(df4_conc, Not(:Time))
df4_mass = df4_conc.*V

df8_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_8.csv"), DataFrame)
select!(df8_conc, Not(:pH))
select!(df8_conc, Not(:EC))
select!(df8_conc, Not(:Time))
df8_mass = df8_conc.*V

df0_total = map(sum, eachrow(df0_mass))
df1_total = map(sum, eachrow(df1_mass))
df2_total = map(sum, eachrow(df2_mass))
df4_total = map(sum, eachrow(df4_mass))
df8_total = map(sum, eachrow(df8_mass))

df0_sugars = map(sum, eachrow(df0_mass[:, 1:3]))
df1_sugars = map(sum, eachrow(df1_mass[:, 1:3]))
df2_sugars = map(sum, eachrow(df2_mass[:, 1:3]))
df4_sugars = map(sum, eachrow(df4_mass[:, 1:3]))
df8_sugars = map(sum, eachrow(df8_mass[:, 1:3]))

df0_prod = map(sum, eachrow(df0_mass[:, 4:7]))
df1_prod = map(sum, eachrow(df1_mass[:, 4:7]))
df2_prod = map(sum, eachrow(df2_mass[:, 4:7]))
df4_prod = map(sum, eachrow(df4_mass[:, 4:7]))
df8_prod = map(sum, eachrow(df8_mass[:, 4:7]))

plot_label = ["0 ml" "1 ml" "2 ml" "4 ml" "8 ml"]
colors = ["#009AFA" "#E36F47" "#3EA44E" "#C371D2" "#AC8E18"]
total_mass = plot(t, [df0_total df1_total df2_total df4_total df8_total], title = "Total Mass",
                  xlabel = "Time (h)", ylabel = "Mass (g)", label = plot_label,
                  linecolor = colors)
scatter!(t, [df0_total df1_total df2_total df4_total df8_total], markersize = 6, label = plot_label,
         markercolor = colors)
savefig(total_mass, plotsdir("10_11/total_mass_10_11.png"))

sugars_mass = plot(t, [df0_sugars df1_sugars df2_sugars df4_sugars df8_sugars], title = "Sugars Mass",
                  xlabel = "Time (h)", ylabel = "Mass (g)", label = plot_label,
                  linecolor = colors)
scatter!(t, [df0_sugars df1_sugars df2_sugars df4_sugars df8_sugars], markersize = 6, label = plot_label,
         markercolor = colors)
savefig(sugars_mass, plotsdir("10_11/sugars_mass_10_11.png"))

prod_mass = plot(t, [df0_prod df1_prod df2_prod df4_prod df8_prod], title = "Product Mass",
                  xlabel = "Time (h)", ylabel = "Mass (g)", label = plot_label,
                  linecolor = colors, legend = :topleft)
scatter!(t, [df0_prod df1_prod df2_prod df4_prod df8_prod], markersize = 6, label = plot_label,
         markercolor = colors)
savefig(prod_mass, plotsdir("10_11/prod_mass_10_11.png"))

final_plot = plot(sugars_mass, prod_mass, total_mass, size = (1200, 800))
savefig(final_plot, plotsdir("10_11/total_mass_plots_10_11.png"))

mix_amount = ["0", "1", "2", "4", "8"]
init_sugars = [df0_sugars[1], df1_sugars[1], df2_sugars[1], df4_sugars[1], df8_sugars[1]]
final_prod = [df0_prod[4], df1_prod[4], df2_prod[4], df4_prod[4], df8_prod[4]]
sugar_to_prod = scatter([0, 1, 2, 3, 4], [init_sugars final_prod],
                         xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
                         ylabel = "Mass (g)", title = "Conversion of sugars to products, T = 35 C",
                         label = ["Initial Sugars" "Final Products"], markersize = 6)
savefig(sugar_to_prod, plotsdir("10_11/sugar_to_prod_mass_10_11.png"))

# Conversion of sugars to useful products
df0_10_11_conv = df0_prod[4]/df0_sugars[1]
df1_10_11_conv = df1_prod[4]/df1_sugars[1]
df2_10_11_conv = df2_prod[4]/df2_sugars[1]
df4_10_11_conv = df4_prod[4]/df4_sugars[1]
df8_10_11_conv = df8_prod[4]/df8_sugars[1]
conversion_10_11 = [df0_10_11_conv, df1_10_11_conv, df2_10_11_conv, df4_10_11_conv, df8_10_11_conv]

sugar_10_11_conv = scatter([0, 1, 2, 3, 4], [conversion_10_11],
                     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
                     ylabel = "Mass Conversion rate", markersize = 6,
                     title = "Conversion of sugars to products, T = 35 C",
                     legend = false)
savefig(sugar_10_11_conv, plotsdir("10_11/sugar_conv_mass_10_11.png"))

sugar_conv = scatter([0, 1, 2, 3, 4], [conversion_10_11 conversion_28_11],
                     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
                     ylabel = "Conversion rate", markersize = 6,
                     title = "Conversion of sugars to products",
                     label = ["35 C" "40 C"])
savefig(sugar_conv, plotsdir("35_40_comp/sugar_conv_mass.png"))

# Add the points of the 45 C experiment
df2310_1_conv = df2310_1_prod[21]/df2310_1_sugars[1]
df2310_2_conv = df2310_2_prod[17]/df2310_2_sugars[1]

sugar_conv_complete = scatter([0, 1, 2, 3, 4], [conversion_10_11 conversion_28_11],
                              xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
                              ylabel = "Conversion rate", markersize = 6,
                              title = "Conversion of sugars to products",
                              label = ["35 C" "40 C"])
scatter!([2], [df2310_1_conv df2310_2_conv],
         markersize = 6, label = ["45 C (1)" "45 C (2)"])
savefig(sugar_conv_complete, plotsdir("35_40_45_comp/sugar_conv_mass.png"))

# Another "test" case
sug_to_prod_0 = df0_prod./df0_sugars[1]
Δprod_0 = (last(sug_to_prod_0) - first(sug_to_prod_0))*100

sug_to_prod_1 = df1_prod./df1_sugars[1]
Δprod_1 = (last(sug_to_prod_1) - first(sug_to_prod_1))*100

sug_to_prod_2 = df2_prod./df2_sugars[1]
Δprod_2 = (last(sug_to_prod_2) - first(sug_to_prod_2))*100

sug_to_prod_4 = df4_prod./df4_sugars[1]
Δprod_4 = (last(sug_to_prod_4) - first(sug_to_prod_4))*100

sug_to_prod_8 = df8_prod./df8_sugars[1]
Δprod_8 = (last(sug_to_prod_8) - first(sug_to_prod_8))*100

Δprod_10_11 = [Δprod_0, Δprod_1, Δprod_2, Δprod_4, Δprod_8]

Δprod_plot_10_11 = scatter([0, 1, 2, 3, 4], [Δprod_10_11],
                     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
                     ylabel = "Δprod/Sugars (%)", markersize = 6,
                     title = "Δm of products divided by sugars T = 35 C",
                     legend = false)
savefig(Δprod_plot_10_11, plotsdir("10_11/Δprod_mass_10_11.png"))

Δprod_comp_plot_1 = scatter([0, 1, 2, 3, 4], [Δprod_10_11 Δprod_28_11],
                     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
                     ylabel = "Δprod/Sugars (%)", markersize = 6,
                     title = "Change in products divided by sugars",
                     label = ["35 C" "40 C"])
savefig(Δprod_comp_plot_1, plotsdir("35_40_comp/Δprod_mass.png"))

sug_to_prod_2310_1 = df2310_1_prod./df2310_1_sugars[1]
Δprod_2310_1 = (last(sug_to_prod_2310_1) - sug_to_prod_2310_1[7])*100
sug_to_prod_2310_2 = df2310_2_prod./df2310_2_sugars[1]
Δprod_2310_2 = (last(sug_to_prod_2310_2) - sug_to_prod_2310_2[2])*100

Δprod_comp_plot_2 = scatter([0, 1, 2, 3, 4], [Δprod_10_11 Δprod_28_11],
                     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
                     ylabel = "Δprod/Sugars (%)", markersize = 6,
                     title = "Change in products divided by sugars",
                     label = ["35 C" "40 C"])
scatter!([2], [Δprod_2310_1 Δprod_2310_2], markersize = 6,
         label = ["45 C (1)" "45 C (2)"])
savefig(Δprod_comp_plot_2, plotsdir("35_40_45_comp/Δprod_mass.png"))
