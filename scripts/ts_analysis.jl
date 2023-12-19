using DrWatson
@quickactivate "Masters_Thesis"

using CSV, DataFrames, Plots

df = CSV.read(datadir("exp_raw", "ts_4_12.csv"), DataFrame)

time = df.Day
reduction = df."reduction (g)"
time_ts = time[1:5, :]
TS = df."TS (g)"[1:5, :]

red_plot = scatter(time, reduction, xlabel = "Time (days)", ylabel = "Reduction (g)",
                   title = "Mass reduction", xticks = time, markersize = 6)
plot!(time, reduction)
savefig(red_plot, plotsdir("4_12", "reduction_plot.png"))

ts_plot = scatter(time_ts, TS, xlabel = "Time (days)", ylabel = "TS (g)",
                  title = "Total dry solids", xticks = time_ts, markersize = 6)
plot!(time_ts, TS)
savefig(ts_plot, plotsdir("4_12", "ts_plot.png"))
