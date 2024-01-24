using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("filenames.jl"))
using CSV, DataFrames, Statistics, Distributions

# Read all the data
exp_35 = "10_11"
exp_40 = "28_11"
exp_45 = "23_10"
mix_amount = ["0", "1", "2", "4", "8"]

# Experiment @35 C
df35_0 = CSV.read(get_conc_csv(exp_35, mix_amount[1]), DataFrame)
df35_1 = CSV.read(get_conc_csv(exp_35, mix_amount[2]), DataFrame)
df35_2 = CSV.read(get_conc_csv(exp_35, mix_amount[3]), DataFrame)
df35_4 = CSV.read(get_conc_csv(exp_35, mix_amount[4]), DataFrame)
df35_8 = CSV.read(get_conc_csv(exp_35, mix_amount[5]), DataFrame)

# Experiment @40 C
df40_0 = CSV.read(get_conc_csv(exp_40, mix_amount[1]), DataFrame)
df40_1 = CSV.read(get_conc_csv(exp_40, mix_amount[2]), DataFrame)
df40_2 = CSV.read(get_conc_csv(exp_40, mix_amount[3]), DataFrame)
df40_4 = CSV.read(get_conc_csv(exp_40, mix_amount[4]), DataFrame)
df40_8 = CSV.read(get_conc_csv(exp_40, mix_amount[5]), DataFrame)

# Experiment @45 C
df45_1 = CSV.read(get_conc_csv(exp_45, mix_amount[2]), DataFrame)
df45_2 = CSV.read(get_conc_csv(exp_45, mix_amount[3]), DataFrame)

# Take the maximum instead of defaulting for the last element as we
# know ethanol is consumed so the last isn't the maximum which is the
# one we are interested in.
prod35_0 = map(maximum, eachcol(df35_0[:, 5:8]))
prod35_1 = map(maximum, eachcol(df35_1[:, 5:8]))
prod35_2 = map(maximum, eachcol(df35_2[:, 5:8]))
prod35_4 = map(maximum, eachcol(df35_4[:, 5:8]))
prod35_8 = map(maximum, eachcol(df35_8[:, 5:8]))

prod40_0 = map(maximum, eachcol(df40_0[:, 5:8]))
prod40_1 = map(maximum, eachcol(df40_1[:, 5:8]))
prod40_2 = map(maximum, eachcol(df40_2[:, 5:8]))
prod40_4 = map(maximum, eachcol(df40_4[:, 5:8]))
prod40_8 = map(maximum, eachcol(df40_8[:, 5:8]))

prod_35 = hcat(prod35_0, prod35_1, prod35_2, prod35_4, prod35_8)
prod_40 = hcat(prod40_0, prod40_1, prod40_2, prod40_4, prod40_8)

# Collect the 4 vectors which have the output variable in every condition
lact_mean_35 = prod_35[1,:]
acet_mean_35 = prod_35[2,:]
prop_mean_35 = prod_35[3,:]
eth_mean_35 = prod_35[4,:]

lact_mean_40 = prod_40[1,:]
acet_mean_40 = prod_40[2,:]
prop_mean_40 = prod_40[3,:]
eth_mean_40 = prod_40[4,:]

# For the sensitivity analysis, we want to compare both variables
# simultaneously, so we group the two prod vectors.
prod = hcat(prod35_0, prod35_1, prod35_2, prod35_4, prod35_8, prod40_0, prod40_1, prod40_2, prod40_4, prod40_8)

lact = prod[1,:]
acet = prod[2,:]
prop = prod[3,:]
eth = prod[4,:]

using Plots

xtick = ["0", "1", "2", "4", "8"]
plot_label = ["Lactate" "Acetate" "Propionate" "Ethanol"]

prod_scatter_35 = scatter(1:5, [lact_mean_35 acet_mean_35 prop_mean_35 eth_mean_35],
			  xticks = (1:5, ["0", "1", "2", "4", "8"]),
			  xlabel = "Mix Amount (ml)", ylabel = "Concentration (g/l)",
			  markersize = 6, label = plot_label,
			  title = "Product Concentration by mix amount - 35 C")
savefig(plotsdir("10_11", "final_prod_scatter_10_11.png"))

