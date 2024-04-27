colors = ["#009AFA","#E36F47","#3EA44E","#C371D2","#AC8E18"]


### Data Analysis on Hydrolysate with 0 ml ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 13-52-12-676.jpg", "bandicam 2024-04-01 15-52-12-680.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-01 18-52-12-586.jpg",
"bandicam 2024-04-01 20-52-12-578.jpg", "bandicam 2024-04-01 22-52-12-785.jpg",
"bandicam 2024-04-02 00-52-13-685.jpg", "bandicam 2024-04-02 02-52-13-485.jpg",
"bandicam 2024-04-02 04-52-13-458.jpg", "bandicam 2024-04-02 06-52-14-845.jpg",
"bandicam 2024-04-02 08-52-12-148.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
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
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg",
"bandicam 2024-04-03 14-54-49-083.jpg", "bandicam 2024-04-03 15-26-51-834.jpg",
"bandicam 2024-04-03 16-29-08-087.jpg", "bandicam 2024-04-03 17-29-08-355.jpg",
"bandicam 2024-04-03 18-29-08-352.jpg", "bandicam 2024-04-03 20-29-08-355.jpg"
]

inds = 2:49
exp_meth_vol = [0, 0.2, 0.02, 0.02, 0.01, 0.2, 0.2, 0.5, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0.05, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_0 = cumsum(exp_meth_vol)[end]

exp_name = "hydrolysate_0_s1_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 0"
sludge = "Sludge 1"
run_num = "Run 1"
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
methane_s1_r1_comp = scatter(exp_hour, cumsum(exp_meth_vol), markersize = 4, legend = :outerright, label = "Hydrolysate (0 ml mix) Exp", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", markercolor = colors[1], size = (1000, 600), legendfontsize = 12, labelfontsize = 14, tickfontsize = 12, left_margin=3Plots.mm,  bottom_margin=3Plots.mm)
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_0_hour[2:4]), label = "Hydrolysate (0 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_0_hour[5]), linecolor = colors[1])


### Data Analysis on Hydrolysate with 1 ml ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 13-52-12-676.jpg", "bandicam 2024-04-01 15-52-12-680.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-01 18-52-12-586.jpg",
"bandicam 2024-04-01 20-52-12-578.jpg", "bandicam 2024-04-01 22-52-12-785.jpg",
"bandicam 2024-04-02 00-52-13-685.jpg", "bandicam 2024-04-02 02-52-13-485.jpg",
"bandicam 2024-04-02 04-52-13-458.jpg", "bandicam 2024-04-02 06-52-14-845.jpg",
"bandicam 2024-04-02 08-52-12-148.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
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
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg",
"bandicam 2024-04-03 14-54-49-083.jpg", "bandicam 2024-04-03 15-26-51-834.jpg",
"bandicam 2024-04-03 16-29-08-087.jpg", "bandicam 2024-04-03 17-29-08-355.jpg",
"bandicam 2024-04-03 18-29-08-352.jpg", "bandicam 2024-04-03 20-29-08-355.jpg"
]

inds = 3:49
exp_meth_vol = [0, 0.5, 0.5, 0.5, 0.5, 0.5, 0, 0.2, 0.2, 0.2, 0.2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.3, 0.3, 0.3, 0.1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.4, 0.6, 0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.3, 0.2, 0.2, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_1 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_1_s1_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 1"
sludge = "Sludge 1"
run_num = "Run 1"
input_vs = 1.55

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
scatter!(methane_s1_r1_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (1 ml mix) Exp", markercolor = colors[2])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_1_hour[2:4]), label = "Hydrolysate (1 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_1_hour[5]), linecolor = colors[2])


### Data Analysis on Hydrolysate with 2 ml ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 13-52-12-676.jpg", "bandicam 2024-04-01 15-52-12-680.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-01 18-52-12-586.jpg",
"bandicam 2024-04-01 20-52-12-578.jpg", "bandicam 2024-04-01 22-52-12-785.jpg",
"bandicam 2024-04-02 00-52-13-685.jpg", "bandicam 2024-04-02 02-52-13-485.jpg",
"bandicam 2024-04-02 04-52-13-458.jpg", "bandicam 2024-04-02 06-52-14-845.jpg",
"bandicam 2024-04-02 08-52-12-148.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
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
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg",
"bandicam 2024-04-03 14-54-49-083.jpg", "bandicam 2024-04-03 15-26-51-834.jpg",
"bandicam 2024-04-03 16-29-08-087.jpg", "bandicam 2024-04-03 17-29-08-355.jpg",
"bandicam 2024-04-03 18-29-08-352.jpg", "bandicam 2024-04-03 20-29-08-355.jpg"
]

inds = 8:49
exp_meth_vol = [0, 0.5, 0.1, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.2, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_2 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_2_s1_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 2"
sludge = "Sludge 1"
run_num = "Run 1"
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

p0 = [10.0, 0.01, 1.0]

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


p0 = [10.0, 0.2, 0.03]

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
scatter!(methane_s1_r1_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (2 ml mix) Exp", markercolor = colors[3])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_2_hour[2:4]), label = "Hydrolysate (2 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_2_hour[5]), linecolor = colors[3])


### Data Analysis on Hydrolysate with 4 ml ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 13-52-12-676.jpg", "bandicam 2024-04-01 15-52-12-680.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-01 18-52-12-586.jpg",
"bandicam 2024-04-01 20-52-12-578.jpg", "bandicam 2024-04-01 22-52-12-785.jpg",
"bandicam 2024-04-02 00-52-13-685.jpg", "bandicam 2024-04-02 02-52-13-485.jpg",
"bandicam 2024-04-02 04-52-13-458.jpg", "bandicam 2024-04-02 06-52-14-845.jpg",
"bandicam 2024-04-02 08-52-12-148.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
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
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg",
"bandicam 2024-04-03 14-54-49-083.jpg", "bandicam 2024-04-03 15-26-51-834.jpg",
"bandicam 2024-04-03 16-29-08-087.jpg", "bandicam 2024-04-03 17-29-08-355.jpg",
"bandicam 2024-04-03 18-29-08-352.jpg", "bandicam 2024-04-03 20-29-08-355.jpg"
]

