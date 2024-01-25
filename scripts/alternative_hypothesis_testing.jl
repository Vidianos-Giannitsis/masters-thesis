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

prod45 = select(df45_1, 1, 5:8)

# Day 0
d0_prod = prod45[1:7, 2:5]
std_d0 = std.(eachcol(d0_prod))
# Corrected ethanol std
std_eth = std(prod45[2:7, 5])
std_d0[4] = std_eth

# Day 1
d1_prod = prod45[8:10, 2:5]
std_d1 = std.(eachcol(d1_prod))

# Day 2
d2_prod = prod45[11:13, 2:5]
std_d2 = std.(eachcol(d2_prod))

# Day 3
d3_prod = prod45[14:16, 2:5]
std_d3 = std.(eachcol(d3_prod))
# Corrected acetate std
std_acet = std([prod45[14, 3], prod45[16, 3]])
std_d3[2] = std_acet

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



lact_anova_35 = manualANOVA(lact_samples_35)
acet_anova_35 = manualANOVA(acet_samples_35)
prop_anova_35 = manualANOVA(prop_samples_35)
eth_anova_35 = manualANOVA(eth_samples_35)

lact_anova_40 = manualANOVA(lact_samples_40)
acet_anova_40 = manualANOVA(acet_samples_40)
prop_anova_40 = manualANOVA(prop_samples_40)
eth_anova_40 = manualANOVA(eth_samples_40)

anova_35 = reshape([lact_anova_35..., acet_anova_35..., prop_anova_35..., eth_anova_35...], 2, 4)
anova_40 = reshape([lact_anova_40..., acet_anova_40..., prop_anova_40..., eth_anova_40...], 2, 4)


names = ["Lactate_35", "Acetate_35", "Propionate_35", "Ethanol_35", "Lactate_40", "Acetate_40", "Propionate_40", "Ethanol_40"]
anova_data = hcat(anova_35, anova_40)

anova_table = Tables.table(hcat(names, anova_data'), header = [:Test, :FStatistic, :pValue])
CSV.write(datadir("exp_pro", "anova_35_40.csv"), anova_table)
DataFrame(anova_table)


lact_anova_35_2plus = manualANOVA(lact_samples_35[3:5])
acet_anova_35_2plus = manualANOVA(acet_samples_35[3:5])
prop_anova_35_2plus = manualANOVA(prop_samples_35[3:5])
eth_anova_35_2plus = manualANOVA(eth_samples_35[3:5])

lact_anova_40_2plus = manualANOVA(lact_samples_40[3:5])
acet_anova_40_2plus = manualANOVA(acet_samples_40[3:5])
prop_anova_40_2plus = manualANOVA(prop_samples_40[3:5])
eth_anova_40_2plus = manualANOVA(eth_samples_40[3:5])

anova_35_2plus = reshape([lact_anova_35_2plus..., acet_anova_35_2plus..., prop_anova_35_2plus..., eth_anova_35_2plus...], 2, 4)
anova_40_2plus = reshape([lact_anova_40_2plus..., acet_anova_40_2plus..., prop_anova_40_2plus..., eth_anova_40_2plus...], 2, 4)

anova_data_2plus = hcat(anova_35_2plus, anova_40_2plus)

anova_table_2plus = Tables.table(hcat(names, anova_data_2plus'), header = [:Test, :FStatistic, :pValue])
CSV.write(datadir("exp_pro", "anova_35_40_2plus.csv"), anova_table_2plus)
DataFrame(anova_table_2plus)


lact_ttest_40 = EqualVarianceTTest(lact_samples_40[4], lact_samples_40[5])
acet_ttest_40 = EqualVarianceTTest(acet_samples_40[4], acet_samples_40[5])
prop_ttest_40 = EqualVarianceTTest(prop_samples_40[4], prop_samples_40[5])
eth_ttest_40 = EqualVarianceTTest(eth_samples_40[4], eth_samples_40[5])

ttest_40_res = [pvalue(lact_ttest_40), pvalue(acet_ttest_40), pvalue(prop_ttest_40), pvalue(eth_ttest_40)]

lact_anova_35_2minus = manualANOVA(lact_samples_35[1:3])
acet_anova_35_2minus = manualANOVA(acet_samples_35[1:3])
prop_anova_35_2minus = manualANOVA(prop_samples_35[1:3])
eth_anova_35_2minus = manualANOVA(eth_samples_35[1:3])

lact_anova_40_2minus = manualANOVA(lact_samples_40[1:3])
acet_anova_40_2minus = manualANOVA(acet_samples_40[1:3])
prop_anova_40_2minus = manualANOVA(prop_samples_40[1:3])
eth_anova_40_2minus = manualANOVA(eth_samples_40[1:3])

anova_35_2minus = reshape([lact_anova_35_2minus..., acet_anova_35_2minus..., prop_anova_35_2minus..., eth_anova_35_2minus...], 2, 4)
anova_40_2minus = reshape([lact_anova_40_2minus..., acet_anova_40_2minus..., prop_anova_40_2minus..., eth_anova_40_2minus...], 2, 4)

anova_data_2minus = hcat(anova_35_2minus, anova_40_2minus)

anova_table_2minus = Tables.table(hcat(names, anova_data_2minus'), header = [:Test, :FStatistic, :pValue])
CSV.write(datadir("exp_pro", "anova_35_40_2minus.csv"), anova_table_2minus)
DataFrame(anova_table_2minus)


# Run the hypothesis tests
lact_temp_ttest = [EqualVarianceTTest(lact_samples_35[i], lact_samples_40[i]) for i in 1:length(lact_samples_35)]
acet_temp_ttest = [EqualVarianceTTest(acet_samples_35[i], acet_samples_40[i]) for i in 1:length(acet_samples_35)]
prop_temp_ttest = [EqualVarianceTTest(prop_samples_35[i], prop_samples_40[i]) for i in 1:length(prop_samples_35)]
eth_temp_ttest = [EqualVarianceTTest(eth_samples_35[i], eth_samples_40[i]) for i in 1:length(eth_samples_35)]

# Get the pvalues of each test
lact_temp_pvalues = pvalue.(lact_temp_ttest)
acet_temp_pvalues = pvalue.(acet_temp_ttest)
prop_temp_pvalues = pvalue.(prop_temp_ttest)
eth_temp_pvalues = pvalue.(eth_temp_ttest)

# Format them in a nice table and write it to CSV
temp_ttest_table = Tables.table(hcat(mix_amount, lact_temp_pvalues, acet_temp_pvalues, prop_temp_pvalues, eth_temp_pvalues), header = [:Mix_Amount, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "temp_ttest.csv"), temp_ttest_table)
DataFrame(temp_ttest_table)
