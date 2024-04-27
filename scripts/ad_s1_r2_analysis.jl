using DrWatson
@quickactivate "Masters_Thesis"

using Dates
using StatsBase
using CSV, DataFrames
using LsqFit
using Plots
using LaTeXStrings

### Data Analysis on Reactor 0 ###


file_vec = ["bandicam 2024-03-27 18-45-55-857.jpg", "bandicam 2024-03-27 18-46-57-161.jpg",
"bandicam 2024-03-27 18-48-57-160.jpg", "bandicam 2024-03-27 18-50-57-170.jpg",
"bandicam 2024-03-27 18-52-57-164.jpg", "bandicam 2024-03-27 18-54-57-162.jpg",
"bandicam 2024-03-27 18-56-57-167.jpg", "bandicam 2024-03-27 18-58-57-165.jpg",
"bandicam 2024-03-27 19-00-57-170.jpg", "bandicam 2024-03-27 19-02-57-179.jpg",
"bandicam 2024-03-27 19-04-57-173.jpg", "bandicam 2024-03-27 19-06-57-182.jpg",
"bandicam 2024-03-27 19-08-57-185.jpg", "bandicam 2024-03-27 19-10-57-184.jpg",
"bandicam 2024-03-27 19-12-57-189.jpg", "bandicam 2024-03-27 19-14-57-187.jpg",
"bandicam 2024-03-27 19-15-06-279.jpg", "bandicam 2024-03-27 19-19-06-273.jpg",
"bandicam 2024-03-27 19-21-06-276.jpg", "bandicam 2024-03-27 19-23-06-285.jpg",
"bandicam 2024-03-27 19-25-06-290.jpg", "bandicam 2024-03-27 19-27-06-301.jpg",
"bandicam 2024-03-27 19-29-06-303.jpg", "bandicam 2024-03-27 19-31-06-301.jpg",
"bandicam 2024-03-27 19-33-06-297.jpg", "bandicam 2024-03-27 19-35-06-305.jpg",
"bandicam 2024-03-27 19-37-06-299.jpg", "bandicam 2024-03-27 19-39-06-297.jpg",
"bandicam 2024-03-27 19-41-06-307.jpg", "bandicam 2024-03-27 19-43-06-299.jpg",
"bandicam 2024-03-27 19-45-06-298.jpg", "bandicam 2024-03-27 19-47-06-304.jpg",
"bandicam 2024-03-27 19-48-50-591.jpg", "bandicam 2024-03-29 12-23-36-175.jpg",
"bandicam 2024-03-29 12-23-50-142.jpg", "bandicam 2024-03-29 12-24-50-161.jpg",
"bandicam 2024-03-29 12-25-50-156.jpg", "bandicam 2024-03-29 12-26-50-168.jpg",
"bandicam 2024-03-29 12-27-26-514.jpg", "bandicam 2024-03-29 12-28-26-502.jpg",
"bandicam 2024-03-29 12-29-26-497.jpg", "bandicam 2024-03-29 12-29-39-894.jpg",
"bandicam 2024-03-29 12-30-39-902.jpg", "bandicam 2024-03-29 12-31-39-897.jpg",
"bandicam 2024-03-29 12-32-05-844.jpg", "bandicam 2024-03-29 12-33-05-843.jpg",
"bandicam 2024-03-29 12-34-05-832.jpg", "bandicam 2024-03-29 12-35-05-836.jpg",
"bandicam 2024-03-29 12-36-05-835.jpg", "bandicam 2024-03-29 12-37-05-858.jpg",
"bandicam 2024-03-29 12-38-06-101.jpg", "bandicam 2024-03-29 12-38-47-045.jpg",
"bandicam 2024-03-29 12-39-47-039.jpg", "bandicam 2024-03-29 12-40-47-050.jpg",
"bandicam 2024-03-29 12-41-47-047.jpg", "bandicam 2024-03-29 12-42-47-057.jpg",
"bandicam 2024-03-29 12-43-42-169.jpg", "bandicam 2024-03-29 12-44-41-398.jpg"
]


inds = 34:58
exp_meth_vol = [0, 4, 12, 7.5, 4.5, 2.5, 2.5, 4, 0.5, 2, 2, 1, 1, 1, 1, 1, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0]
meth_vol_acet_0 = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_0_s1"
source = "Acetate"
reactor = "Reactor 0"
sludge = "Sludge 1"
run_num = "Run 1"
input_vs = 1.55
p0 = [40.0, 8.0, 1.0]


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

max_rate_acet_0 = max_manual_rate


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
model_acet_0 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [25.8, 5.0, 1.0]    

gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "min"
sma_acet_0 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Reactor 1 ###


file_vec = ["bandicam 2024-03-27 18-45-55-857.jpg", "bandicam 2024-03-27 18-46-57-161.jpg",
"bandicam 2024-03-27 18-48-57-160.jpg", "bandicam 2024-03-27 18-50-57-170.jpg",
"bandicam 2024-03-27 18-52-57-164.jpg", "bandicam 2024-03-27 18-54-57-162.jpg",
"bandicam 2024-03-27 18-56-57-167.jpg", "bandicam 2024-03-27 18-58-57-165.jpg",
"bandicam 2024-03-27 19-00-57-170.jpg", "bandicam 2024-03-27 19-02-57-179.jpg",
"bandicam 2024-03-27 19-04-57-173.jpg", "bandicam 2024-03-27 19-06-57-182.jpg",
"bandicam 2024-03-27 19-08-57-185.jpg", "bandicam 2024-03-27 19-10-57-184.jpg",
"bandicam 2024-03-27 19-12-57-189.jpg", "bandicam 2024-03-27 19-14-57-187.jpg",
"bandicam 2024-03-27 19-15-06-279.jpg", "bandicam 2024-03-27 19-19-06-273.jpg",
"bandicam 2024-03-27 19-21-06-276.jpg", "bandicam 2024-03-27 19-23-06-285.jpg",
"bandicam 2024-03-27 19-25-06-290.jpg", "bandicam 2024-03-27 19-27-06-301.jpg",
"bandicam 2024-03-27 19-29-06-303.jpg", "bandicam 2024-03-27 19-31-06-301.jpg",
"bandicam 2024-03-27 19-33-06-297.jpg", "bandicam 2024-03-27 19-35-06-305.jpg",
"bandicam 2024-03-27 19-37-06-299.jpg", "bandicam 2024-03-27 19-39-06-297.jpg",
"bandicam 2024-03-27 19-41-06-307.jpg", "bandicam 2024-03-27 19-43-06-299.jpg",
"bandicam 2024-03-27 19-45-06-298.jpg", "bandicam 2024-03-27 19-47-06-304.jpg",
"bandicam 2024-03-27 19-48-50-591.jpg", "bandicam 2024-03-29 12-23-36-175.jpg",
"bandicam 2024-03-29 12-23-50-142.jpg", "bandicam 2024-03-29 12-24-50-161.jpg",
"bandicam 2024-03-29 12-25-50-156.jpg", "bandicam 2024-03-29 12-26-50-168.jpg",
"bandicam 2024-03-29 12-27-26-514.jpg", "bandicam 2024-03-29 12-28-26-502.jpg",
"bandicam 2024-03-29 12-29-26-497.jpg", "bandicam 2024-03-29 12-29-39-894.jpg",
"bandicam 2024-03-29 12-30-39-902.jpg", "bandicam 2024-03-29 12-31-39-897.jpg",
"bandicam 2024-03-29 12-32-05-844.jpg", "bandicam 2024-03-29 12-33-05-843.jpg",
"bandicam 2024-03-29 12-34-05-832.jpg", "bandicam 2024-03-29 12-35-05-836.jpg",
"bandicam 2024-03-29 12-36-05-835.jpg", "bandicam 2024-03-29 12-37-05-858.jpg",
"bandicam 2024-03-29 12-38-06-101.jpg", "bandicam 2024-03-29 12-38-47-045.jpg",
"bandicam 2024-03-29 12-39-47-039.jpg", "bandicam 2024-03-29 12-40-47-050.jpg",
"bandicam 2024-03-29 12-41-47-047.jpg", "bandicam 2024-03-29 12-42-47-057.jpg",
"bandicam 2024-03-29 12-43-42-169.jpg", "bandicam 2024-03-29 12-44-41-398.jpg"
]


inds = 38:58
exp_meth_vol = [0, 6.5, 5, 3, 0.5, 1.5, 1.5, 0.5, 1, 0.5, 0.5, 0.3, 0.2, 0.2, 0.1, 0.05, 0.05, 0.05, 0.05, 0, 0]
meth_vol_acet_1 = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_1_s1"
source = "Acetate"
reactor = "Reactor 1"
sludge = "Sludge 1"
run_num = "Run 1"
input_vs = 1.55
p0 = [20.0, 4.0, 1.0]


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

max_rate_acet_1 = max_manual_rate


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
model_acet_1 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [13.5, 3.5, 1.0]

gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "min"
sma_acet_1 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Reactor 2 ###


