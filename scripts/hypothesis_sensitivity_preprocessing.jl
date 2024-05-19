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

using CairoMakie
colors = Makie.wong_colors()

xtick = ["0", "0.005", "0.01", "0.02", "0.04"]
plot_label = ["Lactate", "Acetate", "Propionate", "Ethanol"]
xdata = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5]
grp = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]

vfa_conc_35 = vcat(prod35_0, prod35_1, prod35_2, prod35_4, prod35_8)
vfa_conc_40 = vcat(prod40_0, prod40_1, prod40_2, prod40_4, prod40_8)

fig_35 = Figure(size = (600, 400))
ax_35 = Axis(fig_35[1,1], xticks = (1:5, xtick),
	     title = "Products of acidogenic fermentation at 35 C",
	     xlabel = "Mix Amount (ml)",
	     ylabel = "Products (g/L)")
prod_35 = barplot!(ax_35, xdata, vfa_conc_35, stack = grp, color = colors[grp])
elements = [PolyElement(polycolor = colors[i]) for i in 1:length(plot_label)]
Legend(fig_35[1,2], elements, plot_label, "Products: ")
save(get_plot_name("final_product", "10_11", "bar"), fig_35)

fig_40 = Figure(size = (600, 400))
ax_40 = Axis(fig_40[1,1], xticks = (1:5, xtick),
	     title = "Products of acidogenic fermentation at 40 C",
	     xlabel = "Mix Amount (ml)",
	     ylabel = "Products (g/L)")
prod_40 = barplot!(ax_40, xdata, vfa_conc_40, stack = grp, color = colors[grp])
elements = [PolyElement(polycolor = colors[i]) for i in 1:length(plot_label)]
Legend(fig_40[1,2], elements, plot_label, "Products: ")
save(get_plot_name("final_product", "28_11", "bar"), fig_40)

prod_plot = vcat(prod35_0, prod35_1, prod35_2, prod35_4, prod35_8, prod40_0, prod40_1, prod40_2, prod40_4, prod40_8)
xdata_complete = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5]
grp1 = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]
grp2 = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
bar_l = ["", "", "", "35 C", "", "", "", "35 C", "", "", "", "35 C", "", "", "", "35 C", "", "", "", "35 C", "", "", "", "40 C", "", "", "", "40 C", "", "", "", "40 C", "", "", "", "40 C", "", "", "", "40 C"]

fig_comp = Figure(size = (900, 600))
ax_comp = Axis(fig_comp[1,1], xticks = (1:5, xtick),
	       title = "Products of acidogenic fermentation",
	       xlabel = "Mix Amount (L/kg FW)",
	       ylabel = "Products (g/L)", titlesize = 36,
	       xlabelsize = 28, ylabelsize = 28,
	       xticklabelsize = 28, yticklabelsize = 28)
prod_comp = barplot!(ax_comp, xdata_complete, prod_plot, stack = grp1, dodge = grp2, color = colors[grp1], bar_labels = bar_l, label_size = 18)
elements = [PolyElement(polycolor = colors[i]) for i in 1:length(plot_label)]
Legend(fig_comp[1,2], elements, plot_label, "Products: ", labelsize = 32, titlesize = 32)
save(plotsdir("35_40_comp", "final_products.svg"), fig_comp)

prod45 = select(df45_1, 1, 5:8)

# Day 0
d0_prod = prod45[1:7, 2:5]
std_d0 = std.(eachcol(d0_prod))
# Corrected ethanol std
#std_eth = std(prod45[2:7, 5])
#std_d0[4] = std_eth

# Day 1
d1_prod = prod45[8:10, 2:5]
std_d1 = std.(eachcol(d1_prod))

# Day 2
d2_prod = prod45[11:13, 2:5]
std_d2 = std.(eachcol(d2_prod))

# Day 3
d3_prod = prod45[14:16, 2:5]
std_d3 = std.(eachcol(d3_prod))

std_final = mean([std_d0, std_d1, std_d2, std_d3])

lact_dist_35 = [Normal(lact_mean_35[i], std_final[1]) for i in 1:length(lact_mean_35)]
acet_dist_35 = [Normal(acet_mean_35[i], std_final[2]) for i in 1:length(acet_mean_35)]
prop_dist_35 = [Normal(prop_mean_35[i], std_final[3]) for i in 1:length(prop_mean_35)]
eth_dist_35 = [Normal(eth_mean_35[i], std_final[4]) for i in 1:length(eth_mean_35)]

lact_dist_40 = [Normal(lact_mean_40[i], std_final[1]) for i in 1:length(lact_mean_40)]
acet_dist_40 = [Normal(acet_mean_40[i], std_final[2]) for i in 1:length(acet_mean_40)]
prop_dist_40 = [Normal(prop_mean_40[i], std_final[3]) for i in 1:length(prop_mean_40)]
eth_dist_40 = [Normal(eth_mean_40[i], std_final[4]) for i in 1:length(eth_mean_40)]

using Random
samples = 20
Random.seed!(1234)
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
