using DrWatson
@quickactivate "Masters_Thesis"

using Dates
using CSV, DataFrames
using LsqFit
using StatsBase
using Plots

### Data Analysis on Sample 0 ###


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


inds = 34:51
exp_meth_vol = [0, 4, 12, 7.5, 4.5, 2.5, 2.5, 4, 0.5, 2, 2, 1, 1, 1, 1, 1, 0.5, 0.5]
exp_name = "acet_test_0"
source = "Acetate"
sample = "Sample 0"
input_cod = 0.1


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = [(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:(last(inds) - first(inds) + 1)]
exp_min = [(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:(last(inds) - first(inds) + 1)]
exp_cum_meth_vol = cumsum(exp_meth_vol)

exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
p0 = [300.0, 50.0, 1.0]
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

model_acet_0 = vcat(sample, model_params, r_squared)


bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

if kinetics
    bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
    plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
    savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
end

bmp_scatter_sec = scatter(exp_sec, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_sec, plotsdir("BMPs", source, exp_name*"_sec.png"))

bmp_scatter_min = scatter(exp_min, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_min, plotsdir("BMPs", source, exp_name*"_min.png"))


### Data Analysis on Sample 1 ###


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


inds = 1:12
exp_meth_vol = [0, 12, 5, 3, 1.5, 1.5, 1, 1.5, 1, 0.5, 0.5, 0.5]
exp_name = "acet_test_1"
source = "Acetate"
sample = "Sample 1"
input_cod = 0.1


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = [(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:(last(inds) - first(inds) + 1)]
exp_min = [(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:(last(inds) - first(inds) + 1)]
exp_cum_meth_vol = cumsum(exp_meth_vol)

exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
p0 = [300.0, 50.0, 1.0]
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

model_acet_1 = vcat(sample, model_params, r_squared)


bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

if kinetics
    bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
    plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
    savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
end

bmp_scatter_sec = scatter(exp_sec, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_sec, plotsdir("BMPs", source, exp_name*"_sec.png"))

bmp_scatter_min = scatter(exp_min, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_min, plotsdir("BMPs", source, exp_name*"_min.png"))


### Data Analysis on Sample 2 ###


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


inds = 44:57
exp_meth_vol = [0, 4, 7, 5.5, 4.5, 2.5, 2, 1, 1, 1, 0.5, 0.5, 0.45, 0.05]
exp_name = "acet_test_2"
source = "Acetate"
sample = "Sample 2"
input_cod = 0.1


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = [(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:(last(inds) - first(inds) + 1)]
exp_min = [(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:(last(inds) - first(inds) + 1)]
exp_cum_meth_vol = cumsum(exp_meth_vol)

exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
p0 = [300.0, 50.0, 1.0]
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

model_acet_2 = vcat(sample, model_params, r_squared)


bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

if kinetics
    bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
    plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
    savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
end

bmp_scatter_sec = scatter(exp_sec, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_sec, plotsdir("BMPs", source, exp_name*"_sec.png"))

bmp_scatter_min = scatter(exp_min, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_min, plotsdir("BMPs", source, exp_name*"_min.png"))


### Data Analysis on Sample 4 ###


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


inds = 41:50
exp_meth_vol = [0, 4, 10, 9, 4, 5, 5, 4, 3, 3]
exp_name = "acet_test_4"
source = "Acetate"
sample = "Sample 4"
input_cod = 0.1


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = [(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:(last(inds) - first(inds) + 1)]
exp_min = [(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:(last(inds) - first(inds) + 1)]
exp_cum_meth_vol = cumsum(exp_meth_vol)

exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
p0 = [300.0, 50.0, 1.0]
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

model_acet_4 = vcat(sample, model_params, r_squared)


bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

if kinetics
    bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
    plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
    savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
end

bmp_scatter_sec = scatter(exp_sec, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_sec, plotsdir("BMPs", source, exp_name*"_sec.png"))

bmp_scatter_min = scatter(exp_min, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_min, plotsdir("BMPs", source, exp_name*"_min.png"))


### Data Analysis on Sample Ac ###


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


inds = 38:56
exp_meth_vol = [0, 6.5, 5, 3, 0.5, 1.5, 1.5, 0.5, 1, 0.5, 0.5, 0.3, 0.2, 0.2, 0.1, 0.05, 0.05, 0.05, 0.05]
exp_name = "acet_test_ac"
source = "Acetate"
sample = "Sample Ac"
input_cod = 0.1


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = [(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:(last(inds) - first(inds) + 1)]
exp_min = [(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:(last(inds) - first(inds) + 1)]
exp_cum_meth_vol = cumsum(exp_meth_vol)

exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)


gompertz(t, p) = @. p[1]*exp(-exp((((p[2]*exp(1))/p[1])*(p[3] - t)) + 1))
p0 = [300.0, 50.0, 1.0]
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

model_acet_ac = vcat(sample, model_params, r_squared)


bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

if kinetics
    bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
    plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
    savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
end

bmp_scatter_sec = scatter(exp_sec, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_sec, plotsdir("BMPs", source, exp_name*"_sec.png"))

bmp_scatter_min = scatter(exp_min, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_min, plotsdir("BMPs", source, exp_name*"_min.png"))


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
sample = "Sample Ac"
kinetics = false


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = [(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:(last(inds) - first(inds) + 1)]
exp_min = [(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:(last(inds) - first(inds) + 1)]
exp_cum_meth_vol = cumsum(exp_meth_vol)

exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)



bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

if kinetics
    bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
    plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
    savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
end

bmp_scatter_sec = scatter(exp_sec, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_sec, plotsdir("BMPs", source, exp_name*"_sec.png"))

bmp_scatter_min = scatter(exp_min, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_min, plotsdir("BMPs", source, exp_name*"_min.png"))



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
sample = "Sample Ac"
kinetics = false


date_vec = [DateTime(SubString(file_vec[i], 10, 32), "yyyy-mm-dd HH-MM-SS-sss") for i in 1:length(file_vec)]
formatted_date = [Dates.format(date_vec[i], "dd/mm_HH:MM") for i in 1:length(date_vec)]

exp_stamps = date_vec[inds]
exp_formatted = formatted_date[inds]
exp_sec = [(exp_stamps[i] - exp_stamps[1])/Millisecond(1000) for i in 1:(last(inds) - first(inds) + 1)]
exp_min = [(exp_stamps[i] - exp_stamps[1])/Millisecond(60000) for i in 1:(last(inds) - first(inds) + 1)]
exp_cum_meth_vol = cumsum(exp_meth_vol)

exp_data = Tables.table(hcat(exp_formatted, exp_sec, exp_min, exp_meth_vol, exp_cum_meth_vol), header = [:Timestamp, :Seconds, :Minutes, :Methane_Volume, :Cumulative_Methane_Volume])
CSV.write(datadir("exp_pro", exp_name*".csv"), exp_data)
exp_df = DataFrame(exp_data)



bmp_cumulative_scatter_sec = scatter(exp_sec, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_sec, plotsdir("BMPs", source, "cumulative_"*exp_name*"_sec.png"))

bmp_cumulative_scatter_min = scatter(exp_min, exp_cum_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Cumulative Methane Volume (mL)", title = "Cumulative Methane Production from "*source*" - "*sample, size = (700, 470))
savefig(bmp_cumulative_scatter_min, plotsdir("BMPs", source, "cumulative_"*exp_name*"_min.png"))

if kinetics
    bmp_specific_methane = scatter(exp_min, specific_meth_vol, markersize = 5, label = "Experimental Data", xlabel = "Time (min)", ylabel = "Cumulative Methane Production (mL/g sCOD)", title = "Methane Production Kinetics from "*source*" - "*sample, size = (700, 470), legend = :bottomright)
    plot!(exp_min, gompertz(exp_min), label = "Gompertz Model with R^2 = "*string(round(r_squared, digits = 3)))
    savefig(bmp_specific_methane, plotsdir("BMPs", source, "methane_kinetics_"*exp_name*".png"))
end

bmp_scatter_sec = scatter(exp_sec, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (sec)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_sec, plotsdir("BMPs", source, exp_name*"_sec.png"))

bmp_scatter_min = scatter(exp_min, exp_meth_vol, markersize = 5, legend = false, xlabel = "Time (min)", ylabel = "Methane Volume (mL)", title = "Methane Production from "*source*" - "*sample)
savefig(bmp_scatter_min, plotsdir("BMPs", source, exp_name*"_min.png"))


model_fit_table = Tables.table(vcat(reshape(model_acet_ac, 1, 5), reshape(model_acet_0, 1, 5), reshape(model_acet_1, 1, 5), reshape(model_acet_2, 1, 5), reshape(model_acet_4, 1, 5)), header = [:Sample_Name, :Methane_Production_Potential, :Methane_Production_Rate, :Lag_Time, :R_squared])
CSV.write(datadir("exp_pro", "methane_from_acetate_kinetics.csv"), model_fit_table)
DataFrame(model_fit_table)
