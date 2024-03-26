using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("cod_balance.jl"))
include(srcdir("filenames.jl"))
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

df0_cod0 = sum(df0_conc0.*cod_yields)
df1_cod0 = sum(df1_conc0.*cod_yields)
df2_cod0 = sum(df2_conc0.*cod_yields)
df4_cod0 = sum(df4_conc0.*cod_yields)
df8_cod0 = sum(df8_conc0.*cod_yields)
cod0_theor = [df0_cod0, df1_cod0, df2_cod0, df4_cod0, df8_cod0]
cod0_meas = cod_meas.COD_0./1000
cod0_error = cod0_meas - cod0_theor

df0_cod72 = sum(df0_conc72.*cod_yields)
df1_cod72 = sum(df1_conc72.*cod_yields)
df2_cod72 = sum(df2_conc72.*cod_yields)
df4_cod72 = sum(df4_conc72.*cod_yields)
df8_cod72 = sum(df8_conc72.*cod_yields)
cod72_theor = [df0_cod72, df1_cod72, df2_cod72, df4_cod72, df8_cod72]
cod72_meas = cod_meas.COD_72./1000
cod72_error = cod72_meas - cod72_theor


label = ["COD Measurement" "HPLC Measurement"]
plot_type = "comparison"

cod0_plot = groupedbar([0, 1, 2, 3, 4], [cod0_meas cod0_theor],
		       label = label, xlabel = "Amount of mix (ml)",
		       ylabel = "COD (g/l)", legend =:bottom,
		       title = "COD comparison t=0",
		       xticks = (0:4, mix_amount))
savefig(cod0_plot, get_plot_name("cod_0", date, plot_type))

cod72_plot = groupedbar([0, 1, 2, 3, 4], [cod72_meas cod72_theor],
		       label = label, xlabel = "Amount of mix (ml)",
		       ylabel = "COD (g/l)", legend =:bottom,
		       title = "COD comparison t=72 h",
		       xticks = (0:4, mix_amount))
savefig(cod72_plot, get_plot_name("cod_72", date, plot_type))

cod_plot = plot(cod0_plot, cod72_plot, layout = (2,1), size = (900, 600))
savefig(cod_plot, get_plot_name("cod", date, plot_type))
