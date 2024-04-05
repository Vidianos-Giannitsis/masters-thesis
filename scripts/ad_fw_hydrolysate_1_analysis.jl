using DrWatson
@quickactivate "Masters_Thesis"

using Dates
using StatsBase
using CSV, DataFrames
using LsqFit
using Plots

### Data Analysis on Hydrolysate with 0 ml ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
"bandicam 2024-04-02 12-54-01-788.jpg", "bandicam 2024-04-02 13-24-01-783.jpg",
"bandicam 2024-04-02 13-54-01-797.jpg", "bandicam 2024-04-02 14-24-01-798.jpg",
"bandicam 2024-04-02 14-54-01-793.jpg", "bandicam 2024-04-02 15-24-01-786.jpg",
"bandicam 2024-04-02 15-54-01-785.jpg", "bandicam 2024-04-02 16-24-01-800.jpg",
"bandicam 2024-04-02 16-54-01-801.jpg", "bandicam 2024-04-02 17-24-01-784.jpg",
"bandicam 2024-04-02 17-54-02-191.jpg", "bandicam 2024-04-02 19-54-02-222.jpg",
"bandicam 2024-04-02 21-54-02-318.jpg", "bandicam 2024-04-02 23-54-02-573.jpg",
"bandicam 2024-04-03 01-54-02-576.jpg", "bandicam 2024-04-03 03-54-02-564.jpg",
"bandicam 2024-04-03 05-54-02-863.jpg", "bandicam 2024-04-03 07-54-02-978.jpg",
"bandicam 2024-04-03 09-54-02-983.jpg", "bandicam 2024-04-03 12-54-03-516.jpg",
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg"
]

inds = 1:34
exp_meth_vol = [0, 1.0, 0.2, 0.02, 0.02, 0.01, 0.2, 0.2, 0.5, 0.2, 0.5, 1.5, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0.05]

exp_name = "hydrolysate_0"
source = "Hydrolyzed FW"
sample = "Sample 0"
input_cod = 0.1


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)

if source == "Hydrolyzed FW"
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


# The same model is fit either with min or hour
p0 = [50.0, 0.4, 1.0]

gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_cod

