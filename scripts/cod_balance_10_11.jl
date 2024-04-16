using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("cod_balance.jl"))
include(srcdir("filenames.jl"))
using CSV, DataFrames
using StatsPlots

date = "10_11"

mix_amount = ["0", "1", "2", "4", "8"]
df0_conc = CSV.read(get_conc_csv(date, mix_amount[1]), DataFrame)
df1_conc = CSV.read(get_conc_csv(date, mix_amount[2]), DataFrame)
df2_conc = CSV.read(get_conc_csv(date, mix_amount[3]), DataFrame)
df4_conc = CSV.read(get_conc_csv(date, mix_amount[4]), DataFrame)
df8_conc = CSV.read(get_conc_csv(date, mix_amount[5]), DataFrame)

cod_meas = CSV.read(get_cod_csv(date), DataFrame)

df0_conc0 = Vector(df0_conc[1, 2:8])
df1_conc0 = Vector(df1_conc[1, 2:8])
df2_conc0 = Vector(df2_conc[1, 2:8])
df4_conc0 = Vector(df4_conc[1, 2:8])
df8_conc0 = Vector(df8_conc[1, 2:8])

df0_conc72 = Vector(df0_conc[4, 2:8])
df1_conc72 = Vector(df1_conc[4, 2:8])
df2_conc72 = Vector(df2_conc[4, 2:8])
df4_conc72 = Vector(df4_conc[4, 2:8])
df8_conc72 = Vector(df8_conc[4, 2:8])

cod_yields = [cod_sucrose(), cod_glucose(), cod_fructose(), cod_acetate(),
	      cod_propionate(), cod_lactate(), cod_ethanol()]

df0_cod0 = df0_conc0.*cod_yields
df1_cod0 = df1_conc0.*cod_yields
df2_cod0 = df2_conc0.*cod_yields
df4_cod0 = df4_conc0.*cod_yields
df8_cod0 = df8_conc0.*cod_yields

df0_cod0_sum = sum(df0_cod0)
df1_cod0_sum = sum(df1_cod0)
df2_cod0_sum = sum(df2_cod0)
df4_cod0_sum = sum(df4_cod0)
df8_cod0_sum = sum(df8_cod0)

cod0_theor = [df0_cod0_sum, df1_cod0_sum, df2_cod0_sum, df4_cod0_sum, df8_cod0_sum]
cod0_meas = cod_meas.COD_0./1000
cod0_error = cod0_meas - cod0_theor

df0_cod72 = df0_conc72.*cod_yields
df1_cod72 = df1_conc72.*cod_yields
df2_cod72 = df2_conc72.*cod_yields
df4_cod72 = df4_conc72.*cod_yields
df8_cod72 = df8_conc72.*cod_yields

df0_VFA_cod = df0_cod72[4:7]
df1_VFA_cod = df1_cod72[4:7]
df2_VFA_cod = df2_cod72[4:7]
df4_VFA_cod = df4_cod72[4:7]
df8_VFA_cod = df8_cod72[4:7]
VFA_vec = [hcat(df0_VFA_cod, df1_VFA_cod, df2_VFA_cod, df4_VFA_cod, df8_VFA_cod)[i, :] for i in 1:4]

df0_cod72_sum = sum(df0_cod72)
df1_cod72_sum = sum(df1_cod72)
df2_cod72_sum = sum(df2_cod72)
df4_cod72_sum = sum(df4_cod72)
df8_cod72_sum = sum(df8_cod72)

cod72_theor = [df0_cod72_sum, df1_cod72_sum, df2_cod72_sum, df4_cod72_sum, df8_cod72_sum]
cod72_meas = cod_meas.COD_72./1000
cod72_error = cod72_meas - cod72_theor


label = ["COD Measurement" "HPLC Measurement"]
plot_type = "comparison"

cod0_comp_plot = groupedbar([0, 1, 2, 3, 4], [cod0_meas cod0_theor],
		       label = label, xlabel = "Amount of mix (ml)",
		       ylabel = "COD (g/l)", legend =:bottom,
		       title = "COD comparison t=0",
		       xticks = (0:4, mix_amount))
savefig(cod0_comp_plot, get_plot_name("cod_0", date, plot_type))

cod72_comp_plot = groupedbar([0, 1, 2, 3, 4], [cod72_meas cod72_theor],
		       label = label, xlabel = "Amount of mix (ml)",
		       ylabel = "COD (g/l)", legend =:bottom,
		       title = "COD comparison t=72 h",
		       xticks = (0:4, mix_amount))
savefig(cod72_comp_plot, get_plot_name("cod_72", date, plot_type))

cod_comp_plot = plot(cod0_comp_plot, cod72_comp_plot, layout = (2,1), size = (900, 600))
savefig(cod_comp_plot, get_plot_name("cod", date, plot_type))

plot_type = "bar"
cod0_plot = bar([0, 1, 2, 3, 4], cod0_meas,
		xlabel = "Amount of mix (ml)",
		ylabel = "COD (g/l)", legend = false,
		title = "COD @t=0",
		xticks = (0:4, mix_amount))
savefig(cod0_comp_plot, get_plot_name("cod_0", date, plot_type))

cod72_plot = bar([0, 1, 2, 3, 4], cod72_meas,
		 xlabel = "Amount of mix (ml)",
		 ylabel = "COD (g/l)", legend = false,
		 title = "COD @t=72 h",
		 xticks = (0:4, mix_amount), fc = "#E36F47")
savefig(cod72_comp_plot, get_plot_name("cod_72", date, plot_type))

cod_plot = plot(cod0_plot, cod72_plot, layout = (2,1), size = (900, 600))
savefig(cod_plot, get_plot_name("cod", date, plot_type))

vfa_plot = groupedbar([0, 1, 2, 3, 4],
		      [VFA_vec[1] VFA_vec[2] VFA_vec[3] VFA_vec[4]],
		      bar_position = :stack, xticks = (0:4, mix_amount),
		      label = ["Lactate" "Acetate" "Propionate" "Ethanol"],
		      xlabel = "Amount of mix (ml)", ylabel = "VFAs (g COD-eq/L)",
		      title = "VFAs Produced during Fermentation",
		      legend = :outerright)
savefig(vfa_plot, get_plot_name("vfa_cod", date, "stackedbar"))
