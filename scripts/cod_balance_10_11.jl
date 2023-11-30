using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("cod_balance.jl"))

using CSV, DataFrames, Plots

df0_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_0.csv"), DataFrame)
df1_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_1.csv"), DataFrame)
df2_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_2.csv"), DataFrame)
df4_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_4.csv"), DataFrame)
df8_conc = CSV.read(datadir("exp_pro/hplc_conc_10_11_8.csv"), DataFrame)

cod_meas = CSV.read(datadir("exp_pro/cod_10_11.csv"), DataFrame)

df0_conc0 = [df0_conc.Sucrose[1], df0_conc.Glucose[1],
             df0_conc.Fructose[1], df0_conc.Acetate[1],
             df0_conc.Propionate[1], df0_conc.Lactate[1],
             df0_conc.Ethanol[1]]

df1_conc0 = [df1_conc.Sucrose[1], df1_conc.Glucose[1],
             df1_conc.Fructose[1], df1_conc.Acetate[1],
             df1_conc.Propionate[1], df1_conc.Lactate[1],
             df1_conc.Ethanol[1]]

df2_conc0 = [df2_conc.Sucrose[1], df2_conc.Glucose[1],
             df2_conc.Fructose[1], df2_conc.Acetate[1],
             df2_conc.Propionate[1], df2_conc.Lactate[1],
             df2_conc.Ethanol[1]]

df4_conc0 = [df4_conc.Sucrose[1], df4_conc.Glucose[1],
             df4_conc.Fructose[1], df4_conc.Acetate[1],
             df4_conc.Propionate[1], df4_conc.Lactate[1],
             df4_conc.Ethanol[1]]

df8_conc0 = [df8_conc.Sucrose[1], df8_conc.Glucose[1],
             df8_conc.Fructose[1], df8_conc.Acetate[1],
             df8_conc.Propionate[1], df8_conc.Lactate[1],
             df8_conc.Ethanol[1]]

df0_conc72 = [df0_conc.Sucrose[4], df0_conc.Glucose[4],
             df0_conc.Fructose[4], df0_conc.Acetate[4],
             df0_conc.Propionate[4], df0_conc.Lactate[4],
             df0_conc.Ethanol[4]]

df1_conc72 = [df1_conc.Sucrose[4], df1_conc.Glucose[4],
             df1_conc.Fructose[4], df1_conc.Acetate[4],
             df1_conc.Propionate[4], df1_conc.Lactate[4],
             df1_conc.Ethanol[4]]

df2_conc72 = [df2_conc.Sucrose[4], df2_conc.Glucose[4],
             df2_conc.Fructose[4], df2_conc.Acetate[4],
             df2_conc.Propionate[4], df2_conc.Lactate[4],
             df2_conc.Ethanol[4]]

df4_conc72 = [df4_conc.Sucrose[4], df4_conc.Glucose[4],
             df4_conc.Fructose[4], df4_conc.Acetate[4],
             df4_conc.Propionate[4], df4_conc.Lactate[4],
             df4_conc.Ethanol[4]]

df8_conc72 = [df8_conc.Sucrose[4], df8_conc.Glucose[4],
             df8_conc.Fructose[4], df8_conc.Acetate[4],
             df8_conc.Propionate[4], df8_conc.Lactate[4],
             df8_conc.Ethanol[4]]

cod_yields = [cod_sucrose(), cod_glucose(),
              cod_fructose(), cod_acetate(),
              cod_propionate(), cod_lactate(),
              cod_ethanol()]

df0_cod0 = sum(df0_conc0.*cod_yields)
df1_cod0 = sum(df1_conc0.*cod_yields)
df2_cod0 = sum(df2_conc0.*cod_yields)
df4_cod0 = sum(df4_conc0.*cod_yields)
df8_cod0 = sum(df8_conc0.*cod_yields)
cod0_theor = [df0_cod0, df1_cod0, df2_cod0, df4_cod0, df8_cod0]
cod0_meas = cod_meas.COD_0./1000
cod0_error = cod0_meas - cod0_theor

df0_cod72 = sum(df0_conc72.*cod_yields)
df1_cod72 = sum(df1_conc72.*cod_yields)
df2_cod72 = sum(df2_conc72.*cod_yields)
df4_cod72 = sum(df4_conc72.*cod_yields)
df8_cod72 = sum(df8_conc72.*cod_yields)
cod72_theor = [df0_cod72, df1_cod72, df2_cod72, df4_cod72, df8_cod72]
cod72_meas = cod_meas.COD_72./1000
cod72_error = cod72_meas - cod72_theor

mix_amount = [0, 1, 2, 4, 8]
label = ["COD Measurement" "HPLC Measurement"]

cod0_plot = bar(mix_amount, [cod0_meas cod0_theor],
                label=label, xlabel="Amount of mix (ml)",
                ylabel = "COD (g/l)", legend=:bottom,
                title = "COD comparison t=0",
                xticks = [0, 1, 2, 4, 8])
savefig(cod0_plot, plotsdir("10_11/cod_comparison_10_11_0.png"))

cod72_plot = bar(mix_amount, [cod72_meas cod72_theor],
                label=label, xlabel="Amount of mix (ml)",
                ylabel = "COD (g/l)", legend=:bottom,
                 title = "COD comparison t=72",
                 xticks = [0, 1, 2, 4, 8])
savefig(cod72_plot, plotsdir("10_11/cod_comparison_10_11_72.png"))

cod_plot = plot(cod0_plot, cod72_plot, layout = (2,1), size = (900, 600))
savefig(cod_plot, plotsdir("10_11/cod_comparison_10_11.png"))