fit = curve_fit(gompertz, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz(t) = gompertz(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = true
timescale = "min"
model_hydro_0_min = vcat(sample, model_params, r_squared)

if source == "Hydrolyzed FW"
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
else
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
end


p0 = [40.0, 1.0, 1.0]

gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_cod

fit = curve_fit(gompertz, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz(t) = gompertz(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = true
timescale = "hour"
model_hydro_0_hour = vcat(sample, model_params, r_squared)

if source == "Hydrolyzed FW"
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
else
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
end


### Data Analysis on Hydrolysate with 1 ml ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
"bandicam 2024-04-02 12-54-01-788.jpg", "bandicam 2024-04-02 13-24-01-783.jpg",
"bandicam 2024-04-02 13-54-01-797.jpg", "bandicam 2024-04-02 14-24-01-798.jpg",
"bandicam 2024-04-02 14-54-01-793.jpg", "bandicam 2024-04-02 15-24-01-786.jpg",
"bandicam 2024-04-02 15-54-01-785.jpg", "bandicam 2024-04-02 16-24-01-800.jpg",
"bandicam 2024-04-02 16-54-01-801.jpg", "bandicam 2024-04-02 17-24-01-784.jpg",
"bandicam 2024-04-02 17-54-02-191.jpg", "bandicam 2024-04-02 19-54-02-222.jpg",
"bandicam 2024-04-02 21-54-02-318.jpg", "bandicam 2024-04-02 23-54-02-573.jpg",
"bandicam 2024-04-03 01-54-02-576.jpg", "bandicam 2024-04-03 03-54-02-564.jpg",
"bandicam 2024-04-03 05-54-02-863.jpg", "bandicam 2024-04-03 07-54-02-978.jpg",
"bandicam 2024-04-03 09-54-02-983.jpg", "bandicam 2024-04-03 12-54-03-516.jpg",
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg"
]

inds = 2:34
exp_meth_vol = [0, 2.0, 0.5, 0.5, 0.5, 0.5, 0.5, 0, 0.2, 0.5, 2.0, 0.3, 0.3, 0.3, 0.1, 0.6, 0.6, 0.5, 0.5, 0.5, 0.4, 0.6, 0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.3, 0.2, 0.2]
exp_name = "hydrolysate_1"
source = "Hydrolyzed FW"
sample = "Sample 1"
input_cod = 0.1

p0 = [130.0, 10.0, 1.0]

date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)

if source == "Hydrolyzed FW"
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_cod

fit = curve_fit(gompertz, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz(t) = gompertz(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = true
timescale = "min"
model_hydro_1_min = vcat(sample, model_params, r_squared)

if source == "Hydrolyzed FW"
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
else
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
end


p0 = [200.0, 5.0, 1.0]

gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_cod

fit = curve_fit(gompertz, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz(t) = gompertz(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = true
timescale = "hour"
model_hydro_1_hour = vcat(sample, model_params, r_squared)

if source == "Hydrolyzed FW"
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
else
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
end


### Data Analysis on Hydrolysate with 2 ml ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
"bandicam 2024-04-02 12-54-01-788.jpg", "bandicam 2024-04-02 13-24-01-783.jpg",
"bandicam 2024-04-02 13-54-01-797.jpg", "bandicam 2024-04-02 14-24-01-798.jpg",
"bandicam 2024-04-02 14-54-01-793.jpg", "bandicam 2024-04-02 15-24-01-786.jpg",
"bandicam 2024-04-02 15-54-01-785.jpg", "bandicam 2024-04-02 16-24-01-800.jpg",
"bandicam 2024-04-02 16-54-01-801.jpg", "bandicam 2024-04-02 17-24-01-784.jpg",
"bandicam 2024-04-02 17-54-02-191.jpg", "bandicam 2024-04-02 19-54-02-222.jpg",
"bandicam 2024-04-02 21-54-02-318.jpg", "bandicam 2024-04-02 23-54-02-573.jpg",
"bandicam 2024-04-03 01-54-02-576.jpg", "bandicam 2024-04-03 03-54-02-564.jpg",
"bandicam 2024-04-03 05-54-02-863.jpg", "bandicam 2024-04-03 07-54-02-978.jpg",
"bandicam 2024-04-03 09-54-02-983.jpg", "bandicam 2024-04-03 12-54-03-516.jpg",
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg"
]

inds = 7:34
exp_meth_vol = [0, 6, 0.5, 0.1, 0.5, 1.5, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.2]
exp_name = "hydrolysate_2"
source = "Hydrolyzed FW"
sample = "Sample 2"
input_cod = 0.1


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)

if source == "Hydrolyzed FW"
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


p0 = [100.0, 0.01, 1.0]

gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_cod

fit = curve_fit(gompertz, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz(t) = gompertz(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = true
timescale = "min"
model_hydro_2_min = vcat(sample, model_params, r_squared)

if source == "Hydrolyzed FW"
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
else
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
end


p0 = [100.0, 1000.0, 0.03]

gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_cod

fit = curve_fit(gompertz, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz(t) = gompertz(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = true
timescale = "hour"
model_hydro_2_hour = vcat(sample, model_params, r_squared)

if source == "Hydrolyzed FW"
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
else
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
end


### Data Analysis on Hydrolysate with 4 ml ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
"bandicam 2024-04-02 12-54-01-788.jpg", "bandicam 2024-04-02 13-24-01-783.jpg",
"bandicam 2024-04-02 13-54-01-797.jpg", "bandicam 2024-04-02 14-24-01-798.jpg",
"bandicam 2024-04-02 14-54-01-793.jpg", "bandicam 2024-04-02 15-24-01-786.jpg",
"bandicam 2024-04-02 15-54-01-785.jpg", "bandicam 2024-04-02 16-24-01-800.jpg",
"bandicam 2024-04-02 16-54-01-801.jpg", "bandicam 2024-04-02 17-24-01-784.jpg",
"bandicam 2024-04-02 17-54-02-191.jpg", "bandicam 2024-04-02 19-54-02-222.jpg",
"bandicam 2024-04-02 21-54-02-318.jpg", "bandicam 2024-04-02 23-54-02-573.jpg",
"bandicam 2024-04-03 01-54-02-576.jpg", "bandicam 2024-04-03 03-54-02-564.jpg",
"bandicam 2024-04-03 05-54-02-863.jpg", "bandicam 2024-04-03 07-54-02-978.jpg",
"bandicam 2024-04-03 09-54-02-983.jpg", "bandicam 2024-04-03 12-54-03-516.jpg",
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg"
]

inds = 5:34
exp_meth_vol = [0, 13, 0.1, 0.2, 0.1, 0.2, 0.5, 1, 0.4, 0.1, 0.3, 0.1, 0.1, 0.1, 0.0, 0.0, 0.0, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.2, 0.2, 0.2, 0.1]
exp_name = "hydrolysate_4"
source = "Hydrolyzed FW"
sample = "Sample 4"
input_cod = 0.1


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:length(inds)]; digits = 4)
exp_min = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:length(inds)]; digits = 4)
exp_hour = round.([(exp_stamps[i] - exp_stamps[1])/Millisecond(3600000) for i in 1:length(inds)]; digits = 4)
exp_cum_meth_vol = round.(cumsum(exp_meth_vol); digits = 3)

if source == "Hydrolyzed FW"
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
end

CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


p0 = [170.0, 150.0, 1.0]

gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_cod

fit = curve_fit(gompertz, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz(t) = gompertz(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = true
timescale = "min"
model_hydro_4_min = vcat(sample, model_params, r_squared)

if source == "Hydrolyzed FW"
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
else
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
end


p0 = [170.0, 1000.0, 0.1]

gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_cod

fit = curve_fit(gompertz, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz(t) = gompertz(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = true
timescale = "hour"
model_hydro_4_hour = vcat(sample, model_params, r_squared)

if source == "Hydrolyzed FW"
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
else
    bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
	plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
end


model_fit_table_min = Tables.table(vcat(reshape(model_hydro_0_min, 1, 5), reshape(model_hydro_1_min, 1, 5), reshape(model_hydro_2_min, 1, 5), reshape(model_hydro_4_min, 1, 5)), header = [:Sample_Name, :Methane_Production_Potential, :Methane_Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_min.csv"), model_fit_table_min)

model_fit_table_hour = Tables.table(vcat(reshape(model_hydro_0_hour, 1, 5), reshape(model_hydro_1_hour, 1, 5), reshape(model_hydro_2_hour, 1, 5), reshape(model_hydro_4_hour, 1, 5)), header = [:Sample_Name, :Methane_Production_Potential, :Methane_Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_hour.csv"), model_fit_table_hour)
