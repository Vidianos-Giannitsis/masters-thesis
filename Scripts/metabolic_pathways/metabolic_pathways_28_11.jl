using CSV, DataFrames

df0_conc = CSV.read("hplc_conc_28_11_0.csv", DataFrame)
df1_conc = CSV.read("hplc_conc_28_11_1.csv", DataFrame)
df2_conc = CSV.read("hplc_conc_28_11_2.csv", DataFrame)
df4_conc = CSV.read("hplc_conc_28_11_4.csv", DataFrame)
df8_conc = CSV.read("hplc_conc_28_11_8.csv", DataFrame)

v = 0.8
init_st0 = (sucrose = df0_conc.Sucrose[1], glucose = df0_conc.Glucose[1],
            fructose = df0_conc.Fructose[1], lactate = df0_conc.Lactate[1],
            acetate = df0_conc.Acetate[1], propionate = df0_conc.Propionate[1],
            ethanol = df0_conc.Ethanol[1], co2 = 0.0, hydrogen = 10.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass0 = conc_to_mass(init_st0, v)

init_st1 = (sucrose = df1_conc.Sucrose[1], glucose = df1_conc.Glucose[1],
            fructose = df1_conc.Fructose[1], lactate = df1_conc.Lactate[1],
            acetate = df1_conc.Acetate[1], propionate = df1_conc.Propionate[2],
            ethanol = df1_conc.Ethanol[1], co2 = 0.0, hydrogen = 10.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass1 = conc_to_mass(init_st1, v)

init_st2 = (sucrose = df2_conc.Sucrose[1], glucose = df2_conc.Glucose[1],
            fructose = df2_conc.Fructose[1], lactate = df2_conc.Lactate[1],
            acetate = df2_conc.Acetate[1], propionate = df2_conc.Propionate[1],
            ethanol = df2_conc.Ethanol[1], co2 = 0.0, hydrogen = 10.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass2 = conc_to_mass(init_st2, v)

init_st4 = (sucrose = df4_conc.Sucrose[1], glucose = df4_conc.Glucose[1],
            fructose = df4_conc.Fructose[1], lactate = df4_conc.Lactate[1],
            acetate = df4_conc.Acetate[1], propionate = df4_conc.Propionate[1],
            ethanol = df4_conc.Ethanol[1], co2 = 0.0, hydrogen = 10.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass4 = conc_to_mass(init_st4, v)

init_st8 = (sucrose = df8_conc.Sucrose[1], glucose = df8_conc.Glucose[1],
            fructose = df8_conc.Fructose[1], lactate = df8_conc.Lactate[1],
            acetate = df8_conc.Acetate[2], propionate = df8_conc.Propionate[2],
            ethanol = df8_conc.Ethanol[1], co2 = 0.0, hydrogen = 10.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass8 = conc_to_mass(init_st8, v)
# Assumptions: All Sucrose is hydrolyzed, all glucose goes to the
# heterolactate pathway and all fructose consumed up to 48 hours goes
# to an acetate producing pathway with ethanol or propionate as the
# co-product.
function mixed_culture_fermentation(st; gluc_goal = (; glucose = 0.0), suc_goal = (; sucrose = 0.0), lact_cons_goal = (; lactate = 0.0), fruc_goal = (; fructose = 0.0), pyr_goal = (; pyruvate = 0.0), acet_amount = 0.5, lact_amount = 0.5)
    suc_st = sucrose_hydrolysis(st, goal = suc_goal)
    het_st = ethanol_heterolactate(suc_st, goal = gluc_goal)
    fruc_st = fructolysis(het_st, goal = fruc_goal)

    aceteth_amount = 1 - lact_amount - acet_amount
    acet_goal = (; pyruvate = (fruc_st.pyruvate - (fruc_st.pyruvate - pyr_goal.pyruvate)*acet_amount))
    lact_prod_goal = (; pyruvate = (fruc_st.pyruvate - (fruc_st.pyruvate - pyr_goal.pyruvate)*lact_amount))
    aceteth_goal = (; pyruvate = (fruc_st.pyruvate - (fruc_st.pyruvate - pyr_goal.pyruvate)*aceteth_amount))

    aceteth_st = acetate_ethanol_fermentation(fruc_st, goal =aceteth_goal)
    acet_st = pyruv_to_acetate(fruc_st, goal = acet_goal)
    lact_st = pyruv_to_lact(fruc_st, goal = lact_prod_goal)

    new_st = merge(fruc_st,
                   (pyruvate = pyr_goal.pyruvate,
                    acetate = acet_st.acetate + aceteth_st.acetate - fruc_st.ethanol,
                    ethanol = aceteth_st.ethanol,
                    lactate = lact_st.lactate,
                    co2 = acet_st.co2 + aceteth_st.co2 - fruc_st.co2,
                    hydrogen = acet_st.hydrogen + aceteth_st.hydrogen + lact_st.hydrogen - 2fruc_st.hydrogen))

    prop_st = lact_to_propionate(new_st, goal = lact_cons_goal)
end

final_st0 = mixed_culture_fermentation(init_mass0, lact_cons_goal = (; lactate = df0_conc.Lactate[4]*0.8), fruc_goal = (; fructose = df0_conc.Fructose[4]*0.8), acet_amount = 0.20, lact_amount = 0.3)
final_conc0 = mass_to_conc(final_st0, v)
# Results: If we select an aceteth_amount and an acid amount such that
# ethanol reaches the concentration its supposed to have and so does
# acetate. Lactate is said to be a bit less than it should, but that
# can be fixed by increasing its goal. Thus we can get that right as
# well. Propionate has a decent overestimation however, propionate
# being largely overestimated can make sense as its been shown to be
# the compound with the most consistent increase throughout time.

final_st1 = mixed_culture_fermentation(init_mass1, lact_goal = (; lactate = df1_conc.Lactate[4]*0.8 +0.18), fruc_goal = (; fructose = df1_conc.Fructose[3]*0.8), aceteth_amount = 0.21, acid_amount = 0.79, prop_amount = 0.46)
final_conc1 = mass_to_conc(final_st1, v)
# In this, much less ethanol needs to be produced, so if we assume
# that the rest goes to acetate-propionate, we get a very large
# overestimation of propionate. Probable explanation is that some of
# the pyruvate is converted only to acetate without other
# co-products. However, then we would only move the overestimation to
# acetate. These amounts predict the final acetate at 72h, but in the
# steady state its probably more due to ethanol acetogenesis,
# propionate being way too overestimated and the rest of the fructose
# consumption. Ethanol and lactate are also predicted correctly with a
# propionate overestimation.

final_st2 = mixed_culture_fermentation(init_mass2, lact_goal = (; lactate = df2_conc.Lactate[4]*0.8), fruc_goal = (; fructose = df2_conc.Fructose[3]*0.8), aceteth_amount = 0.33, acid_amount = 0.03)
final_conc2 = mass_to_conc(final_st2, v)
# By the assumption that all glucose is made into lactate and ethanol
# and nearly all fructose gives 1 mole of ethanol, we get almost
# precisely the amount of lactate and ethanol of the experimenta (and
# this is without even needing to change the lactate goal). However,
# in this experiment, acetate didn't seem to increase significantly
# and even is reduced in some phases (probably for growth of the
# microorganisms). So the co-product of ethanol from pyruvate appears
# to be propionate and not acetate. If only 30% of pyruvate goes to
# ethanol together with acetate and the rest with ethanol, we get the
# peak concentration of acetate and a small overestimation of
# propionate which is assumed to be able in steady state. However,
# that is not feasible by the redox balance (consumes more hydrogen
# than is produced). By increasing it to 33%, hydrogen consumption
# becomes almost 0, which means that the produced hydrogen is just
# enough for the reactions that occur and acetate is only slightly
# larger than the maximum recorded value.

final_st4 = mixed_culture_fermentation(init_mass4, lact_goal = (; lactate = df4_conc.Lactate[4]*0.8 + 0.1), fruc_goal = (; fructose = df4_conc.Fructose[3]*0.8), aceteth_amount = 0.37, acid_amount = 0.18)
final_conc4 = mass_to_conc(final_st4, v)
# Again, this has an overestimation of propionate which make sense and
# can be justified by the steady state not being achieved yet. Acetate
# is also slightly overestimated by its current value, but it is
# barely enough for the redox balance to be satisfied. Lactate and
# ethanol are predicted correctly.

final_st8 = mixed_culture_fermentation(init_mass8, lact_goal = (; lactate = df8_conc.Lactate[4]*0.8 + 0.03), fruc_goal = (; fructose = df8_conc.Fructose[3]*0.8), aceteth_amount = 0.45, acid_amount = 0.07)
final_conc8 = mass_to_conc(final_st8, v)
# This model can predict ethanol and lactate very well and has only a
# very slight error in acetate prediction, with propionate showing to
# be much more than the estimation (same as with the other
# experiments). The assumption that has been made, (which the kinetic
# experiment did justify to an extent) is that propionate will be
# produced in larger extent until steady state is reached and is why
# we have accepted its overestimation. Also acetate doesn't show a
# trend of large increase in general, so we can assume that its final
# value isn't that higher than that at 72h.

# General Conclusions: Mass balances can be fulfilled (and even
# overestimated) without taking any starch in mind. This can mean that
# the effect of starch can only be seen later on in the reaction,
# starch is not hydrolyzed, or the amount of starch in the waste is
# not significant (is possible as its mostly vegetables). Ethanol is
# produced fairly fast but for acids to appear and start increasing,
# more time is necessary. This is why in most cases, they are
# overestimated by the system, which uses reactions that are assumed
# to have reached equilibrium. An attempt was made to not overestimate
# acetate too much as in 35 C, it is not a very active product and is
# mostly used to reserve redox balance. Propionate is the most
# overestimated and after it lactate, which is correct in some
# examples only but in general isn't as overestimated. All this is
# done based on getting the definitely correct max ethanol
# concentration right. Also the fructose that is metabolized after 48h
# is ignored as it is assumed that it is converted primarily to acids
# and that they will take a while to appear. The assumption that
# glucose is converted to ethanol and lactate via the PK pathway
# completely appears to have merit, although there is a chance some of
# it goes to glycolysis and produces ethanol via some of the other
# pathways, to justify lactate overestimation. However, with its
# constant increase, it is believable that the overestimation is
# simply due to not taking measurements for long enough.

# For the 23/10 experiment, a different metabolic pathway is
# needed. In 45 C, acetogens were shown to be much more active and
# lactate wasn't only produced but also consumed for production of
# both acetate and propionate. So the reactions that are possible are:
# Heterolactate fermentation (still done even if the products are
# consumed much more and maybe done to a lesser extent), acetate
# fermentation, acetate-propionate fermentation and acetate-ethanol
# fermentation. The first can only be done from glucose, but we can
# assume that not all glucose goes to that, as there is much less
# ethanol. For simplicity we will assume the only other reaction is
# acetate fermentation. Then, from fructose, the 3 other reactions
# mentioned can be done and after them, acetogenic reactions take
# place consuming ethanol and lactate.

function mixed_culture_fermentation2(st; gluc_goal = (; glucose = 0.0), suc_goal = (; sucrose = 0.0), fruc_goal = (; fructose = 0.0), lact_goal1 = (; lactate = 0.0), lact_goal2 = (; lactate = 0.0), pyr_goal = (; pyruvate = 0.0), eth_goal = (; ethanol = 0.0), het_amount = 1, acet_amount = 0.5, acid_amount = 0.5, prop_amount = 2/3)
    suc_st = sucrose_hydrolysis(st, goal = suc_goal)

    het_goal = (; glucose = (suc_st.glucose - (suc_st.glucose - gluc_goal.glucose)*het_amount))
    glyc_goal = (; glucose = (suc_st.glucose - (suc_st.glucose - gluc_goal.glucose)*(1-het_amount)))
    het_st = ethanol_heterolactate(suc_st, goal = het_goal)
    glyc_st = glycolysis(suc_st, goal = glyc_goal)
    fruc_st = fructolysis(suc_st, goal = fruc_goal)

    pyr_st = merge(suc_st,
                   (glucose = gluc_goal.glucose,
                    fructose = fruc_goal.fructose,
                    ethanol = het_st.ethanol,
                    lactate = het_st.lactate,
                    pyruvate = glyc_st.pyruvate + fruc_st.pyruvate - suc_st.pyruvate,
                    hydrogen = glyc_st.hydrogen + fruc_st.hydrogen - suc_st.hydrogen,
                    co2 = het_st.co2))

    aceteth_amount = 1 - acet_amount - acid_amount
    aceteth_goal = (; pyruvate = (pyr_st.pyruvate - (pyr_st.pyruvate - pyr_goal.pyruvate)*aceteth_amount))
    acet_goal = (; pyruvate = (pyr_st.pyruvate - (pyr_st.pyruvate - pyr_goal.pyruvate)*acet_amount))
    acid_goal = (; pyruvate = (pyr_st.pyruvate - (pyr_st.pyruvate - pyr_goal.pyruvate)*acid_amount))

    aceteth_st = acetate_ethanol_fermentation(pyr_st, goal = aceteth_goal)
    acet_st = pyruv_to_acetate(pyr_st, goal = acet_goal)
    acid_st = acetate_propionate_fermentation(pyr_st, pyr_goal = acid_goal, lact_goal = lact_goal1, prop_amount = prop_amount)

    new_st = merge(pyr_st,
                   (pyruvate = pyr_goal.pyruvate,
                    acetate = aceteth_st.acetate + acet_st.acetate + acid_st.acetate - 2pyr_st.acetate,
                    propionate = acid_st.propionate,
                    ethanol = aceteth_st.ethanol,
                    lactate = acid_st.lactate,
                    hydrogen = aceteth_st.hydrogen + acid_st.hydrogen + acet_st.hydrogen - 2pyr_st.hydrogen,
                    co2 = aceteth_st.co2 + acid_st.co2 + acet_st.co2 - 2pyr_st.co2,
                    water = aceteth_st.water + acid_st.water + acet_st.water - 2pyr_st.water))

    lact_st = lact_to_propionate(new_st, goal = lact_goal2)
    eth_st = ethanol_to_acetate(new_st, goal = eth_goal)

    final_st = merge(new_st,
                     (lactate = lact_goal2.lactate,
                      ethanol = eth_goal.ethanol,
                      acetate = eth_st.acetate,
                      propionate = lact_st.propionate,
                      water = eth_st.water,
                      hydrogen = eth_st.hydrogen + lact_st.hydrogen - new_st.hydrogen))
end

final_st2310_1 = mixed_culture_fermentation2(init_mass2310_1, lact_goal1 = (; lactate = df2310_1_conc.Lactate[9]*0.8), lact_goal2 = (; lactate = df2310_1_conc.Lactate[19]*0.8), fruc_goal = (; fructose = df2310_1_conc.Fructose[20]*0.8), eth_goal = (; ethanol = df2310_1_conc.Ethanol[20]*0.8), het_amount = 0.9, acet_amount = 0.70, acid_amount = 0.3)
final_conc2310_1 = mass_to_conc(final_st2310_1, v)
# Using a different metabolic pathway of allowing glucose to be
# converted to pyruvate via glycolysis and not just heterolactate, we
# can get interpretable results for this. Still, most of the glucose
# goes to heterolactate fermentation, but in this case, ethanol amount
# is matched with 0.9 of the glucose in that pathway. Then the
# produced pyruvate goes either to pure acetogenesis or
# acetate-propionate fermentation. With 0.7 going to acetate and the
# rest to mixed, we get only a very slight overestimation of both,
# which means it is very close to reality. In this pathway, we have
# also listed the reactions that consume ethanol and lactate as we see
# them happening due to the larger experiment, but they only push
# acetate and propionate much higher meaning that the steady state
# definitely takes more than 7 days and that the second week would be
# mostly an increase of those two.

final_st2310_2 = mixed_culture_fermentation2(init_mass2310_2, lact_goal1 = (; lactate = df2310_2_conc.Lactate[7]*0.8), lact_goal2 = (; lactate = df2310_2_conc.Lactate[15]*0.8), fruc_goal = (; fructose = df2310_2_conc.Fructose[17]*0.8), eth_goal = (; ethanol = df2310_2_conc.Ethanol[17]*0.8), het_amount = 1, acet_amount = 0.38, acid_amount = 0.44)
final_conc2310_2 = mass_to_conc(final_st2310_2, v)
# For this one, which is supposed to be a duplicate of the above,
# ethanol production appears to be much more, as the heterolactate
# rout is followed by 100% of glucose and even 18% of fructose. Then,
# the rest of the produced pyruvate is split almost equally between
# acetate and acetate-propionate fermentation with the mixed one being
# a bit higher. Again, both will be overestimated, but only by half
# the amount of the previous one.

int_st2310_2 = mixed_culture_fermentation(init_mass2310_2, lact_goal = (; lactate = df2310_2_conc.Lactate[15]*0.8 + 0.40), fruc_goal = (; fructose = df2310_2_conc.Fructose[17]*0.8), aceteth_amount = 0.14, acid_amount = 0.86, prop_amount = 0.3)
final_st2310_2 = ethanol_to_acetate(int_st2310_2, goal = (; ethanol = df2310_2_conc.Ethanol[17]*0.8))
final_conc2310_2 = mass_to_conc(final_st2310_2, v)
# Interestingly, the old function can also describe this system
# decently and this is weirdly similar to the dataset for 1 ml mix at
# 35 C. There is a lot of acetogenesis with only a small fraction of
# ethanol, which is also then consumed for acetate. Acetogenesis is
# much more dominant here and the parameters do reflect that. However,
# it is probably better to use the new function here as well.


### PLOTS
# First, make vectors with the final conditions for each for the
# comparative plots, but for fructose we ignored the final consumption
# cause it will probably show up later on in the process and not in
# the hours it was consumed. We also will use the third point for
# ethanol as that is the max and we have ignored acetogenic reactions.
using Plots
xtick = first(map(string, keys(final_conc0)), 7)
ylabel = "Concentration (g/l)"
label = ["Predicted values" "Experimental values"]

df0_conc72 = [df0_conc.Sucrose[4], df0_conc.Glucose[4],
              df0_conc.Fructose[3], df0_conc.Lactate[4],
              df0_conc.Acetate[4], df0_conc.Propionate[4],
              df0_conc.Ethanol[3]]
conc0_values = first(values(final_conc0), 7)
bar_0 = bar([conc0_values, df0_conc72], xticks = (1:7, xtick),
            ylabel = ylabel, label = label,
            title = "0 ml mix")
savefig(bar_0, "metabolism_0_10_11.png")

df1_conc72 = [df1_conc.Sucrose[4], df1_conc.Glucose[4],
              df1_conc.Fructose[3], df1_conc.Lactate[4],
              df1_conc.Acetate[4], df1_conc.Propionate[4],
              df1_conc.Ethanol[3]]
conc1_values = first(values(final_conc1), 7)
bar_1 = bar([conc1_values, df1_conc72], xticks = (1:7, xtick),
            ylabel = ylabel, label = label,
            title = "1 ml mix")
savefig(bar_1, "metabolism_1_11_11.png")

df2_conc72 = [df2_conc.Sucrose[4], df2_conc.Glucose[4],
              df2_conc.Fructose[3], df2_conc.Lactate[4],
              df2_conc.Acetate[4], df2_conc.Propionate[4],
              df2_conc.Ethanol[3]]
conc2_values = first(values(final_conc2), 7)
bar_2 = bar([conc2_values, df2_conc72], xticks = (1:7, xtick),
            ylabel = ylabel, label = label,
            title = "2 ml mix")
savefig(bar_2, "metabolism_2_12_11.png")

df4_conc72 = [df4_conc.Sucrose[4], df4_conc.Glucose[4],
              df4_conc.Fructose[3], df4_conc.Lactate[4],
              df4_conc.Acetate[4], df4_conc.Propionate[4], 
              df4_conc.Ethanol[3]]
conc4_values = first(values(final_conc4), 7)
bar_4 = bar([conc4_values, df4_conc72], xticks = (1:7, xtick),
            ylabel = ylabel, label = label,
            title = "4 ml mix")
savefig(bar_4, "metabolism_4_14_11.png")

df8_conc72 = [df8_conc.Sucrose[4], df8_conc.Glucose[4],
              df8_conc.Fructose[3], df8_conc.Lactate[4],
              df8_conc.Acetate[4], df8_conc.Propionate[4],
              df8_conc.Ethanol[3]]
conc8_values = first(values(final_conc8), 7)
bar_8 = bar([conc8_values, df8_conc72], xticks = (1:7, xtick),
            ylabel = ylabel, label = label,
            title = "8 ml mix")
savefig(bar_8, "metabolism_8_18_11.png")

bar_final = plot(bar_0, bar_1, bar_2, bar_4, bar_8,
                 layout = 5, size = (1600, 900))
savefig(bar_final, "metabolism_plot_10_11.png")

df2310_1_conc171 = [df2310_1_conc.Sucrose[21], df2310_1_conc.Glucose[21],
                    df2310_1_conc.Fructose[20], df2310_1_conc.Lactate[19],
                    df2310_1_conc.Acetate[21], df2310_1_conc.Propionate[21],
                    df2310_1_conc.Ethanol[21]]
conc2310_1_values = first(values(final_conc2310_1), 7)
bar_2310_1 = bar([conc2310_1_values, df2310_1_conc171], xticks = (1:7, xtick),
            ylabel = ylabel, label = label,
            title = "1st trial")
savefig(bar_2310_1, "metabolism_1_23_10.png")

df2310_2_conc171 = [df2310_2_conc.Sucrose[17], df2310_2_conc.Glucose[17],
                    df2310_2_conc.Fructose[17], df2310_2_conc.Lactate[15],
                    df2310_2_conc.Acetate[17], df2310_2_conc.Propionate[17],
                    df2310_2_conc.Ethanol[17]]
conc2310_2_values = first(values(final_conc2310_2), 7)
bar_2310_2 = bar([conc2310_2_values, df2310_2_conc171], xticks = (1:7, xtick),
            ylabel = ylabel, label = label,
            title = "2nd trial")
savefig(bar_2310_2, "metabolism_2_23_10.png")

bar_2310_final = plot(bar_2310_1, bar_2310_2, layout = 2, size = (1200, 500))
savefig(bar_2310_final, "metabolism_plot_23_10.png")