inds = 6:49
exp_meth_vol = [0, 0.1, 0.3, 0.2, 0.3, 0.3, 0.3, 0.3, 0.3, 0.2, 0.2, 0.2, 0.2, 0.1, 0.2, 0.2, 0.4, 0.3, 0.3, 0.3, 0.2, 0.1, 0.0, 0.0, 0.0, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.2, 0.3, 0.2, 0.1, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_4 = cumsum(exp_meth_vol)[end]
exp_name = "hydrolysate_4_s1_r1"
source = "Hydrolyzed FW"
reactor = "Reactor 4"
sludge = "Sludge 1"
run_num = "Run 1"

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
scatter!(methane_s1_r1_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (4 ml mix) Exp", markercolor = colors[4])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_4_hour[2:4]), label = "Hydrolysate (4 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_4_hour[5]), linecolor = colors[4])


### Data Analysis on Untreated FW ###


file_vec = ["bandicam 2024-04-01 11-05-53-069.jpg", "bandicam 2024-04-01 11-09-37-035.jpg",
"bandicam 2024-04-01 11-11-37-051.jpg", "bandicam 2024-04-01 11-12-37-060.jpg",
"bandicam 2024-04-01 11-13-26-776.jpg", "bandicam 2024-04-01 11-14-26-770.jpg",
"bandicam 2024-04-01 11-15-26-780.jpg", "bandicam 2024-04-01 11-21-53-098.jpg",
"bandicam 2024-04-01 11-52-12-665.jpg", "bandicam 2024-04-01 12-22-12-663.jpg",
"bandicam 2024-04-01 13-52-12-676.jpg", "bandicam 2024-04-01 15-52-12-680.jpg",
"bandicam 2024-04-01 16-52-12-699.jpg", "bandicam 2024-04-01 18-52-12-586.jpg",
"bandicam 2024-04-01 20-52-12-578.jpg", "bandicam 2024-04-01 22-52-12-785.jpg",
"bandicam 2024-04-02 00-52-13-685.jpg", "bandicam 2024-04-02 02-52-13-485.jpg",
"bandicam 2024-04-02 04-52-13-458.jpg", "bandicam 2024-04-02 06-52-14-845.jpg",
"bandicam 2024-04-02 08-52-12-148.jpg", "bandicam 2024-04-02 10-54-01-344.jpg",
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
"bandicam 2024-04-03 13-54-03-505.jpg", "bandicam 2024-04-03 14-24-03-564.jpg",
"bandicam 2024-04-03 14-54-49-083.jpg", "bandicam 2024-04-03 15-26-51-834.jpg",
"bandicam 2024-04-03 16-29-08-087.jpg", "bandicam 2024-04-03 17-29-08-355.jpg",
"bandicam 2024-04-03 18-29-08-352.jpg", "bandicam 2024-04-03 20-29-08-355.jpg"
]

inds = 22:50
exp_meth_vol = [0, 0.2, 0, 0.1, 0.1, 0, 0, 0, 0.1, 0.1, 0, 0.1, 0.2, 0.1, 0.1, 0.1, 0.0, 0.1, 0.2, 0.1, 0.2, 0.1, 0.1, 0, 0, 0, 0, 0, 0]
meth_vol_hydro_fw = cumsum(exp_meth_vol)[end]
exp_name = "untreated_fw_s1_r1"
source = "Untreated FW"
reactor = "FW 1"
sludge = "Sludge 1"
run_num = "Run 1"

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
scatter!(methane_s1_r1_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Untreated FW Exp", markercolor = colors[5])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_fw_hour[2:4]), label = "Untreated FW Theoretical\n with "*L"R^2 = "*string(model_hydro_fw_hour[5]), linecolor = colors[5])

savefig(methane_s1_r1_comp, plotsdir("BMPs", "methane_s1_r1_comp.svg"))

colors = ["#009AFA","#E36F47","#3EA44E","#C371D2","#AC8E18"]


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
methane_s1_r2_comp = scatter(exp_hour, cumsum(exp_meth_vol), markersize = 4, legend = :outerright, label = "Hydrolysate (0 ml mix) Exp", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", markercolor = colors[1], size = (1000, 600), legendfontsize = 12, labelfontsize = 14, tickfontsize = 12, left_margin=3Plots.mm,  bottom_margin=3Plots.mm, yticks = 0:2:10)
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_0_hour[2:4]), label = "Hydrolysate (0 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_0_hour[5]), linecolor = colors[1])


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
scatter!(methane_s1_r2_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (1 ml mix) Exp", markercolor = colors[2])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_1_hour[2:4]), label = "Hydrolysate (1 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_1_hour[5]), linecolor = colors[2])


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
scatter!(methane_s1_r2_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (2 ml mix) Exp", markercolor = colors[3])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_2_hour[2:4]), label = "Hydrolysate (2 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_2_hour[5]), linecolor = colors[3])


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
scatter!(methane_s1_r2_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (4 ml mix) Exp", markercolor = colors[4])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_4_hour[2:4]), label = "Hydrolysate (4 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_4_hour[5]), linecolor = colors[4])


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

scatter!(methane_s1_r2_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Untreated FW Exp", markercolor = colors[5])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_fw_hour[2:4]), label = "Untreated FW Theoretical\n with "*L"R^2 = "*string(model_hydro_fw_hour[5]), linecolor = colors[5])

savefig(methane_s1_r2_comp, plotsdir("BMPs", "methane_s1_r2_comp.svg"))

colors = ["#009AFA","#E36F47","#3EA44E","#C371D2","#AC8E18"]


### Data Analysis on Hydrolysate with 0 ml ###



file_vec = ["bandicam 2024-04-10 21-34-31-153.jpg", "bandicam 2024-04-10 22-34-31-192.jpg",
"bandicam 2024-04-10 23-34-31-838.jpg", "bandicam 2024-04-11 00-34-31-881.jpg",
"bandicam 2024-04-11 01-34-31-928.jpg", "bandicam 2024-04-11 02-34-31-966.jpg",
"bandicam 2024-04-11 03-34-32-016.jpg", "bandicam 2024-04-11 04-34-31-806.jpg",
"bandicam 2024-04-11 05-34-31-785.jpg", "bandicam 2024-04-11 06-34-31-782.jpg",
"bandicam 2024-04-11 07-34-31-795.jpg", "bandicam 2024-04-11 08-34-31-824.jpg",
"bandicam 2024-04-11 09-34-31-841.jpg", "bandicam 2024-04-11 10-34-31-868.jpg",
"bandicam 2024-04-11 11-34-31-882.jpg", "bandicam 2024-04-11 12-34-31-908.jpg",
"bandicam 2024-04-11 13-34-32-286.jpg", "bandicam 2024-04-11 14-34-32-409.jpg",
"bandicam 2024-04-11 15-34-32-463.jpg", "bandicam 2024-04-11 16-34-32-494.jpg",
"bandicam 2024-04-11 17-34-33-592.jpg", "bandicam 2024-04-11 18-34-33-623.jpg",
"bandicam 2024-04-11 19-34-33-663.jpg", "bandicam 2024-04-11 20-34-33-682.jpg",
"bandicam 2024-04-11 21-34-33-727.jpg", "bandicam 2024-04-11 22-34-33-274.jpg",
"bandicam 2024-04-11 23-34-33-122.jpg", "bandicam 2024-04-12 00-34-33-121.jpg",
"bandicam 2024-04-12 01-34-33-146.jpg", "bandicam 2024-04-12 02-34-33-135.jpg",
"bandicam 2024-04-12 03-34-33-141.jpg", "bandicam 2024-04-12 04-34-33-139.jpg",
"bandicam 2024-04-12 05-34-33-134.jpg", "bandicam 2024-04-12 06-34-33-141.jpg",
"bandicam 2024-04-12 07-34-33-373.jpg", "bandicam 2024-04-12 08-34-33-615.jpg",
"bandicam 2024-04-12 09-34-33-682.jpg", "bandicam 2024-04-12 10-34-33-714.jpg",
"bandicam 2024-04-12 11-34-33-716.jpg", "bandicam 2024-04-12 12-34-33-715.jpg",
"bandicam 2024-04-12 13-34-33-713.jpg", "bandicam 2024-04-12 14-34-33-718.jpg",
"bandicam 2024-04-12 15-34-33-716.jpg", "bandicam 2024-04-12 16-34-34-089.jpg",
"bandicam 2024-04-12 17-34-34-412.jpg", "bandicam 2024-04-12 18-34-34-419.jpg",
"bandicam 2024-04-12 19-34-34-416.jpg", "bandicam 2024-04-12 20-34-34-424.jpg",
"bandicam 2024-04-12 21-34-34-421.jpg", "bandicam 2024-04-12 22-34-34-427.jpg",
"bandicam 2024-04-12 23-34-34-866.jpg", "bandicam 2024-04-13 00-34-34-864.jpg",
"bandicam 2024-04-13 01-34-34-867.jpg", "bandicam 2024-04-13 02-34-34-886.jpg",
"bandicam 2024-04-13 03-34-34-887.jpg", "bandicam 2024-04-13 04-34-34-893.jpg",
"bandicam 2024-04-13 05-34-34-882.jpg", "bandicam 2024-04-13 06-34-34-888.jpg",
"bandicam 2024-04-13 07-34-34-885.jpg", "bandicam 2024-04-13 08-34-34-882.jpg",
"bandicam 2024-04-13 09-34-34-889.jpg", "bandicam 2024-04-13 10-34-35-226.jpg",
"bandicam 2024-04-13 11-34-35-631.jpg", "bandicam 2024-04-13 12-34-35-732.jpg",
"bandicam 2024-04-13 13-34-35-813.jpg", "bandicam 2024-04-13 14-34-35-863.jpg",
"bandicam 2024-04-13 15-34-35-893.jpg", "bandicam 2024-04-13 16-34-35-945.jpg",
"bandicam 2024-04-13 17-34-36-181.jpg", "bandicam 2024-04-13 18-34-36-188.jpg",
"bandicam 2024-04-13 19-34-36-196.jpg", "bandicam 2024-04-13 20-34-36-289.jpg",
"bandicam 2024-04-13 21-34-36-301.jpg", "bandicam 2024-04-13 22-34-36-318.jpg",
"bandicam 2024-04-13 23-34-36-316.jpg", "bandicam 2024-04-14 00-34-36-323.jpg",
"bandicam 2024-04-14 01-34-36-320.jpg", "bandicam 2024-04-14 02-34-36-317.jpg",
"bandicam 2024-04-14 03-34-36-325.jpg", "bandicam 2024-04-14 04-34-36-504.jpg",
"bandicam 2024-04-14 05-34-36-867.jpg", "bandicam 2024-04-14 06-34-37-014.jpg",
"bandicam 2024-04-14 07-34-37-065.jpg", "bandicam 2024-04-14 08-34-37-119.jpg",
"bandicam 2024-04-14 09-34-37-154.jpg", "bandicam 2024-04-14 10-34-37-196.jpg",
"bandicam 2024-04-14 11-34-37-229.jpg", "bandicam 2024-04-14 12-34-37-671.jpg",
"bandicam 2024-04-14 13-34-37-699.jpg", "bandicam 2024-04-14 14-34-37-677.jpg",
"bandicam 2024-04-14 15-34-37-676.jpg", "bandicam 2024-04-14 16-34-37-705.jpg",
"bandicam 2024-04-14 17-34-37-893.jpg", "bandicam 2024-04-14 18-34-37-890.jpg",
"bandicam 2024-04-14 19-34-37-971.jpg", "bandicam 2024-04-14 20-34-37-904.jpg",
"bandicam 2024-04-14 21-34-37-899.jpg", "bandicam 2024-04-14 22-34-37-898.jpg",
"bandicam 2024-04-14 23-34-38-497.jpg", "bandicam 2024-04-15 00-34-38-599.jpg",
"bandicam 2024-04-15 01-34-38-640.jpg", "bandicam 2024-04-15 02-34-38-641.jpg",
"bandicam 2024-04-15 03-34-38-650.jpg", "bandicam 2024-04-15 04-34-38-646.jpg",
"bandicam 2024-04-15 05-34-38-657.jpg", "bandicam 2024-04-15 06-34-38-653.jpg",
"bandicam 2024-04-15 07-34-38-648.jpg", "bandicam 2024-04-15 08-34-38-862.jpg",
"bandicam 2024-04-15 09-34-38-937.jpg", "bandicam 2024-04-15 10-34-38-979.jpg"
]

inds = 7:104
exp_meth_vol = [0.5, 0.5, 0.5, 0.5, 1, 1, 1.5, 0.5, 0.5, 0.5, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.2, 0.2, 0.5, 0.5, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, 1, 1, 0.5, 1, 1, 0.5, 0.5, 0.5, 1, 1, 0.5, 1, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0, 0, 0, 0, 0, 0]
meth_vol_acet_0 = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_0_s2_2"
source = "Acetate"
reactor = "Reactor 0"
sludge = "Sludge 2"
run_num = "Run 2"
input_vs = 4.2
p0 = [90.0, 20.0, 1.0]


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

max_rate_acet_0_2 = max_manual_rate


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

meth_vol_blank = exp_meth_vol


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
exp_meth_vol = [0, 0, 0.5, 0.6, 0.6, 0.7, 0.8, 0.7, 0.6, 0.7, 1, 0.9, 0.7, 0.8, 0.8, 0.7, 1, 1, 1, 0.8, 0.7, 1, 0.7, 0.7, 0.6, 1, 0.8, 1.5, 0.7, 1, 0.9, 0.8, 0.8, 1, 1, 1, 1, 1, 1, 1, 0.9, 1.2, 1, 0.9, 1, 0.8, 0.7, 0.8, 0.5, 0.5, 0.8, 0.5, 0.3, 0.5, 1.3, 1.2, 1, 1, 1, 0.5, 1, 1.2, 1, 1, 1, 1, 0.5, 1, 0.5, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.9, 0.8, 0.7, 0.8, 0.6, 0.7, 0.9, 0.7, 0.7, 0.6, 0.5, 0.5, 0.5, 0.3, 0.2, 0.3, 0.4, 0.3, 0.2, 0.4, 0.4, 0.5, 0.3, 0.3, 0.3, 0.3, 0.4, 0.3, 0.3, 0.3, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0]

meth_vol_blank_complete = vcat(meth_vol_blank, zeros(length(exp_meth_vol) - length(meth_vol_blank)))
meth_vol_diff = round.(exp_meth_vol .- meth_vol_blank_complete, digits = 1)
exp_meth_vol = [meth_vol_diff[i] < 0 ? meth_vol_diff[i] = 0.0 : meth_vol_diff[i] for i in 1:length(meth_vol_diff)]

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
methane_s2_r1_comp = scatter(exp_hour, cumsum(exp_meth_vol), markersize = 4, legend = :outerright, label = "Hydrolysate (0 ml mix) Exp", xlabel = "Time (hour)", ylabel = "Cumulative Methane Volume (mL)", markercolor = colors[1], size = (1000, 600), legendfontsize = 12, labelfontsize = 14, tickfontsize = 12, left_margin=3Plots.mm,  bottom_margin=3Plots.mm, yticks = [0, 5, 10, 15, 20, 25, 30, 35])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_0_hour[2:4]), label = "Hydrolysate (0 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_0_hour[5]), linecolor = colors[1])


### Data Analysis on Hydrolysate with 1 ml ###



file_vec = ["bandicam 2024-04-10 21-34-31-153.jpg", "bandicam 2024-04-10 22-34-31-192.jpg",
"bandicam 2024-04-10 23-34-31-838.jpg", "bandicam 2024-04-11 00-34-31-881.jpg",
"bandicam 2024-04-11 01-34-31-928.jpg", "bandicam 2024-04-11 02-34-31-966.jpg",
"bandicam 2024-04-11 03-34-32-016.jpg", "bandicam 2024-04-11 04-34-31-806.jpg",
"bandicam 2024-04-11 05-34-31-785.jpg", "bandicam 2024-04-11 06-34-31-782.jpg",
"bandicam 2024-04-11 07-34-31-795.jpg", "bandicam 2024-04-11 08-34-31-824.jpg",
"bandicam 2024-04-11 09-34-31-841.jpg", "bandicam 2024-04-11 10-34-31-868.jpg",
"bandicam 2024-04-11 11-34-31-882.jpg", "bandicam 2024-04-11 12-34-31-908.jpg",
"bandicam 2024-04-11 13-34-32-286.jpg", "bandicam 2024-04-11 14-34-32-409.jpg",
"bandicam 2024-04-11 15-34-32-463.jpg", "bandicam 2024-04-11 16-34-32-494.jpg",
"bandicam 2024-04-11 17-34-33-592.jpg", "bandicam 2024-04-11 18-34-33-623.jpg",
"bandicam 2024-04-11 19-34-33-663.jpg", "bandicam 2024-04-11 20-34-33-682.jpg",
"bandicam 2024-04-11 21-34-33-727.jpg", "bandicam 2024-04-11 22-34-33-274.jpg",
"bandicam 2024-04-11 23-34-33-122.jpg", "bandicam 2024-04-12 00-34-33-121.jpg",
"bandicam 2024-04-12 01-34-33-146.jpg", "bandicam 2024-04-12 02-34-33-135.jpg",
"bandicam 2024-04-12 03-34-33-141.jpg", "bandicam 2024-04-12 04-34-33-139.jpg",
"bandicam 2024-04-12 05-34-33-134.jpg", "bandicam 2024-04-12 06-34-33-141.jpg",
"bandicam 2024-04-12 07-34-33-373.jpg", "bandicam 2024-04-12 08-34-33-615.jpg",
"bandicam 2024-04-12 09-34-33-682.jpg", "bandicam 2024-04-12 10-34-33-714.jpg",
"bandicam 2024-04-12 11-34-33-716.jpg", "bandicam 2024-04-12 12-34-33-715.jpg",
"bandicam 2024-04-12 13-34-33-713.jpg", "bandicam 2024-04-12 14-34-33-718.jpg",
"bandicam 2024-04-12 15-34-33-716.jpg", "bandicam 2024-04-12 16-34-34-089.jpg",
"bandicam 2024-04-12 17-34-34-412.jpg", "bandicam 2024-04-12 18-34-34-419.jpg",
"bandicam 2024-04-12 19-34-34-416.jpg", "bandicam 2024-04-12 20-34-34-424.jpg",
"bandicam 2024-04-12 21-34-34-421.jpg", "bandicam 2024-04-12 22-34-34-427.jpg",
"bandicam 2024-04-12 23-34-34-866.jpg", "bandicam 2024-04-13 00-34-34-864.jpg",
"bandicam 2024-04-13 01-34-34-867.jpg", "bandicam 2024-04-13 02-34-34-886.jpg",
"bandicam 2024-04-13 03-34-34-887.jpg", "bandicam 2024-04-13 04-34-34-893.jpg",
"bandicam 2024-04-13 05-34-34-882.jpg", "bandicam 2024-04-13 06-34-34-888.jpg",
"bandicam 2024-04-13 07-34-34-885.jpg", "bandicam 2024-04-13 08-34-34-882.jpg",
"bandicam 2024-04-13 09-34-34-889.jpg", "bandicam 2024-04-13 10-34-35-226.jpg",
"bandicam 2024-04-13 11-34-35-631.jpg", "bandicam 2024-04-13 12-34-35-732.jpg",
"bandicam 2024-04-13 13-34-35-813.jpg", "bandicam 2024-04-13 14-34-35-863.jpg",
"bandicam 2024-04-13 15-34-35-893.jpg", "bandicam 2024-04-13 16-34-35-945.jpg",
"bandicam 2024-04-13 17-34-36-181.jpg", "bandicam 2024-04-13 18-34-36-188.jpg",
"bandicam 2024-04-13 19-34-36-196.jpg", "bandicam 2024-04-13 20-34-36-289.jpg",
"bandicam 2024-04-13 21-34-36-301.jpg", "bandicam 2024-04-13 22-34-36-318.jpg",
"bandicam 2024-04-13 23-34-36-316.jpg", "bandicam 2024-04-14 00-34-36-323.jpg",
"bandicam 2024-04-14 01-34-36-320.jpg", "bandicam 2024-04-14 02-34-36-317.jpg",
"bandicam 2024-04-14 03-34-36-325.jpg", "bandicam 2024-04-14 04-34-36-504.jpg",
"bandicam 2024-04-14 05-34-36-867.jpg", "bandicam 2024-04-14 06-34-37-014.jpg",
"bandicam 2024-04-14 07-34-37-065.jpg", "bandicam 2024-04-14 08-34-37-119.jpg",
"bandicam 2024-04-14 09-34-37-154.jpg", "bandicam 2024-04-14 10-34-37-196.jpg",
"bandicam 2024-04-14 11-34-37-229.jpg", "bandicam 2024-04-14 12-34-37-671.jpg",
"bandicam 2024-04-14 13-34-37-699.jpg", "bandicam 2024-04-14 14-34-37-677.jpg",
"bandicam 2024-04-14 15-34-37-676.jpg", "bandicam 2024-04-14 16-34-37-705.jpg",
"bandicam 2024-04-14 17-34-37-893.jpg", "bandicam 2024-04-14 18-34-37-890.jpg",
"bandicam 2024-04-14 19-34-37-971.jpg", "bandicam 2024-04-14 20-34-37-904.jpg",
"bandicam 2024-04-14 21-34-37-899.jpg", "bandicam 2024-04-14 22-34-37-898.jpg",
"bandicam 2024-04-14 23-34-38-497.jpg", "bandicam 2024-04-15 00-34-38-599.jpg",
"bandicam 2024-04-15 01-34-38-640.jpg", "bandicam 2024-04-15 02-34-38-641.jpg",
"bandicam 2024-04-15 03-34-38-650.jpg", "bandicam 2024-04-15 04-34-38-646.jpg",
"bandicam 2024-04-15 05-34-38-657.jpg", "bandicam 2024-04-15 06-34-38-653.jpg",
"bandicam 2024-04-15 07-34-38-648.jpg", "bandicam 2024-04-15 08-34-38-862.jpg",
"bandicam 2024-04-15 09-34-38-937.jpg", "bandicam 2024-04-15 10-34-38-979.jpg"
]

inds = 2:75
exp_meth_vol = [0, 0.2, 1, 1.5, 1, 1, 1, 1, 1.5, 1.5, 1, 1, 1, 1, 1.5, 1.5, 1, 1, 1.5, 1, 1, 1, 1, 1, 1, 1, 1.5, 1, 1, 1, 1, 1, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1, 1.5, 1.5, 1.5, 1.5, 1, 1, 1.5, 1.5, 1, 1, 1.5, 1, 1.5, 1, 1, 1, 1.5, 1, 1, 1, 1.5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0]
meth_vol_acet_1 = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_1_s2_2"
source = "Acetate"
reactor = "Reactor 1"
sludge = "Sludge 2"
run_num = "Run 2"
input_vs = 4.2
p0 = [90.0, 20.0, 1.0]


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

max_rate_acet_1_2 = max_manual_rate


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

meth_vol_blank = exp_meth_vol


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
exp_meth_vol = [0, 0.2, 0.7, 0, 0, 0, 0, 0, 0.2, 0.6, 1.7, 1.6, 1.5, 1.3, 1.4, 1.3, 1.3, 1.4, 1.3, 1.2, 1.2, 1.2, 1.1, 1.2, 1.4, 1.8, 1.5, 1.9, 1.2, 1.5, 1.1, 1, 1.3, 1.7, 2, 1.6, 1.4, 1.6, 1.5, 1.3, 1.5, 1.5, 1.5, 1.5, 1.7, 1.7, 1.7, 1.7, 1.8, 1.7, 1.7, 1.8, 1.8, 1.6, 1.7, 1.6, 1.7, 1.8, 1.7, 1, 0.5, 0.5, 1, 1.2, 1, 1, 1, 1, 1, 1.2, 0.7, 0.7, 0.7, 0.6, 0.8, 0.7, 0.5, 0.4, 0.5, 0.6, 0.5, 0.6, 0.5, 0.5, 0.4, 0.8, 0.6, 0.5, 0, 0.3, 0.3, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.3, 0.3, 0.2, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0, 0]

meth_vol_blank_complete = vcat(meth_vol_blank, zeros(length(exp_meth_vol) - length(meth_vol_blank)))
meth_vol_diff = round.(exp_meth_vol .- meth_vol_blank_complete, digits = 1)
exp_meth_vol = [meth_vol_diff[i] < 0 ? meth_vol_diff[i] = 0.0 : meth_vol_diff[i] for i in 1:length(meth_vol_diff)]

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
scatter!(methane_s2_r1_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (1 ml mix) Exp", markercolor = colors[2])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_1_hour[2:4]), label = "Hydrolysate (1 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_1_hour[5]), linecolor = colors[2])


### Data Analysis on Hydrolysate with 2 ml ###



file_vec = ["bandicam 2024-04-10 21-34-31-153.jpg", "bandicam 2024-04-10 22-34-31-192.jpg",
"bandicam 2024-04-10 23-34-31-838.jpg", "bandicam 2024-04-11 00-34-31-881.jpg",
"bandicam 2024-04-11 01-34-31-928.jpg", "bandicam 2024-04-11 02-34-31-966.jpg",
"bandicam 2024-04-11 03-34-32-016.jpg", "bandicam 2024-04-11 04-34-31-806.jpg",
"bandicam 2024-04-11 05-34-31-785.jpg", "bandicam 2024-04-11 06-34-31-782.jpg",
"bandicam 2024-04-11 07-34-31-795.jpg", "bandicam 2024-04-11 08-34-31-824.jpg",
"bandicam 2024-04-11 09-34-31-841.jpg", "bandicam 2024-04-11 10-34-31-868.jpg",
"bandicam 2024-04-11 11-34-31-882.jpg", "bandicam 2024-04-11 12-34-31-908.jpg",
"bandicam 2024-04-11 13-34-32-286.jpg", "bandicam 2024-04-11 14-34-32-409.jpg",
"bandicam 2024-04-11 15-34-32-463.jpg", "bandicam 2024-04-11 16-34-32-494.jpg",
"bandicam 2024-04-11 17-34-33-592.jpg", "bandicam 2024-04-11 18-34-33-623.jpg",
"bandicam 2024-04-11 19-34-33-663.jpg", "bandicam 2024-04-11 20-34-33-682.jpg",
"bandicam 2024-04-11 21-34-33-727.jpg", "bandicam 2024-04-11 22-34-33-274.jpg",
"bandicam 2024-04-11 23-34-33-122.jpg", "bandicam 2024-04-12 00-34-33-121.jpg",
"bandicam 2024-04-12 01-34-33-146.jpg", "bandicam 2024-04-12 02-34-33-135.jpg",
"bandicam 2024-04-12 03-34-33-141.jpg", "bandicam 2024-04-12 04-34-33-139.jpg",
"bandicam 2024-04-12 05-34-33-134.jpg", "bandicam 2024-04-12 06-34-33-141.jpg",
"bandicam 2024-04-12 07-34-33-373.jpg", "bandicam 2024-04-12 08-34-33-615.jpg",
"bandicam 2024-04-12 09-34-33-682.jpg", "bandicam 2024-04-12 10-34-33-714.jpg",
"bandicam 2024-04-12 11-34-33-716.jpg", "bandicam 2024-04-12 12-34-33-715.jpg",
"bandicam 2024-04-12 13-34-33-713.jpg", "bandicam 2024-04-12 14-34-33-718.jpg",
"bandicam 2024-04-12 15-34-33-716.jpg", "bandicam 2024-04-12 16-34-34-089.jpg",
"bandicam 2024-04-12 17-34-34-412.jpg", "bandicam 2024-04-12 18-34-34-419.jpg",
"bandicam 2024-04-12 19-34-34-416.jpg", "bandicam 2024-04-12 20-34-34-424.jpg",
"bandicam 2024-04-12 21-34-34-421.jpg", "bandicam 2024-04-12 22-34-34-427.jpg",
"bandicam 2024-04-12 23-34-34-866.jpg", "bandicam 2024-04-13 00-34-34-864.jpg",
"bandicam 2024-04-13 01-34-34-867.jpg", "bandicam 2024-04-13 02-34-34-886.jpg",
"bandicam 2024-04-13 03-34-34-887.jpg", "bandicam 2024-04-13 04-34-34-893.jpg",
"bandicam 2024-04-13 05-34-34-882.jpg", "bandicam 2024-04-13 06-34-34-888.jpg",
"bandicam 2024-04-13 07-34-34-885.jpg", "bandicam 2024-04-13 08-34-34-882.jpg",
"bandicam 2024-04-13 09-34-34-889.jpg", "bandicam 2024-04-13 10-34-35-226.jpg",
"bandicam 2024-04-13 11-34-35-631.jpg", "bandicam 2024-04-13 12-34-35-732.jpg",
"bandicam 2024-04-13 13-34-35-813.jpg", "bandicam 2024-04-13 14-34-35-863.jpg",
"bandicam 2024-04-13 15-34-35-893.jpg", "bandicam 2024-04-13 16-34-35-945.jpg",
"bandicam 2024-04-13 17-34-36-181.jpg", "bandicam 2024-04-13 18-34-36-188.jpg",
"bandicam 2024-04-13 19-34-36-196.jpg", "bandicam 2024-04-13 20-34-36-289.jpg",
"bandicam 2024-04-13 21-34-36-301.jpg", "bandicam 2024-04-13 22-34-36-318.jpg",
"bandicam 2024-04-13 23-34-36-316.jpg", "bandicam 2024-04-14 00-34-36-323.jpg",
"bandicam 2024-04-14 01-34-36-320.jpg", "bandicam 2024-04-14 02-34-36-317.jpg",
"bandicam 2024-04-14 03-34-36-325.jpg", "bandicam 2024-04-14 04-34-36-504.jpg",
"bandicam 2024-04-14 05-34-36-867.jpg", "bandicam 2024-04-14 06-34-37-014.jpg",
"bandicam 2024-04-14 07-34-37-065.jpg", "bandicam 2024-04-14 08-34-37-119.jpg",
"bandicam 2024-04-14 09-34-37-154.jpg", "bandicam 2024-04-14 10-34-37-196.jpg",
"bandicam 2024-04-14 11-34-37-229.jpg", "bandicam 2024-04-14 12-34-37-671.jpg",
"bandicam 2024-04-14 13-34-37-699.jpg", "bandicam 2024-04-14 14-34-37-677.jpg",
"bandicam 2024-04-14 15-34-37-676.jpg", "bandicam 2024-04-14 16-34-37-705.jpg",
"bandicam 2024-04-14 17-34-37-893.jpg", "bandicam 2024-04-14 18-34-37-890.jpg",
"bandicam 2024-04-14 19-34-37-971.jpg", "bandicam 2024-04-14 20-34-37-904.jpg",
"bandicam 2024-04-14 21-34-37-899.jpg", "bandicam 2024-04-14 22-34-37-898.jpg",
"bandicam 2024-04-14 23-34-38-497.jpg", "bandicam 2024-04-15 00-34-38-599.jpg",
"bandicam 2024-04-15 01-34-38-640.jpg", "bandicam 2024-04-15 02-34-38-641.jpg",
"bandicam 2024-04-15 03-34-38-650.jpg", "bandicam 2024-04-15 04-34-38-646.jpg",
"bandicam 2024-04-15 05-34-38-657.jpg", "bandicam 2024-04-15 06-34-38-653.jpg",
"bandicam 2024-04-15 07-34-38-648.jpg", "bandicam 2024-04-15 08-34-38-862.jpg",
"bandicam 2024-04-15 09-34-38-937.jpg", "bandicam 2024-04-15 10-34-38-979.jpg"
]

inds = 1:90
exp_meth_vol = [0.5, 0.5, 0.3, 0.3, 0.5, 0.8, 0.8, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, 1, 1.5, 1, 1.5, 1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.1, 0.1, 0.5, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
meth_vol_acet_2 = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_2_s2_2"
source = "Acetate"
reactor = "Reactor 2"
sludge = "Sludge 2"
run_num = "Run 2"
input_vs = 4.2
p0 = [90.0, 20.0, 1.0]


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

max_rate_acet_2_2 = max_manual_rate


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

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
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

meth_vol_blank = exp_meth_vol


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

inds = 66:188
exp_meth_vol = vcat([0, 0.1, 0, 0.2, 0.2, 0.2, 0.5, 0.3, 0.2, 0, 0.2, 0, 0, 0.3, 1.1, 0, 0.7, 1.1, 0, 1.2, 0, 0.1, 1.05, 0, 1.2, 0, 1.5, 1.5, 1.5, 1.4, 1.2, 1.4, 1.3, 1.2, 1.4, 1.5, 1.5, 1.6, 1.7, 1.2, 1.2, 1.3, 1.1, 1.4, 1.3, 1.2, 1.6, 1.4, 1.5, 1.4, 1.2, 1.4, 1.3, 1.7, 1.2, 1.5, 1.4, 1.5, 1.5, 1.4, 1.3, 1.4, 1.2, 1.4, 1.3, 1.3, 1.2, 1.2, 1.4, 1.4, 1.2, 1.2, 1.1, 1, 1.1, 1.1, 1.2, 1.1, 1.1, 1.2, 1.3, 1.1, 0.7, 0.7, 0.8, 0.7, 0.5, 0.4, 0.6, 0.4, 0.2, 0.1, 0.3, 0.3, 0.3, 0.2, 0.2, 0.3, 0.1, 0.1, 0.2, 0.3, 0.3, 0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0], zeros(5))

meth_vol_blank_complete = vcat(meth_vol_blank, zeros(length(exp_meth_vol) - length(meth_vol_blank)))
meth_vol_diff = round.(exp_meth_vol .- meth_vol_blank_complete, digits = 1)
exp_meth_vol = [meth_vol_diff[i] < 0 ? meth_vol_diff[i] = 0.0 : meth_vol_diff[i] for i in 1:length(meth_vol_diff)]

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
scatter!(methane_s2_r1_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (2 ml mix) Exp", markercolor = colors[3])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_2_hour[2:4]), label = "Hydrolysate (2 ml mix) Theoretical\n with "*L"R^2 = "*string(model_hydro_2_hour[5]), linecolor = colors[3])


### Data Analysis on Hydrolysate with 4 ml ###



file_vec = ["bandicam 2024-04-10 21-34-31-153.jpg", "bandicam 2024-04-10 22-34-31-192.jpg",
"bandicam 2024-04-10 23-34-31-838.jpg", "bandicam 2024-04-11 00-34-31-881.jpg",
"bandicam 2024-04-11 01-34-31-928.jpg", "bandicam 2024-04-11 02-34-31-966.jpg",
"bandicam 2024-04-11 03-34-32-016.jpg", "bandicam 2024-04-11 04-34-31-806.jpg",
"bandicam 2024-04-11 05-34-31-785.jpg", "bandicam 2024-04-11 06-34-31-782.jpg",
"bandicam 2024-04-11 07-34-31-795.jpg", "bandicam 2024-04-11 08-34-31-824.jpg",
"bandicam 2024-04-11 09-34-31-841.jpg", "bandicam 2024-04-11 10-34-31-868.jpg",
"bandicam 2024-04-11 11-34-31-882.jpg", "bandicam 2024-04-11 12-34-31-908.jpg",
"bandicam 2024-04-11 13-34-32-286.jpg", "bandicam 2024-04-11 14-34-32-409.jpg",
"bandicam 2024-04-11 15-34-32-463.jpg", "bandicam 2024-04-11 16-34-32-494.jpg",
"bandicam 2024-04-11 17-34-33-592.jpg", "bandicam 2024-04-11 18-34-33-623.jpg",
"bandicam 2024-04-11 19-34-33-663.jpg", "bandicam 2024-04-11 20-34-33-682.jpg",
"bandicam 2024-04-11 21-34-33-727.jpg", "bandicam 2024-04-11 22-34-33-274.jpg",
"bandicam 2024-04-11 23-34-33-122.jpg", "bandicam 2024-04-12 00-34-33-121.jpg",
"bandicam 2024-04-12 01-34-33-146.jpg", "bandicam 2024-04-12 02-34-33-135.jpg",
"bandicam 2024-04-12 03-34-33-141.jpg", "bandicam 2024-04-12 04-34-33-139.jpg",
"bandicam 2024-04-12 05-34-33-134.jpg", "bandicam 2024-04-12 06-34-33-141.jpg",
"bandicam 2024-04-12 07-34-33-373.jpg", "bandicam 2024-04-12 08-34-33-615.jpg",
"bandicam 2024-04-12 09-34-33-682.jpg", "bandicam 2024-04-12 10-34-33-714.jpg",
"bandicam 2024-04-12 11-34-33-716.jpg", "bandicam 2024-04-12 12-34-33-715.jpg",
"bandicam 2024-04-12 13-34-33-713.jpg", "bandicam 2024-04-12 14-34-33-718.jpg",
"bandicam 2024-04-12 15-34-33-716.jpg", "bandicam 2024-04-12 16-34-34-089.jpg",
"bandicam 2024-04-12 17-34-34-412.jpg", "bandicam 2024-04-12 18-34-34-419.jpg",
"bandicam 2024-04-12 19-34-34-416.jpg", "bandicam 2024-04-12 20-34-34-424.jpg",
"bandicam 2024-04-12 21-34-34-421.jpg", "bandicam 2024-04-12 22-34-34-427.jpg",
"bandicam 2024-04-12 23-34-34-866.jpg", "bandicam 2024-04-13 00-34-34-864.jpg",
"bandicam 2024-04-13 01-34-34-867.jpg", "bandicam 2024-04-13 02-34-34-886.jpg",
"bandicam 2024-04-13 03-34-34-887.jpg", "bandicam 2024-04-13 04-34-34-893.jpg",
"bandicam 2024-04-13 05-34-34-882.jpg", "bandicam 2024-04-13 06-34-34-888.jpg",
"bandicam 2024-04-13 07-34-34-885.jpg", "bandicam 2024-04-13 08-34-34-882.jpg",
"bandicam 2024-04-13 09-34-34-889.jpg", "bandicam 2024-04-13 10-34-35-226.jpg",
"bandicam 2024-04-13 11-34-35-631.jpg", "bandicam 2024-04-13 12-34-35-732.jpg",
"bandicam 2024-04-13 13-34-35-813.jpg", "bandicam 2024-04-13 14-34-35-863.jpg",
"bandicam 2024-04-13 15-34-35-893.jpg", "bandicam 2024-04-13 16-34-35-945.jpg",
"bandicam 2024-04-13 17-34-36-181.jpg", "bandicam 2024-04-13 18-34-36-188.jpg",
"bandicam 2024-04-13 19-34-36-196.jpg", "bandicam 2024-04-13 20-34-36-289.jpg",
"bandicam 2024-04-13 21-34-36-301.jpg", "bandicam 2024-04-13 22-34-36-318.jpg",
"bandicam 2024-04-13 23-34-36-316.jpg", "bandicam 2024-04-14 00-34-36-323.jpg",
"bandicam 2024-04-14 01-34-36-320.jpg", "bandicam 2024-04-14 02-34-36-317.jpg",
"bandicam 2024-04-14 03-34-36-325.jpg", "bandicam 2024-04-14 04-34-36-504.jpg",
"bandicam 2024-04-14 05-34-36-867.jpg", "bandicam 2024-04-14 06-34-37-014.jpg",
"bandicam 2024-04-14 07-34-37-065.jpg", "bandicam 2024-04-14 08-34-37-119.jpg",
"bandicam 2024-04-14 09-34-37-154.jpg", "bandicam 2024-04-14 10-34-37-196.jpg",
"bandicam 2024-04-14 11-34-37-229.jpg", "bandicam 2024-04-14 12-34-37-671.jpg",
"bandicam 2024-04-14 13-34-37-699.jpg", "bandicam 2024-04-14 14-34-37-677.jpg",
"bandicam 2024-04-14 15-34-37-676.jpg", "bandicam 2024-04-14 16-34-37-705.jpg",
"bandicam 2024-04-14 17-34-37-893.jpg", "bandicam 2024-04-14 18-34-37-890.jpg",
"bandicam 2024-04-14 19-34-37-971.jpg", "bandicam 2024-04-14 20-34-37-904.jpg",
"bandicam 2024-04-14 21-34-37-899.jpg", "bandicam 2024-04-14 22-34-37-898.jpg",
"bandicam 2024-04-14 23-34-38-497.jpg", "bandicam 2024-04-15 00-34-38-599.jpg",
"bandicam 2024-04-15 01-34-38-640.jpg", "bandicam 2024-04-15 02-34-38-641.jpg",
"bandicam 2024-04-15 03-34-38-650.jpg", "bandicam 2024-04-15 04-34-38-646.jpg",
"bandicam 2024-04-15 05-34-38-657.jpg", "bandicam 2024-04-15 06-34-38-653.jpg",
"bandicam 2024-04-15 07-34-38-648.jpg", "bandicam 2024-04-15 08-34-38-862.jpg",
"bandicam 2024-04-15 09-34-38-937.jpg", "bandicam 2024-04-15 10-34-38-979.jpg"
]

inds = 13:110
exp_meth_vol = [1, 0.5, 0.6, 0.5, 0.5, 0.5, 1, 0.5, 0.8, 0.2, 0.5, 0.5, 0.5, 1, 0.5, 1, 0.5, 1, 1, 0.5, 1, 1, 1, 1, 1, 0.1, 0.1, 0.1, 0.2, 0.2, 0.2, 0.1, 1.5, 1, 0.5, 0.5, 1, 1, 0.5, 0.5, 0.7, 0.7, 0.5, 1, 0.5, 0.5, 0.8, 0.6, 0.3, 0.5, 0.5, 1, 1, 1, 1, 0.8, 0.5, 1, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 1, 1, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.3, 0.3, 0.3, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0, 0, 0, 0, 0]
meth_vol_acet_4 = cumsum(exp_meth_vol)[end]
exp_name = "acet_test_4_s2_2"
source = "Acetate"
reactor = "Reactor 4"
sludge = "Sludge 2"
run_num = "Run 2"
input_vs = 4.2
p4 = [90.0, 20.0, 1.0]


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

max_rate_acet_4_2 = max_manual_rate


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

fit = curve_fit(gompertz_sma, exp_hour, specific_meth_vol, p0, lower = lb, upper = ub)

model_params = fit.param
gompertz_sma(t) = gompertz_sma(t, model_params)

model_res = fit.resid
SS_res = sum(model_res.^2)
SS_tot = sum([(specific_meth_vol[i] - mean(specific_meth_vol)).^2 for i in 1:length(specific_meth_vol)])
r_squared = 1 - SS_res/SS_tot

kinetics = "sma"
timescale = "hour"
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

meth_vol_blank = exp_meth_vol


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
exp_meth_vol = [0, 0.8, 0.4, 0, 0, 1, 1, 1, 0.7, 0.8, 0.9, 0.8, 0.5, 1, 1, 0.7, 1, 1, 0.5, 1, 1, 0.4, 1, 0.5, 0.5, 1.1, 1, 1, 1, 1, 1, 1.5, 1, 1, 1, 0.5, 1, 0.5, 1, 0.9, 1, 1, 1, 1, 1, 1, 1, 1.5, 0.5, 1.4, 1.3, 1, 0.5, 0, 0, 0, 0.5, 1, 1, 0.75, 0.75, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.7, 0.5, 0.5, 0.5, 0.7, 0.3, 0.7, 0.5, 0.5, 0.4, 0.5, 0.6, 0.4, 0.5, 0.3, 0.4, 0.4, 0.3, 0.4, 0.2, 0.4, 0.3, 0.4, 0.2, 0.5, 0.5, 0.5, 0.5, 0.1, 0.1, 0, 0.1, 0.1, 0.2, 0.1, 0.4, 0.4, 0.2, 0.3, 0.3, 0.3, 0.3, 0.3, 0, 0, 0, 0, 0]

meth_vol_blank_complete = vcat(meth_vol_blank, zeros(length(exp_meth_vol) - length(meth_vol_blank)))
meth_vol_diff = round.(exp_meth_vol .- meth_vol_blank_complete, digits = 1)
exp_meth_vol = [meth_vol_diff[i] < 0 ? meth_vol_diff[i] = 0.0 : meth_vol_diff[i] for i in 1:length(meth_vol_diff)]

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


p0 = [17.0, 1.0, 0.1]

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
scatter!(methane_s2_r1_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Hydrolysate (4 ml mix) Exp", markercolor = colors[4])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_4_hour[2:4]), label = "Hydrolysate (4 ml mix) Theoretical \n with "*L"R^2 = "*string(model_hydro_4_hour[5]), linecolor = colors[4])


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

inds = vcat(1:66, 93:145)
exp_meth_vol = vcat([0, 0.2, 0, 0, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0.1, 0, 0, 0.1, 0, 0, 0, 0, 0, 0.1, 0, 0.3, 0.5, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.2, 0.1, 0.2, 0.4, 0.3, 0.2, 0.3, 0.3, 0.2, 0.1, 0.2, 0.2, 0.2, 0.1], zeros(56))
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
scatter!(methane_s2_r1_comp, exp_hour, cumsum(exp_meth_vol), markersize = 4, label = "Untreated FW Exp", markercolor = colors[5])
plot!(exp_hour, gompertz_bmp(exp_hour, model_hydro_fw_hour[2:4]), label = "Untreated FW Theoretical\n with "*L"R^2 = "*string(model_hydro_fw_hour[5]), linecolor = colors[5])

savefig(methane_s2_r1_comp, plotsdir("BMPs", "methane_s2_r1_comp.svg"))
