using CSV, DataFrames

df0_conc = CSV.read("hplc_conc_10_11_0.csv", DataFrame)
df1_conc = CSV.read("hplc_conc_10_11_1.csv", DataFrame)
df2_conc = CSV.read("hplc_conc_10_11_2.csv", DataFrame)
df4_conc = CSV.read("hplc_conc_10_11_4.csv", DataFrame)
df8_conc = CSV.read("hplc_conc_10_11_8.csv", DataFrame)

v = 0.8
init_st0 = (sucrose = df0_conc.Sucrose[1], glucose = df0_conc.Glucose[1],
            fructose = df0_conc.Fructose[1], lactate = df0_conc.Lactate[2],
            acetate = df0_conc.Acetate[1], propionate = df0_conc.Propionate[2],
            ethanol = df0_conc.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass0 = conc_to_mass(init_st0, v)

init_st1 = (sucrose = df1_conc.Sucrose[1], glucose = df1_conc.Glucose[1],
            fructose = df1_conc.Fructose[1], lactate = df1_conc.Lactate[2],
            acetate = df1_conc.Acetate[2], propionate = df1_conc.Propionate[2],
            ethanol = df1_conc.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass1 = conc_to_mass(init_st1, v)

init_st2 = (sucrose = df2_conc.Sucrose[1], glucose = df2_conc.Glucose[1],
            fructose = df2_conc.Fructose[1], lactate = df2_conc.Lactate[1],
            acetate = df2_conc.Acetate[1], propionate = df2_conc.Propionate[1],
            ethanol = df2_conc.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass2 = conc_to_mass(init_st2, v)

init_st4 = (sucrose = df4_conc.Sucrose[1], glucose = df4_conc.Glucose[1],
            fructose = df4_conc.Fructose[1], lactate = df4_conc.Lactate[1],
            acetate = df4_conc.Acetate[2], propionate = df4_conc.Propionate[1],
            ethanol = df4_conc.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass4 = conc_to_mass(init_st4, v)

init_st8 = (sucrose = df8_conc.Sucrose[1], glucose = df8_conc.Glucose[1],
            fructose = df8_conc.Fructose[1], lactate = df8_conc.Lactate[1],
            acetate = df8_conc.Acetate[2], propionate = df8_conc.Propionate[1],
            ethanol = df8_conc.Ethanol[1], co2 = 0.0, hydrogen = 0.0, water = 750.0,
            pyruvate = 0.0, succinate = 0.0, acetaldehyde = 0.0)
init_mass8 = conc_to_mass(init_st8, v)

# Assumptions: All Sucrose is hydrolyzed, all glucose goes to the
# heterolactate pathway and all fructose consumed up to 48 hours goes
# to an acetate producing pathway with ethanol or propionate as the
# co-product.
function mixed_culture_fermentation(st; gluc_goal = (; glucose = 0.0), suc_goal = (; sucrose = 0.0), lact_goal = (; lactate = 0.0), fruc_goal = (; fructose = 0.0), pyr_goal = (; pyruvate = 0.0), aceteth_amount = 0.5, prop_amount = 2/3, acid_amount = 0.5)
    suc_st = sucrose_hydrolysis(st, goal = suc_goal)
    het_st = ethanol_heterolactate(suc_st, goal = gluc_goal)
    fruc_st = fructolysis(het_st, goal = fruc_goal)

    propeth_amount = 1 - acid_amount - aceteth_amount
    acet_goal = (; pyruvate = (fruc_st.pyruvate - (fruc_st.pyruvate - pyr_goal.pyruvate)*aceteth_amount))
    acid_goal = (; pyruvate = (fruc_st.pyruvate - (fruc_st.pyruvate - pyr_goal.pyruvate)*acid_amount))
    prop_goal = (; pyruvate = (fruc_st.pyruvate - (fruc_st.pyruvate - pyr_goal.pyruvate)*propeth_amount))

    acid_st = acetate_propionate_fermentation(fruc_st, pyr_goal = acid_goal, lact_goal = lact_goal, prop_amount = prop_amount)
    prop_st = ethanol_propionate_fermentation(fruc_st, pyr_goal=prop_goal, lact_goal = lact_goal)
    acet_st = acetate_ethanol_fermentation(fruc_st, goal =acet_goal)

    new_st = merge(fruc_st,
                   (pyruvate = pyr_goal.pyruvate,
                    acetate = acet_st.acetate + acid_st.acetate - fruc_st.ethanol,
                    ethanol = prop_st.ethanol + acet_st.ethanol - fruc_st.ethanol,
                    propionate = prop_st.propionate + acid_st.propionate - fruc_st.propionate,
                    co2 = acet_st.co2 + prop_st.co2 + acid_st.co2 - 2fruc_st.co2,
                    hydrogen = acet_st.hydrogen + prop_st.hydrogen + acid_st.hydrogen - 2fruc_st.hydrogen))
end

final_st0 = mixed_culture_fermentation(init_mass0, lact_goal = (; lactate = df0_conc.Lactate[4]*0.8), fruc_goal = (; fructose = df0_conc.Fructose[3]*0.8), aceteth_amount = 0.68, acid_amount = 0.25)
final_conc0 = mass_to_conc(final_st0, v)
# Results: If we select an aceteth_amount and an acid amount such that
# ethanol reaches the concentration its supposed to have and so does
# acetate, we can get only a rough overestimation in lactate and one a
# bit larger in propionate. This means that this pathway is probably
# correct and the rest of the increases would be what we would see in
# an eventual steady state. Propionate being largely overestimated can
# make sense as its been shown to be the compound with the most
# consistent increase.

final_st1 = mixed_culture_fermentation(init_mass1, lact_goal = (; lactate = df1_conc.Lactate[4]*0.8), fruc_goal = (; fructose = df1_conc.Fructose[3]*0.8), aceteth_amount = 0.21, acid_amount = 0.79, prop_amount = 0.46)
final_conc1 = mass_to_conc(final_st1, v)
# In this, much less ethanol needs to be produced, so if we assume
# that the rest goes to acetate-propionate, we get a very large
# overestimation of propionate. Probable explanation is that some of
# the pyruvate is converted only to acetate without other
# co-products. However, then we would only move the overestimation to
# acetate. These amounts predict the final acetate at 72h, but in the
# steady state its probably more due to ethanol acetogenesis,
# propionate being way too overestimated and the rest of the fructose
# consumption. Lactate is overestimated, but is expected to be
# feasible to reach that number.

final_st2 = mixed_culture_fermentation(init_mass2, lact_goal = (; lactate = df2_conc.Lactate[4]*0.8), fruc_goal = (; fructose = df2_conc.Fructose[3]*0.8), aceteth_amount = 0.33, acid_amount = 0.03)
final_conc2 = mass_to_conc(final_st2, v)
# By the assumption that all glucose is made into lactate and ethanol
# and nearly all fructose gives 1 mole of ethanol, we get almost
# precisely the amount of lactate and ethanol of the
# experimental. However, in this experiment, acetate didn't seem to
# increase significantly and even is reduced in some phases (probably
# for growth of the microorganisms). So the co-product of ethanol from
# pyruvate appears to be propionate and not acetate. If only 30% of
# pyruvate goes to ethanol together with acetate and the rest with
# ethanol, we get the peak concentration of acetate and a small
# overestimation of propionate which is assumed to be able in steady
# state. However, that is not feasible by the redox balance (consumes
# more hydrogen than is produced). By increasing it to 33%, hydrogen
# consumption becomes almost 0, which means that the produced hydrogen
# is just enough for the reactions that occur and acetate is only
# slightly larger than the maximum recorded value.

final_st4 = mixed_culture_fermentation(init_mass4, lact_goal = (; lactate = df4_conc.Lactate[4]*0.8), fruc_goal = (; fructose = df4_conc.Fructose[3]*0.8), aceteth_amount = 0.46, acid_amount = 0.18)
final_conc4 = mass_to_conc(final_st4, v)
# Again, this has a slight overestimation of lactate and a larger one
# of propionate which make sense and can be justified by the steady
# state not being achieved yet. Acetate is also slightly overestimated
# by its current value, but it is assumed that a little bit more could
# be produced. Hydrogen is just enough for reactions to be feasible.

final_st8 = mixed_culture_fermentation(init_mass8, lact_goal = (; lactate = df8_conc.Lactate[4]*0.8), fruc_goal = (; fructose = df8_conc.Fructose[3]*0.8), aceteth_amount = 0.45, acid_amount = 0.07)
final_conc8 = mass_to_conc(final_st8, v)
# This model can predict ethanol very well and have only slight error
# in acetate and lactate predictions, with propionate showing to be
# much more. The assumption that has been made, (which the kinetic
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
