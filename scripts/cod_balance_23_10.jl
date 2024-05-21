using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("cod_balance.jl"))
include(srcdir("filenames.jl"))
using CSV, DataFrames
using StatsPlots

date = "23_10"
df1_conc = CSV.read(get_conc_csv(date, "1"), DataFrame)
t1 = df1_conc[1:19, 1]
df1_conc = df1_conc[1:19, 2:8]
df2_conc = CSV.read(get_conc_csv(date, "2"), DataFrame)
t2 = df2_conc[1:15, 1]
df2_conc = df2_conc[1:15, 2:8]

cod_yields = [cod_sucrose(), cod_glucose(), cod_fructose(), cod_acetate(),
	      cod_propionate(), cod_lactate(), cod_ethanol()]

cod_1_theor = [sum(Vector(df1_conc[i, :]).*cod_yields) for i in 1:19]
cod_2_theor = [sum(Vector(df2_conc[i, :]).*cod_yields) for i in 1:15]


cod_1_meas = process_cod_data("1", date; dilution = 50)./1000
cod_1_error = cod_1_meas - cod_1_theor
cod_2_meas = process_cod_data("2", date; dilution = 50)./1000
cod_2_error = cod_2_meas - cod_2_theor


label = ["COD Measurement" "HPLC Measurement"]
plot_type = "comparison"

cod_1_plot = scatter(t1, [cod_1_meas cod_1_theor], label=label,
		 xlabel = "Time (h)", ylabel = "COD (g/l)",
		 title = "Sample 1", markersize = 6)
savefig(cod_1_plot, get_plot_name("cod_1", date, plot_type))

cod_2_plot = scatter(t2, [cod_2_meas cod_2_theor], label=label,
		 xlabel = "Time (h)", ylabel = "COD (g/l)",
		 title = "Sample 2", markersize = 6)
savefig(cod_2_plot, get_plot_name("cod_2", date, plot_type))

cod_plot = plot(cod_1_plot, cod_2_plot, layout = (2,1), size = (900, 600))
savefig(cod_plot, get_plot_name("cod", date, plot_type))

cod_meas_plot_1 = scatter(t1, cod_1_meas, xlabel = "Time (h)", ylabel = "COD (g/l)",
			  title = "Sample 1", markersize = 4,
			  markercolor = "#009AFA", legend = false)
plot!(t1, cod_1_meas, linecolor = "#009AFA")
cod_meas_plot_2 = scatter(t2, cod_2_meas, xlabel = "Time (h)", ylabel = "COD (g/l)",
			  title = "Sample 2", markersize = 4,
			  markercolor = "#E36F47", legend = false)
plot!(t2, cod_2_meas, linecolor = "#E36F47")
cod_meas_plot = plot(cod_meas_plot_1, cod_meas_plot_2, size = (900, 600), left_margin = 3Plots.mm, plot_title = "COD Measurements")
savefig(cod_meas_plot, get_plot_name("cod", date, "scatter"))
