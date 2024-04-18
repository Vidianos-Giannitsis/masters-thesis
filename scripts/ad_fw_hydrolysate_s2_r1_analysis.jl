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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 14:67
exp_meth_vol = [0, 0, 1, 1, 1, 1, 0.5, 1.5, 0.5, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1, 1.5, 1, 1.5, 1.5, 1, 1, 2, 1.5, 1.5, 1, 1, 1.5, 1, 1, 1, 1.5, 1, 1.5, 1, 1, 1.5, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.8, 0.5, 0.3, 0.5]
meth_vol_hydro_0 = cumsum(exp_meth_vol)[end]

exp_name = "hydrolysate_0_s2_r1"
source = "Hydrolyzed FW"
sample = "Sample 0"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_0_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_0_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_0 = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 6:67
exp_meth_vol = [0, 0.2, 0.7, 0, 0, 0, 0, 0, 0.2, 0.6, 2, 2, 2, 2, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 2, 1, 2, 2, 2, 1.5, 2, 1.5, 1, 1.5, 2, 2, 2, 1.5, 2, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 0.5, 0.5]
meth_vol_hydro_1 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_1_s2_r1"
source = "Hydrolyzed FW"
sample = "Sample 1"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_1_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_1_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_1 = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 3:20
exp_meth_vol = [0, 1, 0.5, 0.5, 0, 0.1, 0.1, 0.3, 0.05, 0.05, 0.1, 0.5, 1, 0, 0, 0, 0, 0]
meth_vol_hydro_2 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_2_s2_r1"
source = "Hydrolyzed FW"
sample = "Sample 2"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_2_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_2_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_2 = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 10:67
exp_meth_vol = [0, 1.5, 0.5, 0, 0, 1.5, 1, 1.5, 1, 1, 1, 1, 0.5, 1, 1, 0.7, 1, 1, 0.5, 1, 1, 0.4, 1, 0.5, 0.5, 1.5, 1, 1, 1, 1, 1, 1.5, 1, 1, 1, 0.5, 1, 0.5, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1.5, 0.5, 2, 1.5, 1, 0.5, 0, 0, 0, 0.5, 1]
meth_vol_hydro_4 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_4_s2_r1"
source = "Hydrolyzed FW"
sample = "Sample 4"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_4_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_4_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_4 = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 1:23
exp_meth_vol = [0, 0.2, 0, 0, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 1.5, 1, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_fw = cumsum(exp_meth_vol)[end]
exp_name = "untreated_fw_s2_r1"
source = "Untreated FW"
sample = "FW 1"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_fw_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_fw_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_fw = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

model_fit_table_min = Tables.table(vcat(reshape(model_hydro_0_min, 1, 5), reshape(model_hydro_1_min, 1, 5), reshape(model_hydro_2_min, 1, 5), reshape(model_hydro_4_min, 1, 5), reshape(model_hydro_fw_min, 1, 5)), header = [:Sample_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_min_s2_r1.csv"), model_fit_table_min)

model_fit_table_hour = Tables.table(vcat(reshape(model_hydro_0_hour, 1, 5), reshape(model_hydro_1_hour, 1, 5), reshape(model_hydro_2_hour, 1, 5), reshape(model_hydro_4_hour, 1, 5), reshape(model_hydro_fw_hour, 1, 5)), header = [:Sample_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 14:67
exp_meth_vol = [0, 0, 1, 1, 1, 1, 0.5, 1.5, 0.5, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1, 1.5, 1, 1.5, 1.5, 1, 1, 2, 1.5, 1.5, 1, 1, 1.5, 1, 1, 1, 1.5, 1, 1.5, 1, 1, 1.5, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.8, 0.5, 0.3, 0.5]
meth_vol_hydro_0 = cumsum(exp_meth_vol)[end]

exp_name = "hydrolysate_0_s2_r1"
source = "Hydrolyzed FW"
sample = "Sample 0"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_0_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_0_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_0 = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 6:67
exp_meth_vol = [0, 0.2, 0.7, 0, 0, 0, 0, 0, 0.2, 0.6, 2, 2, 2, 2, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 2, 1, 2, 2, 2, 1.5, 2, 1.5, 1, 1.5, 2, 2, 2, 1.5, 2, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 2, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 0.5, 0.5]
meth_vol_hydro_1 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_1_s2_r1"
source = "Hydrolyzed FW"
sample = "Sample 1"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_1_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_1_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_1 = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 3:20
exp_meth_vol = [0, 1, 0.5, 0.5, 0, 0.1, 0.1, 0.3, 0.05, 0.05, 0.1, 0.5, 1, 0, 0, 0, 0, 0]
meth_vol_hydro_2 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_2_s2_r1"
source = "Hydrolyzed FW"
sample = "Sample 2"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_2_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_2_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_2 = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 10:67
exp_meth_vol = [0, 1.5, 0.5, 0, 0, 1.5, 1, 1.5, 1, 1, 1, 1, 0.5, 1, 1, 0.7, 1, 1, 0.5, 1, 1, 0.4, 1, 0.5, 0.5, 1.5, 1, 1, 1, 1, 1, 1.5, 1, 1, 1, 0.5, 1, 0.5, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1.5, 0.5, 2, 1.5, 1, 0.5, 0, 0, 0, 0.5, 1]
meth_vol_hydro_4 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_4_s2_r1"
source = "Hydrolyzed FW"
sample = "Sample 4"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_4_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_4_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_4 = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
"bandicam 2024-04-17 13-57-20-002.jpg", "bandicam 2024-04-17 14-41-42-861.jpg",
"bandicam 2024-04-17 15-17-49-851.jpg"
]


inds = 1:23
exp_meth_vol = [0, 0.2, 0, 0, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 1.5, 1, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_fw = cumsum(exp_meth_vol)[end]
exp_name = "untreated_fw_s2_r1"
source = "Untreated FW"
sample = "FW 1"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


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
model_hydro_fw_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
model_hydro_fw_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
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
sma_hydro_fw = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

sma_table = Tables.table(vcat(reshape(sma_hydro_0, 1, 5), reshape(sma_hydro_1, 1, 5), reshape(sma_hydro_2, 1, 5), reshape(sma_hydro_4, 1, 5), reshape(sma_hydro_fw, 1, 5)), header = [:Sample_Name, :Methane_Potential, :SMA, :Lag_Time, :R_sq])
CSV.write(datadir("exp_pro", "sma_from_hydrolysate_s2_r1.csv"), sma_table)

return("../data/exp_pro/sma_from_hydrolysate_s2_r1.csv")