file_vec = ["bandicam 2024-03-27 18-45-55-857.jpg", "bandicam 2024-03-27 18-46-57-161.jpg",
"bandicam 2024-03-27 18-48-57-160.jpg", "bandicam 2024-03-27 18-50-57-170.jpg",
"bandicam 2024-03-27 18-52-57-164.jpg", "bandicam 2024-03-27 18-54-57-162.jpg",
"bandicam 2024-03-27 18-56-57-167.jpg", "bandicam 2024-03-27 18-58-57-165.jpg",
"bandicam 2024-03-27 19-00-57-170.jpg", "bandicam 2024-03-27 19-02-57-179.jpg",
"bandicam 2024-03-27 19-04-57-173.jpg", "bandicam 2024-03-27 19-06-57-182.jpg",
"bandicam 2024-03-27 19-08-57-185.jpg", "bandicam 2024-03-27 19-10-57-184.jpg",
"bandicam 2024-03-27 19-12-57-189.jpg", "bandicam 2024-03-27 19-14-57-187.jpg",
"bandicam 2024-03-27 19-15-06-279.jpg", "bandicam 2024-03-27 19-19-06-273.jpg",
"bandicam 2024-03-27 19-21-06-276.jpg", "bandicam 2024-03-27 19-23-06-285.jpg",
"bandicam 2024-03-27 19-25-06-290.jpg", "bandicam 2024-03-27 19-27-06-301.jpg",
"bandicam 2024-03-27 19-29-06-303.jpg", "bandicam 2024-03-27 19-31-06-301.jpg",
"bandicam 2024-03-27 19-33-06-297.jpg", "bandicam 2024-03-27 19-35-06-305.jpg",
"bandicam 2024-03-27 19-37-06-299.jpg", "bandicam 2024-03-27 19-39-06-297.jpg",
"bandicam 2024-03-27 19-41-06-307.jpg", "bandicam 2024-03-27 19-43-06-299.jpg",
"bandicam 2024-03-27 19-45-06-298.jpg", "bandicam 2024-03-27 19-47-06-304.jpg",
"bandicam 2024-03-27 19-48-50-591.jpg", "bandicam 2024-03-29 12-23-36-175.jpg",
"bandicam 2024-03-29 12-23-50-142.jpg", "bandicam 2024-03-29 12-24-50-161.jpg",
"bandicam 2024-03-29 12-25-50-156.jpg", "bandicam 2024-03-29 12-26-50-168.jpg",
"bandicam 2024-03-29 12-27-26-514.jpg", "bandicam 2024-03-29 12-28-26-502.jpg",
"bandicam 2024-03-29 12-29-26-497.jpg", "bandicam 2024-03-29 12-29-39-894.jpg",
"bandicam 2024-03-29 12-30-39-902.jpg", "bandicam 2024-03-29 12-31-39-897.jpg",
"bandicam 2024-03-29 12-32-05-844.jpg", "bandicam 2024-03-29 12-33-05-843.jpg",
"bandicam 2024-03-29 12-34-05-832.jpg", "bandicam 2024-03-29 12-35-05-836.jpg",
"bandicam 2024-03-29 12-36-05-835.jpg", "bandicam 2024-03-29 12-37-05-858.jpg",
"bandicam 2024-03-29 12-38-06-101.jpg", "bandicam 2024-03-29 12-38-47-045.jpg",
"bandicam 2024-03-29 12-39-47-039.jpg", "bandicam 2024-03-29 12-40-47-050.jpg",
"bandicam 2024-03-29 12-41-47-047.jpg", "bandicam 2024-03-29 12-42-47-057.jpg",
"bandicam 2024-03-29 12-43-42-169.jpg", "bandicam 2024-03-29 12-44-41-398.jpg"
]


inds = 44:58
exp_meth_vol = [0, 4, 7, 5.5, 4.5, 2.5, 2, 1, 1, 1, 0.5, 0.5, 0.45, 0.05, 0]
meth_vol_acet_2 = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_2_s1"
source = "Acetate"
reactor = "Reactor 2"
sludge = "Sludge 1"
run_num = "Run 1"
input_vs = 1.55
p0 = [30.0, 6.0, 1.0]


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

max_rate_acet_2 = max_manual_rate


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
model_acet_2 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "min"
sma_acet_2 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Reactor 4 ###


file_vec = ["bandicam 2024-03-27 18-45-55-857.jpg", "bandicam 2024-03-27 18-46-57-161.jpg",
"bandicam 2024-03-27 18-48-57-160.jpg", "bandicam 2024-03-27 18-50-57-170.jpg",
"bandicam 2024-03-27 18-52-57-164.jpg", "bandicam 2024-03-27 18-54-57-162.jpg",
"bandicam 2024-03-27 18-56-57-167.jpg", "bandicam 2024-03-27 18-58-57-165.jpg",
"bandicam 2024-03-27 19-00-57-170.jpg", "bandicam 2024-03-27 19-02-57-179.jpg",
"bandicam 2024-03-27 19-04-57-173.jpg", "bandicam 2024-03-27 19-06-57-182.jpg",
"bandicam 2024-03-27 19-08-57-185.jpg", "bandicam 2024-03-27 19-10-57-184.jpg",
"bandicam 2024-03-27 19-12-57-189.jpg", "bandicam 2024-03-27 19-14-57-187.jpg",
"bandicam 2024-03-27 19-15-06-279.jpg", "bandicam 2024-03-27 19-19-06-273.jpg",
"bandicam 2024-03-27 19-21-06-276.jpg", "bandicam 2024-03-27 19-23-06-285.jpg",
"bandicam 2024-03-27 19-25-06-290.jpg", "bandicam 2024-03-27 19-27-06-301.jpg",
"bandicam 2024-03-27 19-29-06-303.jpg", "bandicam 2024-03-27 19-31-06-301.jpg",
"bandicam 2024-03-27 19-33-06-297.jpg", "bandicam 2024-03-27 19-35-06-305.jpg",
"bandicam 2024-03-27 19-37-06-299.jpg", "bandicam 2024-03-27 19-39-06-297.jpg",
"bandicam 2024-03-27 19-41-06-307.jpg", "bandicam 2024-03-27 19-43-06-299.jpg",
"bandicam 2024-03-27 19-45-06-298.jpg", "bandicam 2024-03-27 19-47-06-304.jpg",
"bandicam 2024-03-27 19-48-50-591.jpg", "bandicam 2024-03-29 12-23-36-175.jpg",
"bandicam 2024-03-29 12-23-50-142.jpg", "bandicam 2024-03-29 12-24-50-161.jpg",
"bandicam 2024-03-29 12-25-50-156.jpg", "bandicam 2024-03-29 12-26-50-168.jpg",
"bandicam 2024-03-29 12-27-26-514.jpg", "bandicam 2024-03-29 12-28-26-502.jpg",
"bandicam 2024-03-29 12-29-26-497.jpg", "bandicam 2024-03-29 12-29-39-894.jpg",
"bandicam 2024-03-29 12-30-39-902.jpg", "bandicam 2024-03-29 12-31-39-897.jpg",
"bandicam 2024-03-29 12-32-05-844.jpg", "bandicam 2024-03-29 12-33-05-843.jpg",
"bandicam 2024-03-29 12-34-05-832.jpg", "bandicam 2024-03-29 12-35-05-836.jpg",
"bandicam 2024-03-29 12-36-05-835.jpg", "bandicam 2024-03-29 12-37-05-858.jpg",
"bandicam 2024-03-29 12-38-06-101.jpg", "bandicam 2024-03-29 12-38-47-045.jpg",
"bandicam 2024-03-29 12-39-47-039.jpg", "bandicam 2024-03-29 12-40-47-050.jpg",
"bandicam 2024-03-29 12-41-47-047.jpg", "bandicam 2024-03-29 12-42-47-057.jpg",
"bandicam 2024-03-29 12-43-42-169.jpg", "bandicam 2024-03-29 12-44-41-398.jpg"
]


inds = 41:58
exp_meth_vol = [0, 4, 10, 9, 4, 5, 5, 4, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0]
meth_vol_acet_4 = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_4_s1"
source = "Acetate"
reactor = "Reactor 4"
sludge = "Sludge 1"
run_num = "Run 1"
input_vs = 1.55
p0 = [40.0, 10.0, 1.0]


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

max_rate_acet_4 = max_manual_rate


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
model_acet_4 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "min"
sma_acet_4 = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Reactor FW ###


