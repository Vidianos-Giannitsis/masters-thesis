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


df0_10_11_conv = df0_prod[4]/df0_sugars[1]
df1_10_11_conv = df1_prod[4]/df1_sugars[1]
df2_10_11_conv = df2_prod[4]/df2_sugars[1]
df4_10_11_conv = df4_prod[4]/df4_sugars[1]
df8_10_11_conv = df8_prod[4]/df8_sugars[1]
conversion_10_11 = [df0_10_11_conv, df1_10_11_conv, df2_10_11_conv, df4_10_11_conv, df8_10_11_conv].*100

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


df0_28_11_conv = df0_prod[4]/df0_sugars[1]
df1_28_11_conv = df1_prod[4]/df1_sugars[1]
df2_28_11_conv = df2_prod[4]/df2_sugars[1]
df4_28_11_conv = df4_prod[4]/df4_sugars[1]
df8_28_11_conv = df8_prod[4]/df8_sugars[1]
conversion_28_11 = [df0_28_11_conv, df1_28_11_conv, df2_28_11_conv, df4_28_11_conv, df8_28_11_conv].*100

# 23/10 Experiment
df2310_1_conv = df2310_1_prod[21]/df2310_1_sugars[1]*100
df2310_2_conv = df2310_2_prod[17]/df2310_2_sugars[1]*100

sugar_10_11_conv = scatter([0, 1, 2, 3, 4], [conversion_10_11],
		     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
		     ylabel = "Conversion rate (%)", markersize = 6,
		     title = "Conversion of sugars to products, T = 35 C",
		     legend = false)
savefig(sugar_10_11_conv, plotsdir("10_11/sugar_conv_10_11.png"))

sugar_28_11_conv = scatter([0, 1, 2, 3, 4], [conversion_28_11],
		     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
		     ylabel = "Conversion rate (%)", markersize = 6,
		     title = "Conversion of sugars to products, T = 40 C",
		     legend = false)
savefig(sugar_28_11_conv, plotsdir("28_11/sugar_conv_28_11.png"))

sugar_conv = scatter([0, 1, 2, 3, 4], [conversion_10_11 conversion_28_11],
		     xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
		     ylabel = "Conversion rate (%)", markersize = 6,
		     title = "Conversion of sugars to products",
		     label = ["35 C" "40 C"])
savefig(sugar_conv, plotsdir("35_40_comp/sugar_conv.png"))

sugar_conv_complete = scatter([0, 1, 2, 3, 4], [conversion_10_11 conversion_28_11],
			      xticks = (0:4, mix_amount), xlabel = "Amount of mix (ml)",
			      ylabel = "Conversion rate (%)", markersize = 6,
			      title = "Conversion of sugars to products",
			      label = ["35 C" "40 C"])
scatter!([2], [df2310_1_conv df2310_2_conv],
	 markersize = 6, label = ["45 C (1)" "45 C (2)"])
savefig(sugar_conv_complete, plotsdir("35_40_45_comp/sugar_conv.png"))