prod_scatter_40 = scatter(1:5, [lact_mean_40 acet_mean_40 prop_mean_40 eth_mean_40],
			  xticks = (1:5, ["0", "1", "2", "4", "8"]),
			  xlabel = "Mix Amount (ml)", ylabel = "Concentration (g/l)",
			  markersize = 6, label = plot_label,
			  title = "Product Concentration by mix amount - 40 C")
savefig(plotsdir("28_11", "final_prod_scatter_28_11.png"))

prod45_1 = select(df45_1, 1, 5:8)
prod45_2 = select(df45_2, 1, 5:8)

# Day 0
d0_prod = vcat(prod45_1[2:7, 2:5], prod45_2[1:3, 2:5])
# The first point in the first data has some very noticeable outliers
# that will massively increase the deviation if included.
std_d0 = std.(eachcol(d0_prod))

# Day 1
d1_prod = vcat(Vector(prod45_1[8, 2:5])', Vector(prod45_1[10, 2:5])', Vector(prod45_2[6, 2:5])')
# The times 24 and 26 hours in the second experiment are before
# Glucose is fully consumed and have much lower products than those in
# the other experiment, hence there cannot be a standard deviation
# including them. For 26 hours in the first experiment, Lactate has a
# weird increase that is lost within 2 hours, which is considered a
# possible outlier in this case.
std_d1 = [std(d1_prod[:,i]) for i in 1:4]

# Day 2

# Day 3

lact_dist_35 = [Normal(lact_mean_35[i], lact_std_35) for i in 1:length(lact_mean_35)]
acet_dist_35 = [Normal(acet_mean_35[i], acet_std_35) for i in 1:length(acet_mean_35)]
prop_dist_35 = [Normal(prop_mean_35[i], prop_std_35) for i in 1:length(prop_mean_35)]
eth_dist_35 = [Normal(eth_mean_35[i], eth_std_35) for i in 1:length(eth_mean_35)]

lact_dist_40 = [Normal(lact_mean_40[i], lact_std_40) for i in 1:length(lact_mean_40)]
acet_dist_40 = [Normal(acet_mean_40[i], acet_std_40) for i in 1:length(acet_mean_40)]
prop_dist_40 = [Normal(prop_mean_40[i], prop_std_40) for i in 1:length(prop_mean_40)]
eth_dist_40 = [Normal(eth_mean_40[i], eth_std_40) for i in 1:length(eth_mean_40)]

samples = 20
lact_samples_35 = [rand(lact_dist_35[i], samples) for i in 1:length(lact_mean_35)]
acet_samples_35 = [rand(acet_dist_35[i], samples) for i in 1:length(acet_mean_35)]
prop_samples_35 = [rand(prop_dist_35[i], samples) for i in 1:length(prop_mean_35)]
eth_samples_35 = [rand(eth_dist_35[i], samples) for i in 1:length(eth_mean_35)]

lact_samples_40 = [rand(lact_dist_40[i], samples) for i in 1:length(lact_mean_40)]
acet_samples_40 = [rand(acet_dist_40[i], samples) for i in 1:length(acet_mean_40)]
prop_samples_40 = [rand(prop_dist_40[i], samples) for i in 1:length(prop_mean_40)]
eth_samples_40 = [rand(eth_dist_40[i], samples) for i in 1:length(eth_mean_40)]

using Interpolations, GlobalSensitivity

nodes = ([0.0, 1.0, 2.0, 4.0, 8.0], [35, 40])
lact_itp = interpolate(nodes, reshape(lact, 5, 2), Gridded(Linear()))
acet_itp = interpolate(nodes, reshape(acet, 5, 2), Gridded(Linear()))
prop_itp = interpolate(nodes, reshape(prop, 5, 2), Gridded(Linear()))
eth_itp = interpolate(nodes, reshape(eth, 5, 2), Gridded(Linear()))

function lact_interp(x)
    lact_itp(x[1], x[2])
end

function acet_interp(x)
    acet_itp(x[1], x[2])
end

function prop_interp(x)
    prop_itp(x[1], x[2])
end

function eth_interp(x)
    eth_itp(x[1], x[2])
end