file_vec = ["bandicam 2024-03-27 18-45-55-857.jpg", "bandicam 2024-03-27 18-46-57-161.jpg",
"bandicam 2024-03-27 18-48-57-160.jpg", "bandicam 2024-03-27 18-50-57-170.jpg",
"bandicam 2024-03-27 18-52-57-164.jpg", "bandicam 2024-03-27 18-54-57-162.jpg",
"bandicam 2024-03-27 18-56-57-167.jpg", "bandicam 2024-03-27 18-58-57-165.jpg",
"bandicam 2024-03-27 19-00-57-170.jpg", "bandicam 2024-03-27 19-02-57-179.jpg",
"bandicam 2024-03-27 19-04-57-173.jpg", "bandicam 2024-03-27 19-06-57-182.jpg",
"bandicam 2024-03-27 19-08-57-185.jpg", "bandicam 2024-03-27 19-10-57-184.jpg",
"bandicam 2024-03-27 19-12-57-189.jpg", "bandicam 2024-03-27 19-14-57-187.jpg",
"bandicam 2024-03-27 19-15-06-279.jpg", "bandicam 2024-03-27 19-19-06-273.jpg",
"bandicam 2024-03-27 19-21-06-276.jpg", "bandicam 2024-03-27 19-23-06-285.jpg",
"bandicam 2024-03-27 19-25-06-290.jpg", "bandicam 2024-03-27 19-27-06-301.jpg",
"bandicam 2024-03-27 19-29-06-303.jpg", "bandicam 2024-03-27 19-31-06-301.jpg",
"bandicam 2024-03-27 19-33-06-297.jpg", "bandicam 2024-03-27 19-35-06-305.jpg",
"bandicam 2024-03-27 19-37-06-299.jpg", "bandicam 2024-03-27 19-39-06-297.jpg",
"bandicam 2024-03-27 19-41-06-307.jpg", "bandicam 2024-03-27 19-43-06-299.jpg",
"bandicam 2024-03-27 19-45-06-298.jpg", "bandicam 2024-03-27 19-47-06-304.jpg",
"bandicam 2024-03-27 19-48-50-591.jpg", "bandicam 2024-03-29 12-23-36-175.jpg",
"bandicam 2024-03-29 12-23-50-142.jpg", "bandicam 2024-03-29 12-24-50-161.jpg",
"bandicam 2024-03-29 12-25-50-156.jpg", "bandicam 2024-03-29 12-26-50-168.jpg",
"bandicam 2024-03-29 12-27-26-514.jpg", "bandicam 2024-03-29 12-28-26-502.jpg",
"bandicam 2024-03-29 12-29-26-497.jpg", "bandicam 2024-03-29 12-29-39-894.jpg",
"bandicam 2024-03-29 12-30-39-902.jpg", "bandicam 2024-03-29 12-31-39-897.jpg",
"bandicam 2024-03-29 12-32-05-844.jpg", "bandicam 2024-03-29 12-33-05-843.jpg",
"bandicam 2024-03-29 12-34-05-832.jpg", "bandicam 2024-03-29 12-35-05-836.jpg",
"bandicam 2024-03-29 12-36-05-835.jpg", "bandicam 2024-03-29 12-37-05-858.jpg",
"bandicam 2024-03-29 12-38-06-101.jpg", "bandicam 2024-03-29 12-38-47-045.jpg",
"bandicam 2024-03-29 12-39-47-039.jpg", "bandicam 2024-03-29 12-40-47-050.jpg",
"bandicam 2024-03-29 12-41-47-047.jpg", "bandicam 2024-03-29 12-42-47-057.jpg",
"bandicam 2024-03-29 12-43-42-169.jpg", "bandicam 2024-03-29 12-44-41-398.jpg"
]


inds = 1:20
exp_meth_vol = [0, 12, 5, 3, 1.5, 1.5, 1, 1.5, 1, 0.5, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0, 0]
meth_vol_acet_fw = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_fw_s1"
source = "Acetate"
reactor = "Reactor FW"
sludge = "Sludge 1"
run_num = "Run 1"
input_vs = 1.55
p0 = [25.0, 6.0, 1.0]


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

max_rate_acet_fw = max_manual_rate


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
model_acet_fw = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [18.0, 4.0, 1.0]    

gompertz_sma(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))

lb = [0.0, 0.0, 0.0]
ub = [Inf, Inf, Inf]
specific_meth_vol = exp_cum_meth_vol./input_vs

