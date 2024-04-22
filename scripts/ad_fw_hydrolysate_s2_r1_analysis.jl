using DrWatson
@quickactivate "Masters_Thesis"

using Dates
using StatsBase
using CSV, DataFrames
using LsqFit
using Plots

### Data Analysis on Hydrolysate with 0 ml ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = vcat(14:66, 93:160)
exp_meth_vol = [0, 0, 1, 1, 1, 1, 0.5, 1.5, 0.5, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1, 1.5, 1, 1.5, 1.5, 1, 1, 2, 1.5, 1.5, 1, 1, 1.5, 1, 1, 1, 1.5, 1, 1.5, 1, 1, 1.5, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.8, 0.5, 0.3, 0.5, 1.5, 1.5, 1, 1, 1, 0.5, 1, 1.5, 1, 1, 1, 1, 0.5, 1, 0.5, 0.5, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0]
meth_vol_hydro_0 = cumsum(exp_meth_vol)[end]

exp_name = "hydrolysate_0_s2_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 0"
sludge = "Sludge 2"
run_num = "Run 1"
input_vs = 4.2


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_0 = max_manual_rate

# The same model is fit either with min or hour
p0 = [6.0, 0.01, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_0_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [6.0, 0.2, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_0_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [6.0, 10.0, 1.0]

gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_0 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 1 ml ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = vcat(6:66, 93:150)
exp_meth_vol = [0, 0.2, 0.7, 0, 0, 0, 0, 0, 0.2, 0.6, 2, 2, 2, 2, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 2, 1, 2, 2, 2, 1.5, 2, 1.5, 1, 1.5, 2, 2, 2, 1.5, 2, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 0.5, 0.5, 1, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1, 1, 1.5, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0.5, 0.3, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.3, 0.3, 0.3, 0.3, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_1 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_1_s2_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 1"
sludge = "Sludge 2"
run_num = "Run 1"
input_vs = 4.2

p0 = [13.0, 0.1, 1.0]

date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_1 = max_manual_rate


gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_1_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [13.0, 1.0, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_1_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_1 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 2 ml ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = 66:197
exp_meth_vol = [0, 0.1, 0, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0, 0.1, 0.1, 0, 0.05, 0, 0.05, 0.1, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1, 1.5, 1.5, 1, 1.5, 1.5, 1, 1, 1.5, 1, 1.5, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1.5, 2, 2, 2, 2, 2, 2, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1.5, 1, 1, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0.3, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_2 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_2_s2_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 2"
sludge = "Sludge 2"
run_num = "Run 1"
input_vs = 4.2


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_2 = max_manual_rate

p0 = [3.50, 1.0, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_2_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [3.50, 10.0, 0.03]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_2_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_2 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 4 ml ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = vcat(10:66, 93:156)
exp_meth_vol = [0, 1.5, 0.5, 0, 0, 1.5, 1, 1.5, 1, 1, 1, 1, 0.5, 1, 1, 0.7, 1, 1, 0.5, 1, 1, 0.4, 1, 0.5, 0.5, 1.5, 1, 1, 1, 1, 1, 1.5, 1, 1, 1, 0.5, 1, 0.5, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1.5, 0.5, 2, 1.5, 1, 0.5, 0, 0, 0, 0.5, 1, 1, 0.75, 0.75, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 1, 0.5, 1, 1, 0.5, 1, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.1, 0.1, 0, 0.1, 0.1, 0.2, 0.1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0, 0, 0, 0, 0]
meth_vol_hydro_4 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_4_s2_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 4"
sludge = "Sludge 2"
run_num = "Run 1"

input_vs = 4.2


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_4 = max_manual_rate

p0 = [17.0, 0.01, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_4_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [17.0, 0.8, 0.1]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_4_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_4 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Untreated FW ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = vcat(1:66, 93:140)
exp_meth_vol = vcat([0, 0.2, 0, 0, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0.3, 0.2, 0.2, 0.2], zeros(70))
meth_vol_hydro_fw = cumsum(exp_meth_vol)[end]
exp_name = "untreated_fw_s2_r1"
source = "Untreated FW"
reactor = "FW 1"
sludge = "Sludge 2"
run_num = "Run 1"

input_vs = 4.2


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_fw = max_manual_rate

p0 = [2.0, 0.001, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_fw_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [2.0, 0.1, 0.1]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_fw_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_fw = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

model_fit_table_min = Tables.table(vcat(reshape(model_hydro_0_min, 1, 5), reshape(model_hydro_1_min, 1, 5), reshape(model_hydro_2_min, 1, 5), reshape(model_hydro_4_min, 1, 5), reshape(model_hydro_fw_min, 1, 5)), header = [:Reactor_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_min_s2_r1.csv"), model_fit_table_min)

model_fit_table_hour = Tables.table(vcat(reshape(model_hydro_0_hour, 1, 5), reshape(model_hydro_1_hour, 1, 5), reshape(model_hydro_2_hour, 1, 5), reshape(model_hydro_4_hour, 1, 5), reshape(model_hydro_fw_hour, 1, 5)), header = [:Reactor_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_hour_s2_r1.csv"), model_fit_table_hour)
return("../data/exp_pro/methane_from_hydrolysate_kinetics_min_s2_r1.csv")

### Data Analysis on Hydrolysate with 0 ml ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = vcat(14:66, 93:160)
exp_meth_vol = [0, 0, 1, 1, 1, 1, 0.5, 1.5, 0.5, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1, 1.5, 1, 1.5, 1.5, 1, 1, 2, 1.5, 1.5, 1, 1, 1.5, 1, 1, 1, 1.5, 1, 1.5, 1, 1, 1.5, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.8, 0.5, 0.3, 0.5, 1.5, 1.5, 1, 1, 1, 0.5, 1, 1.5, 1, 1, 1, 1, 0.5, 1, 0.5, 0.5, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0]
meth_vol_hydro_0 = cumsum(exp_meth_vol)[end]

exp_name = "hydrolysate_0_s2_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 0"
sludge = "Sludge 2"
run_num = "Run 1"
input_vs = 4.2


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_0 = max_manual_rate

# The same model is fit either with min or hour
p0 = [6.0, 0.01, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_0_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [6.0, 0.2, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_0_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [6.0, 10.0, 1.0]

gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_0 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 1 ml ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = vcat(6:66, 93:150)
exp_meth_vol = [0, 0.2, 0.7, 0, 0, 0, 0, 0, 0.2, 0.6, 2, 2, 2, 2, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 2, 1, 2, 2, 2, 1.5, 2, 1.5, 1, 1.5, 2, 2, 2, 1.5, 2, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 0.5, 0.5, 1, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1, 1, 1.5, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0.5, 0.3, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.3, 0.3, 0.3, 0.3, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_1 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_1_s2_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 1"
sludge = "Sludge 2"
run_num = "Run 1"
input_vs = 4.2

p0 = [13.0, 0.1, 1.0]

date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_1 = max_manual_rate


gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_1_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [13.0, 1.0, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_1_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_1 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 2 ml ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = 66:197
exp_meth_vol = [0, 0.1, 0, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0, 0.1, 0.1, 0, 0.05, 0, 0.05, 0.1, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1, 1.5, 1.5, 1, 1.5, 1.5, 1, 1, 1.5, 1, 1.5, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1.5, 2, 2, 2, 2, 2, 2, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1.5, 1, 1, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0.3, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_2 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_2_s2_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 2"
sludge = "Sludge 2"
run_num = "Run 1"
input_vs = 4.2


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_2 = max_manual_rate

p0 = [3.50, 1.0, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_2_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [3.50, 10.0, 0.03]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_2_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_2 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 4 ml ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = vcat(10:66, 93:156)
exp_meth_vol = [0, 1.5, 0.5, 0, 0, 1.5, 1, 1.5, 1, 1, 1, 1, 0.5, 1, 1, 0.7, 1, 1, 0.5, 1, 1, 0.4, 1, 0.5, 0.5, 1.5, 1, 1, 1, 1, 1, 1.5, 1, 1, 1, 0.5, 1, 0.5, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1.5, 0.5, 2, 1.5, 1, 0.5, 0, 0, 0, 0.5, 1, 1, 0.75, 0.75, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 1, 0.5, 1, 1, 0.5, 1, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.1, 0.1, 0, 0.1, 0.1, 0.2, 0.1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0, 0, 0, 0, 0]
meth_vol_hydro_4 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_4_s2_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 4"
sludge = "Sludge 2"
run_num = "Run 1"

input_vs = 4.2


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_4 = max_manual_rate

p0 = [17.0, 0.01, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_4_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [17.0, 0.8, 0.1]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_4_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_4 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Untreated FW ###


file_vec = ["bandicam 2024-04-15 12-02-11-665.jpg", "bandicam 2024-04-15 12-04-11-664.jpg",
"bandicam 2024-04-15 12-06-09-897.jpg", "bandicam 2024-04-15 12-07-09-919.jpg",
"bandicam 2024-04-15 12-08-09-906.jpg", "bandicam 2024-04-15 12-11-09-909.jpg",
"bandicam 2024-04-15 12-11-28-595.jpg", "bandicam 2024-04-15 12-12-28-586.jpg",
"bandicam 2024-04-15 12-13-28-584.jpg", "bandicam 2024-04-15 12-16-17-597.jpg",
"bandicam 2024-04-15 12-18-17-621.jpg", "bandicam 2024-04-15 12-19-17-631.jpg",
"bandicam 2024-04-15 12-20-58-735.jpg", "bandicam 2024-04-15 12-21-58-739.jpg",
"bandicam 2024-04-15 12-29-18-857.jpg", "bandicam 2024-04-15 13-29-18-859.jpg",
"bandicam 2024-04-15 14-29-18-861.jpg", "bandicam 2024-04-15 15-29-18-874.jpg",
"bandicam 2024-04-15 16-29-18-867.jpg", "bandicam 2024-04-15 17-29-19-944.jpg",
"bandicam 2024-04-15 18-29-20-115.jpg", "bandicam 2024-04-15 19-29-20-359.jpg",
"bandicam 2024-04-15 20-29-20-204.jpg", "bandicam 2024-04-15 21-29-20-212.jpg",
"bandicam 2024-04-15 22-29-20-206.jpg", "bandicam 2024-04-15 23-29-19-728.jpg",
"bandicam 2024-04-16 00-29-19-719.jpg", "bandicam 2024-04-16 01-29-19-733.jpg",
"bandicam 2024-04-16 02-29-19-819.jpg", "bandicam 2024-04-16 03-29-19-916.jpg",
"bandicam 2024-04-16 04-29-19-934.jpg", "bandicam 2024-04-16 05-29-19-944.jpg",
"bandicam 2024-04-16 06-29-19-940.jpg", "bandicam 2024-04-16 07-29-19-944.jpg",
"bandicam 2024-04-16 08-29-19-956.jpg", "bandicam 2024-04-16 09-29-19-947.jpg",
"bandicam 2024-04-16 10-26-42-895.jpg", "bandicam 2024-04-16 11-26-43-205.jpg",
"bandicam 2024-04-16 12-26-43-569.jpg", "bandicam 2024-04-16 13-26-43-549.jpg",
"bandicam 2024-04-16 14-26-43-562.jpg", "bandicam 2024-04-16 15-26-43-554.jpg",
"bandicam 2024-04-16 16-26-43-556.jpg", "bandicam 2024-04-16 17-26-43-559.jpg",
"bandicam 2024-04-16 18-26-43-922.jpg", "bandicam 2024-04-16 19-26-43-902.jpg",
"bandicam 2024-04-16 20-26-43-931.jpg", "bandicam 2024-04-16 21-26-44-059.jpg",
"bandicam 2024-04-16 22-26-44-099.jpg", "bandicam 2024-04-16 23-26-44-848.jpg",
"bandicam 2024-04-17 00-26-44-841.jpg", "bandicam 2024-04-17 01-26-44-856.jpg",
"bandicam 2024-04-17 02-26-44-847.jpg", "bandicam 2024-04-17 03-26-44-849.jpg",
"bandicam 2024-04-17 04-26-44-852.jpg", "bandicam 2024-04-17 05-26-44-794.jpg",
"bandicam 2024-04-17 06-26-44-722.jpg", "bandicam 2024-04-17 07-26-44-688.jpg",
"bandicam 2024-04-17 08-26-44-694.jpg", "bandicam 2024-04-17 09-26-44-680.jpg",
"bandicam 2024-04-17 10-29-35-074.jpg", "bandicam 2024-04-17 11-29-35-078.jpg",
"bandicam 2024-04-17 12-29-36-339.jpg", "bandicam 2024-04-17 13-29-36-317.jpg",
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-42-00-758.jpg",
"bandicam 2024-04-17 14-46-00-718.jpg", "bandicam 2024-04-17 14-47-00-711.jpg",
"bandicam 2024-04-17 14-48-00-703.jpg", "bandicam 2024-04-17 14-49-00-710.jpg",
"bandicam 2024-04-17 14-50-00-719.jpg", "bandicam 2024-04-17 14-51-00-725.jpg",
"bandicam 2024-04-17 14-52-00-706.jpg", "bandicam 2024-04-17 14-53-00-719.jpg",
"bandicam 2024-04-17 14-54-00-714.jpg", "bandicam 2024-04-17 14-55-00-713.jpg",
"bandicam 2024-04-17 14-56-00-708.jpg", "bandicam 2024-04-17 14-57-00-700.jpg",
"bandicam 2024-04-17 14-58-00-697.jpg", "bandicam 2024-04-17 14-58-12-799.jpg",
"bandicam 2024-04-17 14-59-49-931.jpg", "bandicam 2024-04-17 15-00-49-924.jpg",
"bandicam 2024-04-17 15-01-49-917.jpg", "bandicam 2024-04-17 15-02-49-912.jpg",
"bandicam 2024-04-17 15-03-49-912.jpg", "bandicam 2024-04-17 15-04-49-895.jpg",
"bandicam 2024-04-17 15-05-49-891.jpg", "bandicam 2024-04-17 15-06-49-886.jpg",
"bandicam 2024-04-17 15-07-49-897.jpg", "bandicam 2024-04-17 15-08-49-883.jpg",
"bandicam 2024-04-17 15-09-49-877.jpg", "bandicam 2024-04-17 15-10-49-870.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg", "bandicam 2024-04-17 16-18-50-600.jpg",
"bandicam 2024-04-17 17-18-50-528.jpg", "bandicam 2024-04-17 18-18-50-857.jpg",
"bandicam 2024-04-17 19-18-50-855.jpg", "bandicam 2024-04-17 20-18-50-849.jpg",
"bandicam 2024-04-17 21-18-50-850.jpg", "bandicam 2024-04-17 22-18-50-842.jpg",
"bandicam 2024-04-17 23-18-50-845.jpg", "bandicam 2024-04-18 00-18-51-075.jpg",
"bandicam 2024-04-18 01-18-51-194.jpg", "bandicam 2024-04-18 02-18-51-218.jpg",
"bandicam 2024-04-18 03-18-51-246.jpg", "bandicam 2024-04-18 04-18-51-247.jpg",
"bandicam 2024-04-18 05-18-51-242.jpg", "bandicam 2024-04-18 06-18-51-245.jpg",
"bandicam 2024-04-18 07-18-51-252.jpg", "bandicam 2024-04-18 08-18-51-245.jpg",
"bandicam 2024-04-18 09-18-51-684.jpg", "bandicam 2024-04-18 10-18-51-867.jpg",
"bandicam 2024-04-18 11-18-51-950.jpg", "bandicam 2024-04-18 12-18-51-999.jpg",
"bandicam 2024-04-18 13-18-52-029.jpg", "bandicam 2024-04-18 14-18-52-067.jpg",
"bandicam 2024-04-18 15-18-52-113.jpg", "bandicam 2024-04-18 16-18-52-129.jpg",
"bandicam 2024-04-18 17-18-52-175.jpg", "bandicam 2024-04-18 18-18-52-388.jpg",
"bandicam 2024-04-18 19-18-52-504.jpg", "bandicam 2024-04-18 20-18-52-569.jpg",
"bandicam 2024-04-18 21-18-52-612.jpg", "bandicam 2024-04-18 22-18-52-664.jpg",
"bandicam 2024-04-18 23-18-52-821.jpg", "bandicam 2024-04-19 00-18-52-826.jpg",
"bandicam 2024-04-19 01-18-52-819.jpg", "bandicam 2024-04-19 02-18-52-832.jpg",
"bandicam 2024-04-19 03-18-52-926.jpg", "bandicam 2024-04-19 04-18-53-034.jpg",
"bandicam 2024-04-19 05-18-53-073.jpg", "bandicam 2024-04-19 06-18-53-097.jpg",
"bandicam 2024-04-19 07-18-53-092.jpg", "bandicam 2024-04-19 08-18-53-084.jpg",
"bandicam 2024-04-19 09-18-53-085.jpg", "bandicam 2024-04-19 10-18-53-088.jpg",
"bandicam 2024-04-19 11-05-06-054.jpg", "bandicam 2024-04-19 11-50-44-770.jpg",
"bandicam 2024-04-19 12-50-45-166.jpg", "bandicam 2024-04-19 13-50-45-308.jpg",
"bandicam 2024-04-19 14-50-45-378.jpg", "bandicam 2024-04-19 15-50-45-434.jpg",
"bandicam 2024-04-19 16-50-45-463.jpg", "bandicam 2024-04-19 17-50-45-488.jpg",
"bandicam 2024-04-19 18-50-45-535.jpg", "bandicam 2024-04-19 19-50-45-563.jpg",
"bandicam 2024-04-19 20-50-45-590.jpg", "bandicam 2024-04-19 21-50-45-855.jpg",
"bandicam 2024-04-19 22-50-45-935.jpg", "bandicam 2024-04-19 23-50-46-027.jpg",
"bandicam 2024-04-20 00-50-46-019.jpg", "bandicam 2024-04-20 01-50-46-032.jpg",
"bandicam 2024-04-20 02-50-46-031.jpg", "bandicam 2024-04-20 03-50-46-047.jpg",
"bandicam 2024-04-20 04-50-46-021.jpg", "bandicam 2024-04-20 05-50-46-035.jpg",
"bandicam 2024-04-20 06-50-46-215.jpg", "bandicam 2024-04-20 07-50-46-333.jpg",
"bandicam 2024-04-20 08-50-46-360.jpg", "bandicam 2024-04-20 09-50-46-383.jpg",
"bandicam 2024-04-20 10-50-46-384.jpg", "bandicam 2024-04-20 11-50-46-386.jpg",
"bandicam 2024-04-20 12-50-46-388.jpg", "bandicam 2024-04-20 13-50-46-391.jpg",
"bandicam 2024-04-20 14-50-46-393.jpg", "bandicam 2024-04-20 15-50-46-883.jpg",
"bandicam 2024-04-20 16-50-47-119.jpg", "bandicam 2024-04-20 17-50-47-219.jpg",
"bandicam 2024-04-20 18-50-47-280.jpg", "bandicam 2024-04-20 19-50-47-318.jpg",
"bandicam 2024-04-20 20-50-47-350.jpg", "bandicam 2024-04-20 21-50-47-415.jpg",
"bandicam 2024-04-20 22-50-47-455.jpg", "bandicam 2024-04-20 23-50-47-493.jpg",
"bandicam 2024-04-21 00-50-47-684.jpg", "bandicam 2024-04-21 01-50-47-793.jpg",
"bandicam 2024-04-21 02-50-47-840.jpg", "bandicam 2024-04-21 03-50-47-891.jpg",
"bandicam 2024-04-21 04-50-47-912.jpg", "bandicam 2024-04-21 05-50-47-950.jpg",
"bandicam 2024-04-21 06-50-47-985.jpg", "bandicam 2024-04-21 07-50-48-014.jpg",
"bandicam 2024-04-21 08-50-48-049.jpg", "bandicam 2024-04-21 09-50-48-257.jpg",
"bandicam 2024-04-21 10-50-48-390.jpg", "bandicam 2024-04-21 11-50-48-438.jpg",
"bandicam 2024-04-21 12-50-48-525.jpg", "bandicam 2024-04-21 13-50-48-519.jpg",
"bandicam 2024-04-21 14-50-48-522.jpg", "bandicam 2024-04-21 15-50-48-518.jpg",
"bandicam 2024-04-21 16-50-48-539.jpg", "bandicam 2024-04-21 17-50-48-554.jpg",
"bandicam 2024-04-21 18-50-48-689.jpg", "bandicam 2024-04-21 19-50-48-905.jpg",
"bandicam 2024-04-21 20-50-48-977.jpg", "bandicam 2024-04-21 21-50-49-009.jpg",
"bandicam 2024-04-21 22-50-49-023.jpg"
]

inds = vcat(1:66, 93:140)
exp_meth_vol = vcat([0, 0.2, 0, 0, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0.3, 0.2, 0.2, 0.2], zeros(70))
meth_vol_hydro_fw = cumsum(exp_meth_vol)[end]
exp_name = "untreated_fw_s2_r1"
source = "Untreated FW"
reactor = "FW 1"
sludge = "Sludge 2"
run_num = "Run 1"

input_vs = 4.2


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)
max_manual_rate = maximum([(exp_cum_meth_vol[i+1] - exp_cum_meth_vol[i])/(exp_hour[i+1] - exp_hour[i]) for i in 1:(length(inds)-1)])

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)

max_rate_hydro_fw = max_manual_rate

p0 = [2.0, 0.001, 1.0]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_min, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "min"
model_hydro_fw_min = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [2.0, 0.1, 0.1]

gompertz_bmp(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]

fit = curve_fit(gompertz_bmp, exp_hour, exp_cum_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_bmp(t) = gompertz_bmp(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(exp_cum_meth_vol[i] - mean(exp_cum_meth_vol)).^2 for i in 1:length(exp_cum_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "bmp"
timescale = "hour"
model_hydro_fw_hour = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
sma_hydro_fw = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

sma_table = Tables.table(vcat(reshape(sma_hydro_0, 1, 5), reshape(sma_hydro_1, 1, 5), reshape(sma_hydro_2, 1, 5), reshape(sma_hydro_4, 1, 5), reshape(sma_hydro_fw, 1, 5)), header = [:Reactor_Name, :Methane_Potential, :SMA, :Lag_Time, :R_sq])
CSV.write(datadir("exp_pro", "sma_from_hydrolysate_s2_r1.csv"), sma_table)

return("../data/exp_pro/sma_from_hydrolysate_s2_r1.csv")
