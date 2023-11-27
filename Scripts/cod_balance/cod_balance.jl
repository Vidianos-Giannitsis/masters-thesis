
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

df0_conc = CSV.read("hplc_conc_10_11_0.csv", DataFrame)
df1_conc = CSV.read("hplc_conc_10_11_1.csv", DataFrame)
df2_conc = CSV.read("hplc_conc_10_11_2.csv", DataFrame)
df4_conc = CSV.read("hplc_conc_10_11_4.csv", DataFrame)
df8_conc = CSV.read("hplc_conc_10_11_8.csv", DataFrame)

cod_meas = CSV.read("cod_10_11.csv", DataFrame)

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

cod0_plot = bar(mix_amount, [cod0_meas cod0_theor],
                label=label, xlabel="Amount of mix (ml)",
                ylabel = "COD (g/l)", legend=:bottom,
                title = "COD comparison t=0",
                xticks = [0, 1, 2, 4, 8])
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

# We can also do the same for the kinetic experiment where there is
# ample COD data to further test the above hypothesis.
df2310_1_conc = CSV.read("hplc_conc_23_10_1.csv", DataFrame)
df2310_2_conc = CSV.read("hplc_conc_23_10_2.csv", DataFrame)

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

# For the experimental data of COD, it is not converted to
# concentration so we first need the conversion function.
function abs_to_cod(abs; dilution = 50)
    cod = @. (2380.407*abs - 19.339)/20
end

data_matrix_1 = CSV.read("cod_23_10_1.csv", DataFrame)
abs_cod_1 = data_matrix_1.Abs_COD
cod_1_meas = abs_to_cod(abs_cod_1)
cod_1_error = cod_1_meas - cod_1_theor

data_matrix_2 = CSV.read("cod_23_10_2.csv", DataFrame)
abs_cod_2 = data_matrix_2.Abs_COD
cod_2_meas = abs_to_cod(abs_cod_2)
cod_2_error = cod_2_meas - cod_2_theor

t1 = df2310_1_conc.Time
t2 = df2310_2_conc.Time
label = ["COD Measurement" "HPLC Measurement"]

cod_1_plot = scatter(t1, [cod_1_meas cod_1_theor], label=label,
                 xlabel = "Time (h)", ylabel = "COD (g/l)",
                 title = "Sample 1", markersize = 6)
savefig(cod_1_plot, "cod_comparison_23_10_1.png")

cod_2_plot = scatter(t2, [cod_2_meas cod_2_theor], label=label,
                 xlabel = "Time (h)", ylabel = "COD (g/l)",
                 title = "Sample 2", markersize = 6)
savefig(cod_2_plot, "cod_comparison_23_20_2.png")

cod_plot = plot(cod_1_plot, cod_2_plot, layout = (2,1), size = (900, 600))
savefig(cod_plot, "cod_comparison_23_10.png")

# The conclusions here are different. In many measurements, the COD
# measurement estimates less COD than that from HPLC. This means that
# those COD measurements are unreliable and may imply that the
# measurements where COD is indeed larger are also due to random error
# and not necessarily due to something not being measured by
# HPLC. Therefore, no real conclusion like the above can be made from
# this besides the fact that COD with 1:50 dilution can be very wrong.