fit = curve_fit(gompertz_sma, exp_min, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "min"
sma_acet_fw = vcat(reactor, round.(model_params, digits = 3), round(r_squared, digits = 3))  

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### No Feed Data Analysis ###


file_vec = ["bandicam 2024-03-27 18-45-55-857.jpg", "bandicam 2024-03-27 18-46-57-161.jpg",
"bandicam 2024-03-27 18-48-57-160.jpg", "bandicam 2024-03-27 18-50-57-170.jpg",
"bandicam 2024-03-27 18-52-57-164.jpg", "bandicam 2024-03-27 18-54-57-162.jpg",
"bandicam 2024-03-27 18-56-57-167.jpg", "bandicam 2024-03-27 18-58-57-165.jpg",
"bandicam 2024-03-27 19-00-57-170.jpg", "bandicam 2024-03-27 19-02-57-179.jpg",
"bandicam 2024-03-27 19-04-57-173.jpg", "bandicam 2024-03-27 19-06-57-182.jpg",
"bandicam 2024-03-27 19-08-57-185.jpg", "bandicam 2024-03-27 19-10-57-184.jpg",
"bandicam 2024-03-27 19-12-57-189.jpg", "bandicam 2024-03-27 19-14-57-187.jpg",
"bandicam 2024-03-27 19-15-06-279.jpg", "bandicam 2024-03-27 19-19-06-273.jpg",
"bandicam 2024-03-27 19-21-06-276.jpg", "bandicam 2024-03-27 19-23-06-285.jpg",
"bandicam 2024-03-27 19-25-06-290.jpg", "bandicam 2024-03-27 19-27-06-301.jpg",
"bandicam 2024-03-27 19-29-06-303.jpg", "bandicam 2024-03-27 19-31-06-301.jpg",
"bandicam 2024-03-27 19-33-06-297.jpg", "bandicam 2024-03-27 19-35-06-305.jpg",
"bandicam 2024-03-27 19-37-06-299.jpg", "bandicam 2024-03-27 19-39-06-297.jpg",
"bandicam 2024-03-27 19-41-06-307.jpg", "bandicam 2024-03-27 19-43-06-299.jpg",
"bandicam 2024-03-27 19-45-06-298.jpg", "bandicam 2024-03-27 19-47-06-304.jpg",
"bandicam 2024-03-27 19-48-50-591.jpg", "bandicam 2024-03-29 12-23-36-175.jpg",
"bandicam 2024-03-29 12-23-50-142.jpg", "bandicam 2024-03-29 12-24-50-161.jpg",
"bandicam 2024-03-29 12-25-50-156.jpg", "bandicam 2024-03-29 12-26-50-168.jpg",
"bandicam 2024-03-29 12-27-26-514.jpg", "bandicam 2024-03-29 12-28-26-502.jpg",
"bandicam 2024-03-29 12-29-26-497.jpg", "bandicam 2024-03-29 12-29-39-894.jpg",
"bandicam 2024-03-29 12-30-39-902.jpg", "bandicam 2024-03-29 12-31-39-897.jpg",
"bandicam 2024-03-29 12-32-05-844.jpg", "bandicam 2024-03-29 12-33-05-843.jpg",
"bandicam 2024-03-29 12-34-05-832.jpg", "bandicam 2024-03-29 12-35-05-836.jpg",
"bandicam 2024-03-29 12-36-05-835.jpg", "bandicam 2024-03-29 12-37-05-858.jpg",
"bandicam 2024-03-29 12-38-06-101.jpg", "bandicam 2024-03-29 12-38-47-045.jpg",
"bandicam 2024-03-29 12-39-47-039.jpg", "bandicam 2024-03-29 12-40-47-050.jpg",
"bandicam 2024-03-29 12-41-47-047.jpg", "bandicam 2024-03-29 12-42-47-057.jpg",
"bandicam 2024-03-29 12-43-42-169.jpg", "bandicam 2024-03-29 12-44-41-398.jpg"
]


inds = 1:17
exp_meth_vol = [0, 9, 3, 2, 3, 3, 3, 2.5, 2.5, 2.5, 1.5, 3, 1, 1, 1.5, 0.5, 0.1]
exp_name = "no_feed_ac_1"
source = "No_Feed"
reactor = "Reactor Ac"
sludge = "Sludge 1"
kinetics = false


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


if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end



file_vec = ["bandicam 2024-03-27 18-45-55-857.jpg", "bandicam 2024-03-27 18-46-57-161.jpg",
"bandicam 2024-03-27 18-48-57-160.jpg", "bandicam 2024-03-27 18-50-57-170.jpg",
"bandicam 2024-03-27 18-52-57-164.jpg", "bandicam 2024-03-27 18-54-57-162.jpg",
"bandicam 2024-03-27 18-56-57-167.jpg", "bandicam 2024-03-27 18-58-57-165.jpg",
"bandicam 2024-03-27 19-00-57-170.jpg", "bandicam 2024-03-27 19-02-57-179.jpg",
"bandicam 2024-03-27 19-04-57-173.jpg", "bandicam 2024-03-27 19-06-57-182.jpg",
"bandicam 2024-03-27 19-08-57-185.jpg", "bandicam 2024-03-27 19-10-57-184.jpg",
"bandicam 2024-03-27 19-12-57-189.jpg", "bandicam 2024-03-27 19-14-57-187.jpg",
"bandicam 2024-03-27 19-15-06-279.jpg", "bandicam 2024-03-27 19-19-06-273.jpg",
"bandicam 2024-03-27 19-21-06-276.jpg", "bandicam 2024-03-27 19-23-06-285.jpg",
"bandicam 2024-03-27 19-25-06-290.jpg", "bandicam 2024-03-27 19-27-06-301.jpg",
"bandicam 2024-03-27 19-29-06-303.jpg", "bandicam 2024-03-27 19-31-06-301.jpg",
"bandicam 2024-03-27 19-33-06-297.jpg", "bandicam 2024-03-27 19-35-06-305.jpg",
"bandicam 2024-03-27 19-37-06-299.jpg", "bandicam 2024-03-27 19-39-06-297.jpg",
"bandicam 2024-03-27 19-41-06-307.jpg", "bandicam 2024-03-27 19-43-06-299.jpg",
"bandicam 2024-03-27 19-45-06-298.jpg", "bandicam 2024-03-27 19-47-06-304.jpg",
"bandicam 2024-03-27 19-48-50-591.jpg", "bandicam 2024-03-29 12-23-36-175.jpg",
"bandicam 2024-03-29 12-23-50-142.jpg", "bandicam 2024-03-29 12-24-50-161.jpg",
"bandicam 2024-03-29 12-25-50-156.jpg", "bandicam 2024-03-29 12-26-50-168.jpg",
"bandicam 2024-03-29 12-27-26-514.jpg", "bandicam 2024-03-29 12-28-26-502.jpg",
"bandicam 2024-03-29 12-29-26-497.jpg", "bandicam 2024-03-29 12-29-39-894.jpg",
"bandicam 2024-03-29 12-30-39-902.jpg", "bandicam 2024-03-29 12-31-39-897.jpg",
"bandicam 2024-03-29 12-32-05-844.jpg", "bandicam 2024-03-29 12-33-05-843.jpg",
"bandicam 2024-03-29 12-34-05-832.jpg", "bandicam 2024-03-29 12-35-05-836.jpg",
"bandicam 2024-03-29 12-36-05-835.jpg", "bandicam 2024-03-29 12-37-05-858.jpg",
"bandicam 2024-03-29 12-38-06-101.jpg", "bandicam 2024-03-29 12-38-47-045.jpg",
"bandicam 2024-03-29 12-39-47-039.jpg", "bandicam 2024-03-29 12-40-47-050.jpg",
"bandicam 2024-03-29 12-41-47-047.jpg", "bandicam 2024-03-29 12-42-47-057.jpg",
"bandicam 2024-03-29 12-43-42-169.jpg", "bandicam 2024-03-29 12-44-41-398.jpg"
]


inds = 18:33
exp_meth_vol = [0, 3, 2, 2, 2, 3, 2, 2, 3, 2, 2.5, 2.5, 2, 2.5, 2.5, 2]
exp_name = "no_feed_ac_2"
source = "No_Feed"
reactor = "Reactor Ac"
sludge = "Sludge 1"
kinetics = false


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


if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


model_fit_table = Tables.table(vcat(reshape(model_acet_0, 1, 5), reshape(model_acet_1, 1, 5), reshape(model_acet_2, 1, 5), reshape(model_acet_4, 1, 5), reshape(model_acet_fw, 1, 5)), header = [:Reactor_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_acetate_kinetics_s1.csv"), model_fit_table)

return("../data/exp_pro/methane_from_acetate_kinetics_s1.csv")

sma_table = Tables.table(vcat(reshape(sma_acet_0, 1, 5), reshape(sma_acet_1, 1, 5), reshape(sma_acet_2, 1, 5), reshape(sma_acet_4, 1, 5), reshape(sma_acet_fw, 1, 5)), header = [:Reactor_Name, :Methane_Potential, :SMA, :Lag_Time, :R_sq])
CSV.write(datadir("exp_pro", "sma_from_acetate_s1.csv"), sma_table)



### Data Analysis on Hydrolysate with 0 ml ###


file_vec = ["bandicam 2024-04-03 14-37-15-369.jpg", "bandicam 2024-04-03 14-45-40-862.jpg",
"bandicam 2024-04-03 14-51-49-082.jpg", "bandicam 2024-04-03 14-56-51-812.jpg",
"bandicam 2024-04-03 15-29-08-067.jpg", "bandicam 2024-04-03 16-29-08-087.jpg",
"bandicam 2024-04-03 17-29-08-355.jpg", "bandicam 2024-04-03 18-29-08-352.jpg",
"bandicam 2024-04-03 20-29-08-355.jpg", "bandicam 2024-04-03 22-29-08-353.jpg",
"bandicam 2024-04-04 00-29-08-754.jpg", "bandicam 2024-04-04 02-29-08-758.jpg",
"bandicam 2024-04-04 04-29-08-760.jpg", "bandicam 2024-04-04 06-29-08-755.jpg",
"bandicam 2024-04-04 08-29-09-002.jpg", "bandicam 2024-04-04 10-29-09-357.jpg",
"bandicam 2024-04-04 12-29-09-384.jpg", "bandicam 2024-04-04 14-29-09-390.jpg",
"bandicam 2024-04-04 16-29-09-384.jpg", "bandicam 2024-04-04 18-29-10-491.jpg",
"bandicam 2024-04-04 20-29-10-660.jpg", "bandicam 2024-04-04 22-29-10-735.jpg",
"bandicam 2024-04-05 00-29-10-440.jpg", "bandicam 2024-04-05 02-29-10-498.jpg",
"bandicam 2024-04-05 04-29-10-676.jpg", "bandicam 2024-04-05 06-29-10-716.jpg",
"bandicam 2024-04-05 08-29-10-712.jpg", "bandicam 2024-04-05 09-29-10-696.jpg",
"bandicam 2024-04-05 10-37-27-280.jpg", "bandicam 2024-04-05 10-38-27-278.jpg",
"bandicam 2024-04-05 10-39-27-276.jpg", "bandicam 2024-04-05 10-40-25-889.jpg",
"bandicam 2024-04-05 11-40-36-404.jpg", "bandicam 2024-04-05 12-40-36-754.jpg",
"bandicam 2024-04-05 14-40-36-749.jpg", "bandicam 2024-04-05 16-40-36-776.jpg",
"bandicam 2024-04-05 18-40-37-133.jpg", "bandicam 2024-04-05 20-40-37-184.jpg",
"bandicam 2024-04-05 22-40-37-342.jpg", "bandicam 2024-04-06 00-40-37-559.jpg",
"bandicam 2024-04-06 02-40-37-573.jpg", "bandicam 2024-04-06 04-40-37-567.jpg",
"bandicam 2024-04-06 06-40-37-889.jpg", "bandicam 2024-04-06 08-40-38-009.jpg",
"bandicam 2024-04-06 10-40-38-008.jpg", "bandicam 2024-04-06 12-40-38-486.jpg",
"bandicam 2024-04-06 14-40-38-501.jpg", "bandicam 2024-04-06 16-40-38-661.jpg",
"bandicam 2024-04-06 18-40-38-699.jpg", "bandicam 2024-04-06 20-40-38-706.jpg",
"bandicam 2024-04-06 22-40-38-709.jpg", "bandicam 2024-04-07 00-40-39-320.jpg",
"bandicam 2024-04-07 02-40-39-358.jpg", "bandicam 2024-04-07 04-40-39-364.jpg",
"bandicam 2024-04-07 06-40-39-358.jpg", "bandicam 2024-04-07 08-40-39-476.jpg",
"bandicam 2024-04-07 10-40-40-039.jpg", "bandicam 2024-04-07 12-40-40-161.jpg",
"bandicam 2024-04-07 14-40-40-252.jpg", "bandicam 2024-04-07 16-40-40-328.jpg",
"bandicam 2024-04-07 18-40-40-704.jpg", "bandicam 2024-04-07 20-40-40-780.jpg",
"bandicam 2024-04-07 22-40-40-847.jpg", "bandicam 2024-04-08 00-40-41-872.jpg",
"bandicam 2024-04-08 02-40-41-942.jpg", "bandicam 2024-04-08 04-40-41-412.jpg",
"bandicam 2024-04-08 06-40-41-369.jpg", "bandicam 2024-04-08 08-40-41-364.jpg",
"bandicam 2024-04-08 10-40-41-360.jpg", "bandicam 2024-04-08 12-40-41-760.jpg",
"bandicam 2024-04-08 14-40-41-959.jpg", "bandicam 2024-04-08 16-40-41-983.jpg",
"bandicam 2024-04-08 18-40-42-029.jpg", "bandicam 2024-04-08 20-40-42-035.jpg",
"bandicam 2024-04-08 22-40-42-681.jpg", "bandicam 2024-04-08 23-40-42-823.jpg",
"bandicam 2024-04-09 00-40-42-828.jpg", "bandicam 2024-04-09 01-40-42-821.jpg",
"bandicam 2024-04-09 02-40-42-829.jpg", "bandicam 2024-04-09 03-40-42-815.jpg",
"bandicam 2024-04-09 04-40-42-811.jpg", "bandicam 2024-04-09 05-40-42-827.jpg",
"bandicam 2024-04-09 06-40-42-990.jpg", "bandicam 2024-04-09 07-40-43-217.jpg",
"bandicam 2024-04-09 08-40-43-296.jpg", "bandicam 2024-04-09 09-40-43-311.jpg",
"bandicam 2024-04-09 10-40-43-316.jpg", "bandicam 2024-04-09 11-19-56-444.jpg",
"bandicam 2024-04-09 12-19-57-641.jpg", "bandicam 2024-04-09 13-19-57-649.jpg",
"bandicam 2024-04-09 14-19-57-646.jpg", "bandicam 2024-04-09 15-19-57-536.jpg",
"bandicam 2024-04-09 16-19-57-212.jpg", "bandicam 2024-04-09 17-19-57-105.jpg",
"bandicam 2024-04-09 18-19-57-234.jpg", "bandicam 2024-04-09 19-19-57-244.jpg",
"bandicam 2024-04-09 20-19-57-237.jpg", "bandicam 2024-04-09 21-19-57-252.jpg",
"bandicam 2024-04-09 22-19-57-268.jpg", "bandicam 2024-04-09 23-19-57-667.jpg",
"bandicam 2024-04-10 00-19-57-661.jpg", "bandicam 2024-04-10 01-19-57-748.jpg",
"bandicam 2024-04-10 02-19-57-773.jpg", "bandicam 2024-04-10 03-19-57-782.jpg"
]

inds = 1:73
exp_meth_vol = [0, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 0.05, 0.1, 0.1, 0.05, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0.1, 0.05, 0, 0, 0.05, 0.05, 0.05, 0.1, 0.05, 0.05, 0.05, 0.05, 0.1, 0.1, 0.1, 0.05, 0.05, 0.05, 0.05, 0, 0.05, 0, 0.02, 0.02, 0.01, 0, 0, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_0 = cumsum(exp_meth_vol)[end]

exp_name = "hydrolysate_0_s1_r2"
source = "Hydrolyzed FW"
reactor = "Reactor 0"
sludge = "Sludge 1"
run_num = "Run 2"
input_vs = 1.55


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
p0 = [5.0, 0.04, 1.0]

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
model_hydro_0_min = vcat(reactor, round.(model_params, digits = 4), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [4.0, 0.1, 1.0]

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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 1 ml ###


file_vec = ["bandicam 2024-04-03 14-37-15-369.jpg", "bandicam 2024-04-03 14-45-40-862.jpg",
"bandicam 2024-04-03 14-51-49-082.jpg", "bandicam 2024-04-03 14-56-51-812.jpg",
"bandicam 2024-04-03 15-29-08-067.jpg", "bandicam 2024-04-03 16-29-08-087.jpg",
"bandicam 2024-04-03 17-29-08-355.jpg", "bandicam 2024-04-03 18-29-08-352.jpg",
"bandicam 2024-04-03 20-29-08-355.jpg", "bandicam 2024-04-03 22-29-08-353.jpg",
"bandicam 2024-04-04 00-29-08-754.jpg", "bandicam 2024-04-04 02-29-08-758.jpg",
"bandicam 2024-04-04 04-29-08-760.jpg", "bandicam 2024-04-04 06-29-08-755.jpg",
"bandicam 2024-04-04 08-29-09-002.jpg", "bandicam 2024-04-04 10-29-09-357.jpg",
"bandicam 2024-04-04 12-29-09-384.jpg", "bandicam 2024-04-04 14-29-09-390.jpg",
"bandicam 2024-04-04 16-29-09-384.jpg", "bandicam 2024-04-04 18-29-10-491.jpg",
"bandicam 2024-04-04 20-29-10-660.jpg", "bandicam 2024-04-04 22-29-10-735.jpg",
"bandicam 2024-04-05 00-29-10-440.jpg", "bandicam 2024-04-05 02-29-10-498.jpg",
"bandicam 2024-04-05 04-29-10-676.jpg", "bandicam 2024-04-05 06-29-10-716.jpg",
"bandicam 2024-04-05 08-29-10-712.jpg", "bandicam 2024-04-05 09-29-10-696.jpg",
"bandicam 2024-04-05 10-37-27-280.jpg", "bandicam 2024-04-05 10-38-27-278.jpg",
"bandicam 2024-04-05 10-39-27-276.jpg", "bandicam 2024-04-05 10-40-25-889.jpg",
"bandicam 2024-04-05 11-40-36-404.jpg", "bandicam 2024-04-05 12-40-36-754.jpg",
"bandicam 2024-04-05 14-40-36-749.jpg", "bandicam 2024-04-05 16-40-36-776.jpg",
"bandicam 2024-04-05 18-40-37-133.jpg", "bandicam 2024-04-05 20-40-37-184.jpg",
"bandicam 2024-04-05 22-40-37-342.jpg", "bandicam 2024-04-06 00-40-37-559.jpg",
"bandicam 2024-04-06 02-40-37-573.jpg", "bandicam 2024-04-06 04-40-37-567.jpg",
"bandicam 2024-04-06 06-40-37-889.jpg", "bandicam 2024-04-06 08-40-38-009.jpg",
"bandicam 2024-04-06 10-40-38-008.jpg", "bandicam 2024-04-06 12-40-38-486.jpg",
"bandicam 2024-04-06 14-40-38-501.jpg", "bandicam 2024-04-06 16-40-38-661.jpg",
"bandicam 2024-04-06 18-40-38-699.jpg", "bandicam 2024-04-06 20-40-38-706.jpg",
"bandicam 2024-04-06 22-40-38-709.jpg", "bandicam 2024-04-07 00-40-39-320.jpg",
"bandicam 2024-04-07 02-40-39-358.jpg", "bandicam 2024-04-07 04-40-39-364.jpg",
"bandicam 2024-04-07 06-40-39-358.jpg", "bandicam 2024-04-07 08-40-39-476.jpg",
"bandicam 2024-04-07 10-40-40-039.jpg", "bandicam 2024-04-07 12-40-40-161.jpg",
"bandicam 2024-04-07 14-40-40-252.jpg", "bandicam 2024-04-07 16-40-40-328.jpg",
"bandicam 2024-04-07 18-40-40-704.jpg", "bandicam 2024-04-07 20-40-40-780.jpg",
"bandicam 2024-04-07 22-40-40-847.jpg", "bandicam 2024-04-08 00-40-41-872.jpg",
"bandicam 2024-04-08 02-40-41-942.jpg", "bandicam 2024-04-08 04-40-41-412.jpg",
"bandicam 2024-04-08 06-40-41-369.jpg", "bandicam 2024-04-08 08-40-41-364.jpg",
"bandicam 2024-04-08 10-40-41-360.jpg", "bandicam 2024-04-08 12-40-41-760.jpg",
"bandicam 2024-04-08 14-40-41-959.jpg", "bandicam 2024-04-08 16-40-41-983.jpg",
"bandicam 2024-04-08 18-40-42-029.jpg", "bandicam 2024-04-08 20-40-42-035.jpg",
"bandicam 2024-04-08 22-40-42-681.jpg", "bandicam 2024-04-08 23-40-42-823.jpg",
"bandicam 2024-04-09 00-40-42-828.jpg", "bandicam 2024-04-09 01-40-42-821.jpg",
"bandicam 2024-04-09 02-40-42-829.jpg", "bandicam 2024-04-09 03-40-42-815.jpg",
"bandicam 2024-04-09 04-40-42-811.jpg", "bandicam 2024-04-09 05-40-42-827.jpg",
"bandicam 2024-04-09 06-40-42-990.jpg", "bandicam 2024-04-09 07-40-43-217.jpg",
"bandicam 2024-04-09 08-40-43-296.jpg", "bandicam 2024-04-09 09-40-43-311.jpg",
"bandicam 2024-04-09 10-40-43-316.jpg", "bandicam 2024-04-09 11-19-56-444.jpg",
"bandicam 2024-04-09 12-19-57-641.jpg", "bandicam 2024-04-09 13-19-57-649.jpg",
"bandicam 2024-04-09 14-19-57-646.jpg", "bandicam 2024-04-09 15-19-57-536.jpg",
"bandicam 2024-04-09 16-19-57-212.jpg", "bandicam 2024-04-09 17-19-57-105.jpg",
"bandicam 2024-04-09 18-19-57-234.jpg", "bandicam 2024-04-09 19-19-57-244.jpg",
"bandicam 2024-04-09 20-19-57-237.jpg", "bandicam 2024-04-09 21-19-57-252.jpg",
"bandicam 2024-04-09 22-19-57-268.jpg", "bandicam 2024-04-09 23-19-57-667.jpg",
"bandicam 2024-04-10 00-19-57-661.jpg", "bandicam 2024-04-10 01-19-57-748.jpg",
"bandicam 2024-04-10 02-19-57-773.jpg", "bandicam 2024-04-10 03-19-57-782.jpg"
]

inds = 2:75
exp_meth_vol = [0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.05, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1, 0.05, 0.1, 0, 0, 0, 0.1, 0.1, 0.2, 0.4, 0.5, 0.2, 0.1, 0.1, 0.2, 0, 0.1, 0.2, 0.2, 0.1, 0.3, 0.1, 0.1, 0, 0.1, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.1, 0, 0.1, 0.2, 0, 0.1, 0.1, 0.2, 0.2, 0.1, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_1 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_1_s1_r2"
source = "Hydrolyzed FW"
reactor = "Reactor 1"
sludge = "Sludge 1"
run_num = "Run 2"
input_vs = 1.5

p0 = [13.0, 1.0, 1.0]

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
model_hydro_1_min = vcat(reactor, round.(model_params, digits = 4), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [20.0, 0.5, 1.0]

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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 2 ml ###


file_vec = ["bandicam 2024-04-03 14-37-15-369.jpg", "bandicam 2024-04-03 14-45-40-862.jpg",
"bandicam 2024-04-03 14-51-49-082.jpg", "bandicam 2024-04-03 14-56-51-812.jpg",
"bandicam 2024-04-03 15-29-08-067.jpg", "bandicam 2024-04-03 16-29-08-087.jpg",
"bandicam 2024-04-03 17-29-08-355.jpg", "bandicam 2024-04-03 18-29-08-352.jpg",
"bandicam 2024-04-03 20-29-08-355.jpg", "bandicam 2024-04-03 22-29-08-353.jpg",
"bandicam 2024-04-04 00-29-08-754.jpg", "bandicam 2024-04-04 02-29-08-758.jpg",
"bandicam 2024-04-04 04-29-08-760.jpg", "bandicam 2024-04-04 06-29-08-755.jpg",
"bandicam 2024-04-04 08-29-09-002.jpg", "bandicam 2024-04-04 10-29-09-357.jpg",
"bandicam 2024-04-04 12-29-09-384.jpg", "bandicam 2024-04-04 14-29-09-390.jpg",
"bandicam 2024-04-04 16-29-09-384.jpg", "bandicam 2024-04-04 18-29-10-491.jpg",
"bandicam 2024-04-04 20-29-10-660.jpg", "bandicam 2024-04-04 22-29-10-735.jpg",
"bandicam 2024-04-05 00-29-10-440.jpg", "bandicam 2024-04-05 02-29-10-498.jpg",
"bandicam 2024-04-05 04-29-10-676.jpg", "bandicam 2024-04-05 06-29-10-716.jpg",
"bandicam 2024-04-05 08-29-10-712.jpg", "bandicam 2024-04-05 09-29-10-696.jpg",
"bandicam 2024-04-05 10-37-27-280.jpg", "bandicam 2024-04-05 10-38-27-278.jpg",
"bandicam 2024-04-05 10-39-27-276.jpg", "bandicam 2024-04-05 10-40-25-889.jpg",
"bandicam 2024-04-05 11-40-36-404.jpg", "bandicam 2024-04-05 12-40-36-754.jpg",
"bandicam 2024-04-05 14-40-36-749.jpg", "bandicam 2024-04-05 16-40-36-776.jpg",
"bandicam 2024-04-05 18-40-37-133.jpg", "bandicam 2024-04-05 20-40-37-184.jpg",
"bandicam 2024-04-05 22-40-37-342.jpg", "bandicam 2024-04-06 00-40-37-559.jpg",
"bandicam 2024-04-06 02-40-37-573.jpg", "bandicam 2024-04-06 04-40-37-567.jpg",
"bandicam 2024-04-06 06-40-37-889.jpg", "bandicam 2024-04-06 08-40-38-009.jpg",
"bandicam 2024-04-06 10-40-38-008.jpg", "bandicam 2024-04-06 12-40-38-486.jpg",
"bandicam 2024-04-06 14-40-38-501.jpg", "bandicam 2024-04-06 16-40-38-661.jpg",
"bandicam 2024-04-06 18-40-38-699.jpg", "bandicam 2024-04-06 20-40-38-706.jpg",
"bandicam 2024-04-06 22-40-38-709.jpg", "bandicam 2024-04-07 00-40-39-320.jpg",
"bandicam 2024-04-07 02-40-39-358.jpg", "bandicam 2024-04-07 04-40-39-364.jpg",
"bandicam 2024-04-07 06-40-39-358.jpg", "bandicam 2024-04-07 08-40-39-476.jpg",
"bandicam 2024-04-07 10-40-40-039.jpg", "bandicam 2024-04-07 12-40-40-161.jpg",
"bandicam 2024-04-07 14-40-40-252.jpg", "bandicam 2024-04-07 16-40-40-328.jpg",
"bandicam 2024-04-07 18-40-40-704.jpg", "bandicam 2024-04-07 20-40-40-780.jpg",
"bandicam 2024-04-07 22-40-40-847.jpg", "bandicam 2024-04-08 00-40-41-872.jpg",
"bandicam 2024-04-08 02-40-41-942.jpg", "bandicam 2024-04-08 04-40-41-412.jpg",
"bandicam 2024-04-08 06-40-41-369.jpg", "bandicam 2024-04-08 08-40-41-364.jpg",
"bandicam 2024-04-08 10-40-41-360.jpg", "bandicam 2024-04-08 12-40-41-760.jpg",
"bandicam 2024-04-08 14-40-41-959.jpg", "bandicam 2024-04-08 16-40-41-983.jpg",
"bandicam 2024-04-08 18-40-42-029.jpg", "bandicam 2024-04-08 20-40-42-035.jpg",
"bandicam 2024-04-08 22-40-42-681.jpg", "bandicam 2024-04-08 23-40-42-823.jpg",
"bandicam 2024-04-09 00-40-42-828.jpg", "bandicam 2024-04-09 01-40-42-821.jpg",
"bandicam 2024-04-09 02-40-42-829.jpg", "bandicam 2024-04-09 03-40-42-815.jpg",
"bandicam 2024-04-09 04-40-42-811.jpg", "bandicam 2024-04-09 05-40-42-827.jpg",
"bandicam 2024-04-09 06-40-42-990.jpg", "bandicam 2024-04-09 07-40-43-217.jpg",
"bandicam 2024-04-09 08-40-43-296.jpg", "bandicam 2024-04-09 09-40-43-311.jpg",
"bandicam 2024-04-09 10-40-43-316.jpg", "bandicam 2024-04-09 11-19-56-444.jpg",
"bandicam 2024-04-09 12-19-57-641.jpg", "bandicam 2024-04-09 13-19-57-649.jpg",
"bandicam 2024-04-09 14-19-57-646.jpg", "bandicam 2024-04-09 15-19-57-536.jpg",
"bandicam 2024-04-09 16-19-57-212.jpg", "bandicam 2024-04-09 17-19-57-105.jpg",
"bandicam 2024-04-09 18-19-57-234.jpg", "bandicam 2024-04-09 19-19-57-244.jpg",
"bandicam 2024-04-09 20-19-57-237.jpg", "bandicam 2024-04-09 21-19-57-252.jpg",
"bandicam 2024-04-09 22-19-57-268.jpg", "bandicam 2024-04-09 23-19-57-667.jpg",
"bandicam 2024-04-10 00-19-57-661.jpg", "bandicam 2024-04-10 01-19-57-748.jpg",
"bandicam 2024-04-10 02-19-57-773.jpg", "bandicam 2024-04-10 03-19-57-782.jpg"
]

inds = 4:75
exp_meth_vol = [0, 0.1, 0.1, 1.3, 0, 0.2, 0.1, 0.4, 0.5, 0.2, 0.1, 0.5, 0, 0.1, 0.2, 0.2, 0.2, 0.1, 0.05, 0.05, 0.05, 0, 0.1, 0.1, 0, 0, 0, 0.1, 0.1, 0.2, 0.05, 0, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1, 0.05, 0.05, 0, 0.05, 0.1, 0.1, 0, 0.05, 0.1, 0.1, 0.2, 0.2, 0, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0.05, 0.05, 0.05, 0, 0, 0, 0, 0]
meth_vol_hydro_2 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_2_s1_r2"
source = "Hydrolyzed FW"
reactor = "Reactor 2"
sludge = "Sludge 1"
run_num = "Run 2"
input_vs = 1.55


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

p0 = [10.0, 1.50, 1.0]

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
model_hydro_2_min = vcat(reactor, round.(model_params, digits = 4), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [10.0, 0.1, 0.03]

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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Hydrolysate with 4 ml ###


file_vec = ["bandicam 2024-04-03 14-37-15-369.jpg", "bandicam 2024-04-03 14-45-40-862.jpg",
"bandicam 2024-04-03 14-51-49-082.jpg", "bandicam 2024-04-03 14-56-51-812.jpg",
"bandicam 2024-04-03 15-29-08-067.jpg", "bandicam 2024-04-03 16-29-08-087.jpg",
"bandicam 2024-04-03 17-29-08-355.jpg", "bandicam 2024-04-03 18-29-08-352.jpg",
"bandicam 2024-04-03 20-29-08-355.jpg", "bandicam 2024-04-03 22-29-08-353.jpg",
"bandicam 2024-04-04 00-29-08-754.jpg", "bandicam 2024-04-04 02-29-08-758.jpg",
"bandicam 2024-04-04 04-29-08-760.jpg", "bandicam 2024-04-04 06-29-08-755.jpg",
"bandicam 2024-04-04 08-29-09-002.jpg", "bandicam 2024-04-04 10-29-09-357.jpg",
"bandicam 2024-04-04 12-29-09-384.jpg", "bandicam 2024-04-04 14-29-09-390.jpg",
"bandicam 2024-04-04 16-29-09-384.jpg", "bandicam 2024-04-04 18-29-10-491.jpg",
"bandicam 2024-04-04 20-29-10-660.jpg", "bandicam 2024-04-04 22-29-10-735.jpg",
"bandicam 2024-04-05 00-29-10-440.jpg", "bandicam 2024-04-05 02-29-10-498.jpg",
"bandicam 2024-04-05 04-29-10-676.jpg", "bandicam 2024-04-05 06-29-10-716.jpg",
"bandicam 2024-04-05 08-29-10-712.jpg", "bandicam 2024-04-05 09-29-10-696.jpg",
"bandicam 2024-04-05 10-37-27-280.jpg", "bandicam 2024-04-05 10-38-27-278.jpg",
"bandicam 2024-04-05 10-39-27-276.jpg", "bandicam 2024-04-05 10-40-25-889.jpg",
"bandicam 2024-04-05 11-40-36-404.jpg", "bandicam 2024-04-05 12-40-36-754.jpg",
"bandicam 2024-04-05 14-40-36-749.jpg", "bandicam 2024-04-05 16-40-36-776.jpg",
"bandicam 2024-04-05 18-40-37-133.jpg", "bandicam 2024-04-05 20-40-37-184.jpg",
"bandicam 2024-04-05 22-40-37-342.jpg", "bandicam 2024-04-06 00-40-37-559.jpg",
"bandicam 2024-04-06 02-40-37-573.jpg", "bandicam 2024-04-06 04-40-37-567.jpg",
"bandicam 2024-04-06 06-40-37-889.jpg", "bandicam 2024-04-06 08-40-38-009.jpg",
"bandicam 2024-04-06 10-40-38-008.jpg", "bandicam 2024-04-06 12-40-38-486.jpg",
"bandicam 2024-04-06 14-40-38-501.jpg", "bandicam 2024-04-06 16-40-38-661.jpg",
"bandicam 2024-04-06 18-40-38-699.jpg", "bandicam 2024-04-06 20-40-38-706.jpg",
"bandicam 2024-04-06 22-40-38-709.jpg", "bandicam 2024-04-07 00-40-39-320.jpg",
"bandicam 2024-04-07 02-40-39-358.jpg", "bandicam 2024-04-07 04-40-39-364.jpg",
"bandicam 2024-04-07 06-40-39-358.jpg", "bandicam 2024-04-07 08-40-39-476.jpg",
"bandicam 2024-04-07 10-40-40-039.jpg", "bandicam 2024-04-07 12-40-40-161.jpg",
"bandicam 2024-04-07 14-40-40-252.jpg", "bandicam 2024-04-07 16-40-40-328.jpg",
"bandicam 2024-04-07 18-40-40-704.jpg", "bandicam 2024-04-07 20-40-40-780.jpg",
"bandicam 2024-04-07 22-40-40-847.jpg", "bandicam 2024-04-08 00-40-41-872.jpg",
"bandicam 2024-04-08 02-40-41-942.jpg", "bandicam 2024-04-08 04-40-41-412.jpg",
"bandicam 2024-04-08 06-40-41-369.jpg", "bandicam 2024-04-08 08-40-41-364.jpg",
"bandicam 2024-04-08 10-40-41-360.jpg", "bandicam 2024-04-08 12-40-41-760.jpg",
"bandicam 2024-04-08 14-40-41-959.jpg", "bandicam 2024-04-08 16-40-41-983.jpg",
"bandicam 2024-04-08 18-40-42-029.jpg", "bandicam 2024-04-08 20-40-42-035.jpg",
"bandicam 2024-04-08 22-40-42-681.jpg", "bandicam 2024-04-08 23-40-42-823.jpg",
"bandicam 2024-04-09 00-40-42-828.jpg", "bandicam 2024-04-09 01-40-42-821.jpg",
"bandicam 2024-04-09 02-40-42-829.jpg", "bandicam 2024-04-09 03-40-42-815.jpg",
"bandicam 2024-04-09 04-40-42-811.jpg", "bandicam 2024-04-09 05-40-42-827.jpg",
"bandicam 2024-04-09 06-40-42-990.jpg", "bandicam 2024-04-09 07-40-43-217.jpg",
"bandicam 2024-04-09 08-40-43-296.jpg", "bandicam 2024-04-09 09-40-43-311.jpg",
"bandicam 2024-04-09 10-40-43-316.jpg", "bandicam 2024-04-09 11-19-56-444.jpg",
"bandicam 2024-04-09 12-19-57-641.jpg", "bandicam 2024-04-09 13-19-57-649.jpg",
"bandicam 2024-04-09 14-19-57-646.jpg", "bandicam 2024-04-09 15-19-57-536.jpg",
"bandicam 2024-04-09 16-19-57-212.jpg", "bandicam 2024-04-09 17-19-57-105.jpg",
"bandicam 2024-04-09 18-19-57-234.jpg", "bandicam 2024-04-09 19-19-57-244.jpg",
"bandicam 2024-04-09 20-19-57-237.jpg", "bandicam 2024-04-09 21-19-57-252.jpg",
"bandicam 2024-04-09 22-19-57-268.jpg", "bandicam 2024-04-09 23-19-57-667.jpg",
"bandicam 2024-04-10 00-19-57-661.jpg", "bandicam 2024-04-10 01-19-57-748.jpg",
"bandicam 2024-04-10 02-19-57-773.jpg", "bandicam 2024-04-10 03-19-57-782.jpg"
]

inds = 3:75
exp_meth_vol = [0, 0, 0, 0, 0.05, 0.1, 0.1, 0.3, 0.3, 0.3, 0.3, 0.3, 0.1, 0.2, 0.1, 0.1, 0.2, 0.1, 0.1, 0.05, 0.1, 0.2, 0.2, 0.1, 0.05, 0.1, 0.1, 0, 0, 0, 0, 0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.1, 0.1, 0.2, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.2, 0.1, 0, 0, 0.05, 0.05, 0, 0.05, 0.1, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_4 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_4_s1_r2"
source = "Hydrolyzed FW"
reactor = "Reactor 4"
sludge = "Sludge 1"
run_num = "Run 2"

input_vs = 1.55


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

p0 = [17.0, 15.0, 1.0]

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
model_hydro_4_min = vcat(reactor, round.(model_params, digits = 4), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [17.0, 100.0, 0.1]

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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")

### Data Analysis on Untreated FW ###

file_vec = ["bandicam 2024-04-03 14-37-15-369.jpg", "bandicam 2024-04-03 14-45-40-862.jpg",
"bandicam 2024-04-03 14-51-49-082.jpg", "bandicam 2024-04-03 14-56-51-812.jpg",
"bandicam 2024-04-03 15-29-08-067.jpg", "bandicam 2024-04-03 16-29-08-087.jpg",
"bandicam 2024-04-03 17-29-08-355.jpg", "bandicam 2024-04-03 18-29-08-352.jpg",
"bandicam 2024-04-03 20-29-08-355.jpg", "bandicam 2024-04-03 22-29-08-353.jpg",
"bandicam 2024-04-04 00-29-08-754.jpg", "bandicam 2024-04-04 02-29-08-758.jpg",
"bandicam 2024-04-04 04-29-08-760.jpg", "bandicam 2024-04-04 06-29-08-755.jpg",
"bandicam 2024-04-04 08-29-09-002.jpg", "bandicam 2024-04-04 10-29-09-357.jpg",
"bandicam 2024-04-04 12-29-09-384.jpg", "bandicam 2024-04-04 14-29-09-390.jpg",
"bandicam 2024-04-04 16-29-09-384.jpg", "bandicam 2024-04-04 18-29-10-491.jpg",
"bandicam 2024-04-04 20-29-10-660.jpg", "bandicam 2024-04-04 22-29-10-735.jpg",
"bandicam 2024-04-05 00-29-10-440.jpg", "bandicam 2024-04-05 02-29-10-498.jpg",
"bandicam 2024-04-05 04-29-10-676.jpg", "bandicam 2024-04-05 06-29-10-716.jpg",
"bandicam 2024-04-05 08-29-10-712.jpg", "bandicam 2024-04-05 09-29-10-696.jpg",
"bandicam 2024-04-05 10-37-27-280.jpg", "bandicam 2024-04-05 10-38-27-278.jpg",
"bandicam 2024-04-05 10-39-27-276.jpg", "bandicam 2024-04-05 10-40-25-889.jpg",
"bandicam 2024-04-05 11-40-36-404.jpg", "bandicam 2024-04-05 12-40-36-754.jpg",
"bandicam 2024-04-05 14-40-36-749.jpg", "bandicam 2024-04-05 16-40-36-776.jpg",
"bandicam 2024-04-05 18-40-37-133.jpg", "bandicam 2024-04-05 20-40-37-184.jpg",
"bandicam 2024-04-05 22-40-37-342.jpg", "bandicam 2024-04-06 00-40-37-559.jpg",
"bandicam 2024-04-06 02-40-37-573.jpg", "bandicam 2024-04-06 04-40-37-567.jpg",
"bandicam 2024-04-06 06-40-37-889.jpg", "bandicam 2024-04-06 08-40-38-009.jpg",
"bandicam 2024-04-06 10-40-38-008.jpg", "bandicam 2024-04-06 12-40-38-486.jpg",
"bandicam 2024-04-06 14-40-38-501.jpg", "bandicam 2024-04-06 16-40-38-661.jpg",
"bandicam 2024-04-06 18-40-38-699.jpg", "bandicam 2024-04-06 20-40-38-706.jpg",
"bandicam 2024-04-06 22-40-38-709.jpg", "bandicam 2024-04-07 00-40-39-320.jpg",
"bandicam 2024-04-07 02-40-39-358.jpg", "bandicam 2024-04-07 04-40-39-364.jpg",
"bandicam 2024-04-07 06-40-39-358.jpg", "bandicam 2024-04-07 08-40-39-476.jpg",
"bandicam 2024-04-07 10-40-40-039.jpg", "bandicam 2024-04-07 12-40-40-161.jpg",
"bandicam 2024-04-07 14-40-40-252.jpg", "bandicam 2024-04-07 16-40-40-328.jpg",
"bandicam 2024-04-07 18-40-40-704.jpg", "bandicam 2024-04-07 20-40-40-780.jpg",
"bandicam 2024-04-07 22-40-40-847.jpg", "bandicam 2024-04-08 00-40-41-872.jpg",
"bandicam 2024-04-08 02-40-41-942.jpg", "bandicam 2024-04-08 04-40-41-412.jpg",
"bandicam 2024-04-08 06-40-41-369.jpg", "bandicam 2024-04-08 08-40-41-364.jpg",
"bandicam 2024-04-08 10-40-41-360.jpg", "bandicam 2024-04-08 12-40-41-760.jpg",
"bandicam 2024-04-08 14-40-41-959.jpg", "bandicam 2024-04-08 16-40-41-983.jpg",
"bandicam 2024-04-08 18-40-42-029.jpg", "bandicam 2024-04-08 20-40-42-035.jpg",
"bandicam 2024-04-08 22-40-42-681.jpg", "bandicam 2024-04-08 23-40-42-823.jpg",
"bandicam 2024-04-09 00-40-42-828.jpg", "bandicam 2024-04-09 01-40-42-821.jpg",
"bandicam 2024-04-09 02-40-42-829.jpg", "bandicam 2024-04-09 03-40-42-815.jpg",
"bandicam 2024-04-09 04-40-42-811.jpg", "bandicam 2024-04-09 05-40-42-827.jpg",
"bandicam 2024-04-09 06-40-42-990.jpg", "bandicam 2024-04-09 07-40-43-217.jpg",
"bandicam 2024-04-09 08-40-43-296.jpg", "bandicam 2024-04-09 09-40-43-311.jpg",
"bandicam 2024-04-09 10-40-43-316.jpg", "bandicam 2024-04-09 11-19-56-444.jpg",
"bandicam 2024-04-09 12-19-57-641.jpg", "bandicam 2024-04-09 13-19-57-649.jpg",
"bandicam 2024-04-09 14-19-57-646.jpg", "bandicam 2024-04-09 15-19-57-536.jpg",
"bandicam 2024-04-09 16-19-57-212.jpg", "bandicam 2024-04-09 17-19-57-105.jpg",
"bandicam 2024-04-09 18-19-57-234.jpg", "bandicam 2024-04-09 19-19-57-244.jpg",
"bandicam 2024-04-09 20-19-57-237.jpg", "bandicam 2024-04-09 21-19-57-252.jpg",
"bandicam 2024-04-09 22-19-57-268.jpg", "bandicam 2024-04-09 23-19-57-667.jpg",
"bandicam 2024-04-10 00-19-57-661.jpg", "bandicam 2024-04-10 01-19-57-748.jpg",
"bandicam 2024-04-10 02-19-57-773.jpg", "bandicam 2024-04-10 03-19-57-782.jpg"
]

inds = 33:104
exp_meth_vol = vcat([0, 0.1, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0, 0, 0.2, 0.2, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.05], zeros(46))
meth_vol_hydro_fw = cumsum(exp_meth_vol)[end]
exp_name = "untreated_fw_s1_r2"
source = "Untreated FW"
reactor = "FW"
sludge = "Sludge 1"
run_num = "Run 2"

input_vs = 1.55


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

p0 = [2.5, 0.05, 1.0]

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
model_hydro_fw_min = vcat(reactor, round.(model_params, digits = 4), round(r_squared, digits = 3))

if source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    if timescale == "hour"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


p0 = [2.5, 0.1, 0.1]

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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
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
	    Plots.plot!(exp_hour, gompertz_bmp(exp_hour), label = "Gompertz Model with  "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_hour.png"))
	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_hour, gompertz_sma(exp_hour), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))
	end

    elseif timescale == "min"
	if kinetics == "bmp"
	    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = :bottomright, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470))
	    Plots.plot!(exp_min, gompertz_bmp(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))

	elseif kinetics == "sma"
	    bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g VS)", title = "Methane Production Kinetics from "*source*" \nUsing "*reactor*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	    Plots.plot!(exp_min, gompertz_sma(exp_min), label = "Gompertz Model with "*L"R^2 = "*string(round(r_squared, digits = 3)))
	    savefig(bmp_specific_methane, plotsdir("BMPs", source, "specific_methane_kinetics_"*exp_name*"_"*timescale*".png"))

	end
    end
end


return("../data/exp_pro/"*exp_name*".csv")


model_fit_table_min = Tables.table(vcat(reshape(model_hydro_0_min, 1, 5), reshape(model_hydro_1_min, 1, 5), reshape(model_hydro_2_min, 1, 5), reshape(model_hydro_4_min, 1, 5), reshape(model_hydro_fw_min, 1, 5)), header = [:Reactor_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_min_s1_r2.csv"), model_fit_table_min)

model_fit_table_hour = Tables.table(vcat(reshape(model_hydro_0_hour, 1, 5), reshape(model_hydro_1_hour, 1, 5), reshape(model_hydro_2_hour, 1, 5), reshape(model_hydro_4_hour, 1, 5), reshape(model_hydro_fw_hour, 1, 5)), header = [:Reactor_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_hour_s1_r2.csv"), model_fit_table_hour)
return("../data/exp_pro/methane_from_hydrolysate_kinetics_min_s1_r2.csv")

sma_table = Tables.table(vcat(reshape(sma_hydro_0, 1, 5), reshape(sma_hydro_1, 1, 5), reshape(sma_hydro_2, 1, 5), reshape(sma_hydro_4, 1, 5), reshape(sma_hydro_fw, 1, 5)), header = [:Reactor_Name, :Methane_Potential, :SMA, :Lag_Time, :R_sq])
CSV.write(datadir("exp_pro", "sma_from_hydrolysate_s1_r2.csv"), sma_table)

comp_name = "s1_r2"
sludge = "Sludge 1 "
run = "Run 2"

using CairoMakie
colors = Makie.wong_colors()

meth_vol = [meth_vol_acet_0, meth_vol_acet_1, meth_vol_acet_2, meth_vol_acet_4, meth_vol_acet_fw, meth_vol_hydro_0, meth_vol_hydro_1, meth_vol_hydro_2, meth_vol_hydro_4, meth_vol_hydro_fw]

percent_bmp = [meth_vol[i+5]/meth_vol[i] for i in 1:5]
string_bmp = vcat(string.(round.(percent_bmp.*100, digits = 2)).*" %", ["0 ml", "1 ml", "2 ml", "4 ml", "Untreated \nFW"])

fig = Figure(size = (600, 400))
ax = Axis(fig[1,1], xticks = (1:5, ["0 ml", "1 ml", "2 ml", "4 ml", "Untreated FW"]),
	  title = "Acetate vs Hydrolysate BMP - "*sludge*run, ylabel = "Methane Produced (ml)")

xdata = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5]
grp = [1, 1, 1, 1, 1, 2, 2, 2, 2, 2]

barplot!(ax, xdata, meth_vol,
	dodge = grp,
	color = colors[grp])

# Legend
labels = ["Acetate", "FW Hydrolysate"]
elements = [PolyElement(polycolor = colors[i]) for i in 1:length(labels)]
title = "Source"
Legend(fig[1,2], elements, labels, title)

ax2 = Axis(fig[2, 1], xticks = (1:5, ["0 ml", "1 ml", "2 ml", "4 ml", "Untreated FW"]), yticks = ([1, 2], ["", ""]), title = "% of Acetate BMP in Hydrolysates")
hidespines!(ax2)
hidedecorations!(ax2)
text!(xdata, repeat(1:1, 10), text = string_bmp, align = [(:left, :top), (:left, :top), (:center, :top), (:right, :top), (:right, :top), (:left, :bottom), (:left, :bottom), (:center, :bottom), (:right, :bottom), (:right, :bottom)])

save(plotsdir("BMPs", "Hydrolyzed FW", "acet_vs_hydro_bmp_"*comp_name*".png"), fig)

sludge = "s1"
run = "r2"
timescale = "hour"


acet_kinetics = CSV.read(datadir("exp_pro", "methane_from_acetate_kinetics_"*sludge*".csv"), DataFrame)
hydro_kinetics = CSV.read(datadir("exp_pro", "methane_from_hydrolysate_kinetics_"*timescale*"_"*sludge*"_"*run*".csv"), DataFrame)

# Acetate rates are in minutes while hydrolysate in hours
acet_rates = acet_kinetics.Production_Rate
hydro_rates = hydro_kinetics.Production_Rate

# Convert Acetate rates to hours
acet_rates_hour = acet_rates.*60

# Find what percentage of acetate each hydrolysate is
acet_percent_hydro = round.((hydro_rates./acet_rates_hour).*100, digits = 4)

# Create a new table with the 2 rates and their ratio
kinetic_comp = Tables.table(hcat(acet_kinetics.Reactor_Name, acet_rates_hour, hydro_rates, acet_percent_hydro), header = [:Reactor_Name, :Acetate, :Hydrolysate, :Ratio])
CSV.write(datadir("exp_pro", "kinetics_comparison_"*sludge*"_"*run*".csv"), kinetic_comp)

# We can also do this for SMA
acet_sma_kinetics = CSV.read(datadir("exp_pro", "sma_from_acetate_"*sludge*".csv"), DataFrame)
hydro_sma_kinetics = CSV.read(datadir("exp_pro", "sma_from_hydrolysate_"*sludge*"_"*run*".csv"), DataFrame)

# Acetate rates are in minutes while hydrolysate in hours
acet_sma = acet_sma_kinetics.SMA
hydro_sma = hydro_sma_kinetics.SMA

# SMA is commonly expressed per day so convert to days
acet_sma_day = round.(acet_sma.*(60*24), digits = 3)
hydro_sma_day = round.(hydro_sma.*24, digits = 3)

# Find what percentage of acetate each hydrolysate is
acet_percent_hydro_sma = round.((hydro_sma_day./acet_sma_day).*100, digits = 4)

# Create a new table with the 2 rates and their ratio
sma_comp = Tables.table(hcat(acet_sma_kinetics.Reactor_Name, acet_sma_day, hydro_sma_day, acet_percent_hydro_sma), header = [:Reactor_Name, :Acetate, :Hydrolysate, :Ratio])
CSV.write(datadir("exp_pro", "kinetics_comparison_sma_"*sludge*"_"*run*".csv"), sma_comp)


reactors = ["Reactor 0", "Reactor 1", "Reactor 2", "Reactor 4", "Reactor FW"]
max_rate_acet = round.(vcat(max_rate_acet_0, max_rate_acet_1, max_rate_acet_2, max_rate_acet_4, max_rate_acet_fw), digits = 3)
max_rate_hydro = round.(vcat(max_rate_hydro_0, max_rate_hydro_1, max_rate_hydro_2, max_rate_hydro_4, max_rate_hydro_fw), digits = 3)

ratio = round.((max_rate_hydro./max_rate_acet)*100, digits = 3)

max_rate_comp = Tables.table(hcat(reactors, max_rate_acet, max_rate_hydro, ratio), header = [:Reactor, :Acetate, :Hydrolysate, :Ratio])
CSV.write(datadir("exp_pro", "manual_max_rate_comp_"*sludge*"_"*run*".csv"), max_rate_comp)
