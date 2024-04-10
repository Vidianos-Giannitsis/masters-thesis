using DrWatson
@quickactivate "Masters_Thesis"

using Dates
using StatsBase
using CSV, DataFrames
using LsqFit
using Plots

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
"bandicam 2024-04-08 10-40-41-360.jpg"
]

inds = 1:69
exp_meth_vol = [0, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 0.05, 0.1, 0.1, 0.05, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0.1, 0.05, 0, 0, 0.05, 0.05, 0.05, 0.1, 0.05, 0.05, 0.05, 0.05, 0.1, 0.1, 0.1, 0.05, 0.05, 0.05, 0.05, 0, 0.05, 0, 0.02, 0.02, 0.01, 0, 0, 0, 0]
meth_vol_hydro_0 = cumsum(exp_meth_vol)[end]

exp_name = "hydrolysate_0_s1_r2"
source = "Hydrolyzed FW"
sample = "Sample 0"
sludge = "Sludge 1"
run_num = "Run 2"
input_cod = 0.1


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
model_hydro_0_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
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
model_hydro_0_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
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
"bandicam 2024-04-08 10-40-41-360.jpg"
]

inds = 2:69
exp_meth_vol = [0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.05, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1, 0.05, 0.1, 0, 0, 0, 0.1, 0.1, 0.2, 0.4, 0.5, 0.2, 0.1, 0.1, 0.2, 0, 0.1, 0.2, 0.2, 0.1, 0.3, 0.1, 0.1, 0, 0.1, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.1, 0, 0.1, 0.2, 0, 0.1, 0.1, 0.2, 0.2, 0.1]
meth_vol_hydro_1 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_1_s1_r2"
source = "Hydrolyzed FW"
sample = "Sample 1"
sludge = "Sludge 1"
run_num = "Run 2"
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

if source == "Acetate"
    exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
else
    exp_data = Tables.table(hcat(exp_formatted, exp_min, exp_hour, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Minutes, :Hours, :Methane_Volume, :Cumulative_Methane_Volume])
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
model_hydro_1_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
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
model_hydro_1_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
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
"bandicam 2024-04-08 10-40-41-360.jpg"
]

inds = 4:69
exp_meth_vol = [0, 0.1, 0.1, 1.3, 0, 0.2, 0.1, 0.4, 0.5, 0.2, 0.1, 0.5, 0, 0.1, 0.2, 0.2, 0.2, 0.1, 0.05, 0.05, 0.05, 0, 0.1, 0.1, 0, 0, 0, 0.1, 0.1, 0.2, 0.05, 0, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1, 0.05, 0.05, 0, 0.05, 0.1, 0.1, 0, 0.05, 0.1, 0.1, 0.2, 0.2, 0, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0.05, 0.05]
meth_vol_hydro_2 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_2_s1_r2"
source = "Hydrolyzed FW"
sample = "Sample 2"
sludge = "Sludge 1"
run_num = "Run 2"
input_cod = 0.1


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


p0 = [100.0, 15.0, 1.0]

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
model_hydro_2_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
end


p0 = [100.0, 1.0, 0.03]

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
model_hydro_2_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
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
"bandicam 2024-04-08 10-40-41-360.jpg"
]

inds = 3:69
exp_meth_vol = [0, 0, 0, 0, 0.05, 0.1, 0.1, 0.3, 0.3, 0.3, 0.3, 0.3, 0.1, 0.2, 0.1, 0.1, 0.2, 0.1, 0.1, 0.05, 0.1, 0.2, 0.2, 0.1, 0.05, 0.1, 0.1, 0, 0, 0, 0, 0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.1, 0.1, 0.2, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.2, 0.1, 0, 0, 0.05, 0.05, 0, 0.05, 0.1]
meth_vol_hydro_4 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_4_s1_r2"
source = "Hydrolyzed FW"
sample = "Sample 4"
sludge = "Sludge 1"
run_num = "Run 2"

input_cod = 0.1


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
model_hydro_4_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
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
model_hydro_4_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
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
"bandicam 2024-04-08 10-40-41-360.jpg"
]

inds = 29:62
exp_meth_vol = [0, 0, 5, 1, 0, 0.1, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0, 0, 0.2, 0.2, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.05, 0, 0, 0, 0]
meth_vol_hydro_fw = cumsum(exp_meth_vol)[end]
exp_name = "untreated_fw_s1_r2"
source = "Untreated FW"
sample = "FW"
sludge = "Sludge 1"
run_num = "Run 2"

input_cod = 0.1


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


p0 = [75.0, 100.0, 1.0]

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
model_hydro_fw_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
end


p0 = [75.0, 1.0, 0.1]

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
model_hydro_fw_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
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
"bandicam 2024-04-08 10-40-41-360.jpg"
]

inds = 33:62
exp_meth_vol = [0, 0.1, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0, 0, 0.2, 0.2, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.05, 0, 0, 0, 0]
meth_vol_hydro_fw_corr = cumsum(exp_meth_vol)[end]
exp_name = "untreated_fw_s1_r2_corr"
source = "Untreated FW"
sample = "FW"
sludge = "Sludge 1"
run_num = "Run 2"

input_cod = 0.1


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


p0 = [75.0, 1.0, 1.0]

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
model_hydro_fw_corr_min = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
end


p0 = [75.0, 1.2, 0.1]

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
model_hydro_fw_corr_hour = vcat(sample, round.(model_params, digits = 3), round(r_squared, digits = 3))

if source == "Acetate"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

    if kinetics
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
    end
elseif source == "No_Feed"
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" /nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_sec = Plots.scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge, size = (700, 470))
    savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))
else
    bmp_cumulative_scatter_min = Plots.scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

    bmp_cumulative_scatter_hour = Plots.scatter(exp_hour, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470))
    savefig(bmp_cumulative_scatter_hour, plotsdir("BMPs", source, "cumulative_"*exp_name*"_hour.png"))

    if timescale == "hour"
	bmp_specific_methane = Plots.scatter(exp_hour, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (hour)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_hour, gompertz(exp_hour), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    elseif timescale =="min" 
	bmp_specific_methane = Plots.scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" \nUsing "*sample*" "*sludge*" "*run_num, size = (700, 470), legend = :bottomright)
	Plots.plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
	savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*"_"*timescale*".png"))
    end
end


model_fit_table_min = Tables.table(vcat(reshape(model_hydro_0_min, 1, 5), reshape(model_hydro_1_min, 1, 5), reshape(model_hydro_2_min, 1, 5), reshape(model_hydro_4_min, 1, 5), reshape(model_hydro_fw_min, 1, 5), reshape(model_hydro_fw_corr_min, 1, 5)), header = [:Sample_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_min_s1_r2.csv"), model_fit_table_min)

model_fit_table_hour = Tables.table(vcat(reshape(model_hydro_0_hour, 1, 5), reshape(model_hydro_1_hour, 1, 5), reshape(model_hydro_2_hour, 1, 5), reshape(model_hydro_4_hour, 1, 5), reshape(model_hydro_fw_hour, 1, 5), reshape(model_hydro_fw_corr_hour, 1, 5)), header = [:Sample_Name, :Production_Potential, :Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_hydrolysate_kinetics_hour_s1_r2.csv"), model_fit_table_hour)
return("../data/exp_pro/methane_from_hydrolysate_kinetics_min_s1_r2.csv")