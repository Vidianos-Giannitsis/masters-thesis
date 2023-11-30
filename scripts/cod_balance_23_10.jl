using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("cod_balance.jl"))

using CSV, DataFrames, Plots

df2310_1_conc = CSV.read(datadir("exp_pro/hplc_conc_23_10_1.csv"), DataFrame)
df2310_1_conc = df2310_1_conc[1:19, :]
df2310_2_conc = CSV.read(datadir("exp_pro/hplc_conc_23_10_2.csv"), DataFrame)
df2310_2_conc = df2310_2_conc[1:15, :]

conc_columns_1 = []
cod_columns_1 = []
cod_1_theor = [0.0]
for i in 1:19
    push!(conc_columns_1, [df2310_1_conc.Sucrose[i],
                           df2310_1_conc.Glucose[i],
                           df2310_1_conc.Fructose[i],
                           df2310_1_conc.Acetate[i],
                           df2310_1_conc.Propionate[i],
                           df2310_1_conc.Lactate[i],
                           df2310_1_conc.Ethanol[i]])
    push!(cod_columns_1, (conc_columns_1[i].*cod_yields))
    push!(cod_1_theor, sum(cod_columns_1[i]))
end
popfirst!(cod_1_theor)

conc_columns_2 = []
cod_columns_2 = []
cod_2_theor =[0.0]
for i in 1:15
    push!(conc_columns_2, [df2310_2_conc.Sucrose[i],
                           df2310_2_conc.Glucose[i],
                           df2310_2_conc.Fructose[i],
                           df2310_2_conc.Acetate[i],
                           df2310_2_conc.Propionate[i],
                           df2310_2_conc.Lactate[i],
                           df2310_2_conc.Ethanol[i]])
    push!(cod_columns_2, (conc_columns_2[i].*cod_yields))
    push!(cod_2_theor, sum(cod_columns_2[i]))
end
popfirst!(cod_2_theor)

data_matrix_1 = CSV.read(datadir("exp_raw/cod_23_10_1.csv"), DataFrame)
abs_cod_1 = data_matrix_1.Abs_COD
cod_1_meas = abs_to_cod(abs_cod_1)
cod_1_error = cod_1_meas - cod_1_theor

data_matrix_2 = CSV.read(datadir("exp_raw/cod_23_10_2.csv"), DataFrame)
abs_cod_2 = data_matrix_2.Abs_COD
cod_2_meas = abs_to_cod(abs_cod_2)
cod_2_error = cod_2_meas - cod_2_theor

t1 = df2310_1_conc.Time
t2 = df2310_2_conc.Time
label = ["COD Measurement" "HPLC Measurement"]

cod_1_plot = scatter(t1, [cod_1_meas cod_1_theor], label=label,
                 xlabel = "Time (h)", ylabel = "COD (g/l)",
                 title = "Sample 1", markersize = 6)
savefig(cod_1_plot, plotsdir("23_10/cod_comparison_23_10_1.png"))

cod_2_plot = scatter(t2, [cod_2_meas cod_2_theor], label=label,
                 xlabel = "Time (h)", ylabel = "COD (g/l)",
                 title = "Sample 2", markersize = 6)
savefig(cod_2_plot, plotsdir("23_10/cod_comparison_23_20_2.png"))

cod_plot = plot(cod_1_plot, cod_2_plot, layout = (2,1), size = (900, 600))
savefig(cod_plot, plotsdir("23_10/cod_comparison_23_10.png"))
