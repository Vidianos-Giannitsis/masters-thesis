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
