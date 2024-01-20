using DrWatson
@quickactivate "Masters_Thesis"
include(srcdir("filenames.jl"))
using CSV, DataFrames, Statistics, Distributions


function manualANOVA(allData)
    nArray = length.(allData)
    d = length(nArray)

    xBarTotal = mean(vcat(allData...))
    xBarArray = mean.(allData)

    ssBetween = sum( [nArray[i]*(xBarArray[i] - xBarTotal)^2 for i in 1:d] )
    ssWithin = sum([sum([(ob - xBarArray[i])^2 for ob in allData[i]])
				for i in 1:d])
    dfBetween = d-1
    dfError = sum(nArray)-d

    msBetween = ssBetween/dfBetween
    msError = ssWithin/dfError
    fStat = msBetween/msError
    pval = ccdf(FDist(dfBetween,dfError),fStat)
    return fStat, pval
end

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

anova_35_2minus = reshape([lact_anova_35_2minus..., acet_anova_35_2minus..., prop_anova_35_2minus..., eth_anova_35_2minus...], 2, 4)

new_names = ["Lactate", "Acetate", "Propionate", "Ethanol"]
anova_table_2minus = Tables.table(hcat(new_names, anova_35_2minus'), header = [:Test, :FStatistic, :pValue])
CSV.write(datadir("exp_pro", "anova_35_2minus.csv"), anova_table_2minus)
DataFrame(anova_table_2minus)

# Run the hypothesis tests
lact_temp_ttest = [UnequalVarianceTTest(lact_samples_35[i], lact_samples_40[i]) for i in 1:length(lact_samples_35)]
acet_temp_ttest = [UnequalVarianceTTest(acet_samples_35[i], acet_samples_40[i]) for i in 1:length(acet_samples_35)]
prop_temp_ttest = [UnequalVarianceTTest(prop_samples_35[i], prop_samples_40[i]) for i in 1:length(prop_samples_35)]
eth_temp_ttest = [UnequalVarianceTTest(eth_samples_35[i], eth_samples_40[i]) for i in 1:length(eth_samples_35)]

# Get the pvalues of each test
lact_temp_pvalues = pvalue.(lact_temp_ttest)
acet_temp_pvalues = pvalue.(acet_temp_ttest)
prop_temp_pvalues = pvalue.(prop_temp_ttest)
eth_temp_pvalues = pvalue.(eth_temp_ttest)

# Format them in a nice table and write it to CSV
temp_ttest_table = Tables.table(hcat(mix_amount, lact_temp_pvalues, acet_temp_pvalues, prop_temp_pvalues, eth_temp_pvalues), header = [:Mix_Amount, :Lactate, :Acetate, :Propionate, :Ethanol])
CSV.write(datadir("exp_pro", "temp_ttest.csv"), temp_ttest_table)
DataFrame(temp_ttest_table)
