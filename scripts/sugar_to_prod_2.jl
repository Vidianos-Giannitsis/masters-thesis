using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("hplc_analysis.jl"))
include(srcdir("filenames.jl"))

# 10/11 Experiment
date = "10_11"


mix_amount = ["0", "1", "2", "4", "8"]
t = [0, 24, 48, 72]

df0_conc = process_area_data(get_area_csv(date, mix_amount[1]), get_conc_csv(date, mix_amount[1]))
df1_conc = process_area_data(get_area_csv(date, mix_amount[2]), get_conc_csv(date, mix_amount[2]))
df2_conc = process_area_data(get_area_csv(date, mix_amount[3]), get_conc_csv(date, mix_amount[3]))
df4_conc = process_area_data(get_area_csv(date, mix_amount[4]), get_conc_csv(date, mix_amount[4]))
df8_conc = process_area_data(get_area_csv(date, mix_amount[5]), get_conc_csv(date, mix_amount[5]))


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


sug_to_prod_0 = df0_prod./(first(df0_sugars) - last(df0_sugars))
Δprod_0 = (last(sug_to_prod_0) - first(sug_to_prod_0))*100

sug_to_prod_1 = df1_prod./(first(df1_sugars) - last(df1_sugars))
Δprod_1 = (last(sug_to_prod_1) - first(sug_to_prod_1))*100

sug_to_prod_2 = df2_prod./(first(df2_sugars) - last(df2_sugars))
Δprod_2 = (last(sug_to_prod_2) - first(sug_to_prod_2))*100

sug_to_prod_4 = df4_prod./(first(df4_sugars) - last(df4_sugars))
Δprod_4 = (last(sug_to_prod_4) - first(sug_to_prod_4))*100

sug_to_prod_8 = df8_prod./(first(df8_sugars) - last(df8_sugars))
Δprod_8 = (last(sug_to_prod_8) - first(sug_to_prod_8))*100

Δprod_10_11 = [Δprod_0, Δprod_1, Δprod_2, Δprod_4, Δprod_8]

# 28/11 Experiment
date = "28_11"


mix_amount = ["0", "1", "2", "4", "8"]
t = [0, 24, 48, 72]

df0_conc = process_area_data(get_area_csv(date, mix_amount[1]), get_conc_csv(date, mix_amount[1]))
df1_conc = process_area_data(get_area_csv(date, mix_amount[2]), get_conc_csv(date, mix_amount[2]))
df2_conc = process_area_data(get_area_csv(date, mix_amount[3]), get_conc_csv(date, mix_amount[3]))
df4_conc = process_area_data(get_area_csv(date, mix_amount[4]), get_conc_csv(date, mix_amount[4]))
df8_conc = process_area_data(get_area_csv(date, mix_amount[5]), get_conc_csv(date, mix_amount[5]))


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


sug_to_prod_0 = df0_prod./(first(df0_sugars) - last(df0_sugars))
Δprod_0 = (last(sug_to_prod_0) - first(sug_to_prod_0))*100

sug_to_prod_1 = df1_prod./(first(df1_sugars) - last(df1_sugars))
Δprod_1 = (last(sug_to_prod_1) - first(sug_to_prod_1))*100

sug_to_prod_2 = df2_prod./(first(df2_sugars) - last(df2_sugars))
Δprod_2 = (last(sug_to_prod_2) - first(sug_to_prod_2))*100

sug_to_prod_4 = df4_prod./(first(df4_sugars) - last(df4_sugars))
Δprod_4 = (last(sug_to_prod_4) - first(sug_to_prod_4))*100

sug_to_prod_8 = df8_prod./(first(df8_sugars) - last(df8_sugars))
Δprod_8 = (last(sug_to_prod_8) - first(sug_to_prod_8))*100

Δprod_28_11 = [Δprod_0, Δprod_1, Δprod_2, Δprod_4, Δprod_8]

# 23/10 Experiment

date = "23_10"
df2310_1_conc = process_area_data2(get_area_csv(date, "1"), get_conc_csv(date, "1"))
t1 = df2310_1_conc.Time

df2310_2_conc = process_area_data2(get_area_csv(date, "2"), get_conc_csv(date, "2"))
t2 = df2310_2_conc.Time

df2310_1_total = map(sum, eachrow(df2310_1_conc[:, 2:8]))
df2310_2_total = map(sum, eachrow(df2310_2_conc[:, 2:8]))

df2310_1_sugars = map(sum, eachrow(df2310_1_conc[:, 2:4]))
df2310_2_sugars = map(sum, eachrow(df2310_2_conc[:, 2:4]))

df2310_1_prod = map(sum, eachrow(df2310_1_conc[:, 5:8]))
df2310_2_prod = map(sum, eachrow(df2310_2_conc[:, 5:8]))


sug_to_prod_2310_1 = df2310_1_prod./(first(df2310_1_sugars) - last(df2310_1_sugars))
Δprod_2310_1 = (last(sug_to_prod_2310_1) - first(sug_to_prod_2310_1))*100

sug_to_prod_2310_2 = df2310_2_prod./(first(df2310_2_sugars) - last(df2310_2_sugars))
Δprod_2310_2 = (last(sug_to_prod_2310_2) - first(sug_to_prod_2310_2))*100

Δprod_plot_10_11 = scatter([0, 1, 2, 3, 4], [Δprod_10_11],
		     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
		     ylabel = "Product Yield (%)", markersize = 6,
		     title = "Yield of sugars to products T = 35 C",
		     legend = false)
savefig(Δprod_plot_10_11, plotsdir("10_11/Δprod_10_11.png"))

Δprod_plot_28_11 = scatter([0, 1, 2, 3, 4], [Δprod_28_11],
		     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
		     ylabel = "Product Yield (%)", markersize = 6,
		     title = "Yield of sugars to products T = 40 C",
		     legend = false)
savefig(Δprod_plot_28_11, plotsdir("28_11/Δprod_28_11.png"))

Δprod_comp_plot_1 = scatter([0, 1, 2, 3, 4], [Δprod_10_11 Δprod_28_11],
		     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
		     ylabel = "Product Yield (%)", markersize = 6,
		     title = "Yield of sugars to products",
		     label = ["35 C" "40 C"])
savefig(Δprod_comp_plot_1, plotsdir("35_40_comp/Δprod.png"))

Δprod_comp_plot_2 = scatter([0, 1, 2, 3, 4], [Δprod_10_11 Δprod_28_11],
		     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
		     ylabel = "Product Yield (%)", markersize = 6,
		     title = "Yield of sugars to products",
		     label = ["35 C" "40 C"])
scatter!([2], [Δprod_2310_1 Δprod_2310_2], markersize = 6,
	 label = ["45 C (1)" "45 C (2)"])
savefig(Δprod_comp_plot_2, plotsdir("35_40_45_comp/Δprod.png"))
