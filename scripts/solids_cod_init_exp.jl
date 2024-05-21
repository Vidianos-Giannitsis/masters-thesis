using DrWatson
@quickactivate "Masters_Thesis"

using CSV, DataFrames
using Plots

data_df = CSV.read(datadir("exp_pro", "solids_cod_10_10.csv"), DataFrame)
t = [2, 4, 24]
tss = data_df.TSS
vss = data_df.VSS
cod = data_df.sCOD

tss_3 = tss[1:3]
vss_3 = vss[1:3]
cod_3 = cod[1:3]

tss_4 = tss[4:6]
vss_4 = vss[4:6]
cod_4 = cod[4:6]

tss_plot_3 = scatter(t, tss_3, xlabel = "Time (h)", ylabel = "TSS (g/l)", title = "Dilution 1:2", markercolor = "#009AFA", xticks = [0, 2, 4, 8, 12, 16, 20, 24], legend = false)
plot!(t, tss_3, linecolor = "#009AFA")
tss_plot_4 = scatter(t, tss_4, xlabel = "Time (h)", ylabel = "TSS (g/l)", title = "Dilution 1:3", markercolor = "#E36F47", xticks = [0, 2, 4, 8, 12, 16, 20, 24], legend = false)
plot!(t, tss_4, linecolor = "#E36F47")
tss_plot = plot(tss_plot_3, tss_plot_4, plot_title = "Total Suspended Solids Measurements", size = (900, 600), left_margin = 3Plots.mm)
savefig(tss_plot, plotsdir("10_10", "tss_plot.png"))

vss_plot_3 = scatter(t, vss_3, xlabel = "Time (h)", ylabel = "VSS (g/l)", title = "Dilution 1:2", markercolor = "#009AFA", xticks = [0, 2, 4, 8, 12, 16, 20, 24], legend = false)
plot!(t, vss_3, linecolor = "#009AFA")
vss_plot_4 = scatter(t, vss_4, xlabel = "Time (h)", ylabel = "VSS (g/l)", title = "Dilution 1:3", markercolor = "#E36F47", xticks = [0, 2, 4, 8, 12, 16, 20, 24], legend = false)
plot!(t, vss_4, linecolor = "#E36F47")
vss_plot = plot(vss_plot_3, vss_plot_4, plot_title = "Volatile Suspended Solids Measurements", size = (900, 600), left_margin = 3Plots.mm)
savefig(vss_plot, plotsdir("10_10", "vss_plot.png"))

COD_plot_3 = scatter(t, cod_3, xlabel = "Time (h)", ylabel = "COD (mg/l)", title = "Dilution 1:2", markercolor = "#009AFA", xticks = [0, 2, 4, 8, 12, 16, 20, 24], legend = false)
plot!(t, cod_3, linecolor = "#009AFA")
COD_plot_4 = scatter(t, cod_4, xlabel = "Time (h)", ylabel = "COD (mg/l)", title = "Dilution 1:3", markercolor = "#E36F47", xticks = [0, 2, 4, 8, 12, 16, 20, 24], legend = false)
plot!(t, cod_4, linecolor = "#E36F47")
COD_plot = plot(COD_plot_3, COD_plot_4, plot_title = "Soluble COD Measurements", size = (900, 600), left_margin = 3Plots.mm)
savefig(COD_plot, plotsdir("10_10", "COD_plot.png"))
