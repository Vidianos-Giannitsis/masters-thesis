
function cod_equiv(; C=0, H=0, O=0, N=0)
    cod = (16*(2C+0.5H-1.5N-O))/(12C+H+16O+14N)
end

function cod_glucose()
    cod_equiv(C=6, H=12, O=6)
end

function cod_fructose()
    cod_equiv(C=6, H=12, O=6)
end

function cod_sucrose()
    cod_equiv(C=12, H=24, O=12)
end

function cod_acetate()
    cod_equiv(C=2, H=4, O=2)
end

function cod_propionate()
    cod_equiv(C=3, H=6, O=2)
end

function cod_ethanol()
    cod_equiv(C=2, H=6, O=1)
end

function cod_lactate()
    cod_equiv(C=3, H=6, O=3)
end

using CSV, DataFrames

df0_conc = CSV.read("hplc_conc_28_11_0.csv", DataFrame)
df1_conc = CSV.read("hplc_conc_28_11_1.csv", DataFrame)
df2_conc = CSV.read("hplc_conc_28_11_2.csv", DataFrame)
df4_conc = CSV.read("hplc_conc_28_11_4.csv", DataFrame)
df8_conc = CSV.read("hplc_conc_28_11_8.csv", DataFrame)

cod_meas = CSV.read("cod_28_11.csv", DataFrame)

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

using Plots
mix_amount = [0, 1, 2, 4, 8]
label = ["COD Measurement" "HPLC Measurement"]

cod0_plot = bar(mix_amount, [cod0_theor cod0_meas],
                label=["HPLC Measurement" "COD Measurement"],
                xlabel="Amount of mix (ml)",
                ylabel = "COD (g/l)", legend=:bottom,
                title = "COD comparison t=0",
                xticks = [0, 1, 2, 4, 8], fillcolor = ["#E36F47" "#009AFA"])
savefig(cod0_plot, "cod_comparison_10_11_0.png")        

cod72_plot = bar(mix_amount, [cod72_meas cod72_theor],
                label=label, xlabel="Amount of mix (ml)",
                ylabel = "COD (g/l)", legend=:bottom,
                 title = "COD comparison t=72",
                 xticks = [0, 1, 2, 4, 8])
savefig(cod72_plot, "cod_comparison_10_11_72.png")

cod_plot = plot(cod0_plot, cod72_plot, layout = (2,1), size = (900, 600))
savefig(cod_plot, "cod_comparison_10_11.png")

# Conclusion: In the initial mixture (t=0h), HPLC measures almost
# everything as the error in COD is low enough to justify it being
# because of the different techniques having different accuracy and
# even if there is something else, its concentration is probably very
# low. This isn't the case only for one mixture (4 mL mix). In the
# mixture after 72h, the error between measured COD and that based on
# HPLC concentrations is larger. This can lead to the conclusion that
# besides the measured products (acetate, propionate, lactate,
# ethanol), there is at least one metabolic product that contributes
# to COD that we don't measure.
