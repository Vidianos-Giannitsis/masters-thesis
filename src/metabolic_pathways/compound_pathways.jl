
# Then, we need to combine some reactions to write the full reactions
# of pyruvate to ethanol and pyruvate to propionate. Then, to write
# glucose to ethanol reactions, ethanol produced from the EMP pathway
# is commonly associated with acetate production in equimolar amounts,
# while ethanol fermentation is usually done via the ED
# pathway. However, the only difference is one mole of ATP and since
# we are not writing ATP and CoA in these reactions to simplify them,
# we can assume it the same pathway. Ethanol can also be produced in
# heterolactic fermentation and due to this, there will be a glucose
# to ethanol function containing all 3 available routes probably.
function pyruv_to_ethanol(st; pyr_goal = (; pyruvate = 0.0),
                        acet_goal = (; acetaldehyde = 0.0))
acetaldehyde_st = pyruv_to_acetaldehyde(st, goal = pyr_goal)
new_st = acetaldehyde_to_ethanol(acetaldehyde_st, goal = acet_goal)
end

function pyruv_to_propionate(st, lact_amount; pyr_goal = (; pyruvate = 0.0),
                            succin_goal = (; succinate = 0.0),
                            lact_goal = (; lactate = 0.0))
lact_prod_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - pyr_goal.pyruvate)*lact_amount))
succin_prod_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - pyr_goal.pyruvate)*(1-lact_amount)))

lact_st = pyruv_to_lact(st, goal = lact_prod_goal)
succin_st = pyruv_to_succin(st, goal = succin_prod_goal)
new_st = merge(st,
                (pyruvate = pyr_goal.pyruvate,
                    hydrogen = st.hydrogen - (st.hydrogen - succin_st.hydrogen) - (st.hydrogen - lact_st.hydrogen),
                    co2 = succin_st.co2,
                    succinate = succin_st.succinate,
                    lactate = lact_st.lactate))

prop_st1 = lact_to_propionate(new_st, goal = lact_goal)
prop_st2 = succin_to_propionate(new_st, goal = succin_goal)

final_st = merge(new_st,
                    (lactate = lact_goal.lactate,
                    succinate = succin_goal.succinate,
                    propionate = prop_st1.propionate + prop_st2.propionate - new_st.propionate,
                    hydrogen = prop_st1.hydrogen,
                    co2 = prop_st2.co2))
end
# Pyruvate to propionate is a more complex process as it is the first
# case we study where a metabolite can be produced by two pathways. By
# the amount of propionate both paths seem to be equivalent and
# consume the same amount of hydrogen. However, we can specify how
# much succinate or lactate is in the effluent, from which the two
# paths would start to diverge as if lactate remains in the effluent,
# it has only needed one mole of hydrogen and if succinate remains, it
# means that there is enough CO2 in the reactor to form propionate
# without succinate being consumed.

# Other reactions: Heterolactic fermentation both with ethanol and
# acetate as co-products as fundamental reactions and then a function
# similar to propionate formation where we define to which extent each
# pathway was followed to get a total of the heterolactic
# fermentation, which value however can be a key argument as acetate
# formation is generally rare. Also write the bifidus pathway as a
# fundamental. Write propionate to valerate (which happens in mixed
# acid fermenation). Then, we can also write acetogenic (and maybe
# methanogenic) reactions as fundamentals, to explain other products
# which we can find in the reactor. After all fundamentals are done,
# we can start composing them similarly to how it will be done for
# propionate for example, where we can combine reactions in either
# known or unknown stoichiometries and say that this is another
# possible route. This is mostly for products of EMP.

function heterolactic_ferment(st; goal = (; glucose = 0.0),
                            acet_amount = 0)
acet_prod_goal = (; glucose = (st.glucose - (st.glucose - goal.glucose)*acet_amount))
eth_prod_goal = (; glucose = (st.glucose - (st.glucose - goal.glucose)*(1-acet_amount)))

eth_st = ethanol_heterolactate(st, goal)
acet_st = acetate_heterolactate(st, goal)
new_st = merge(st,
                (glucose = goal.glucose,
                ethanol = eth_st.ethanol,
                acetate = acet_st.acetate,
                lactate = eth_st.lactate + acet_st.lactate - st.lactate,
                co2 = eth_st.co2 + acet_st.co2 - st.co2,
                hydrogen = eth_sth.hydrogen + acet_st.hydrogen - st.hydrogen))
end
# Then we can create a combined function that takes the extent of
# propionate production in acetogenesis in mind.
function lactate_acetogenesis(st, prop_amount; goal = (; lactate = 0.0))
    acet_prod_goal = (; lactate = (st.lactate - (st.lactate - goal.lactate)*(1-prop_amount)))
    prop_prod_goal = (; lactate = (st.lactate - (st.lactate - goal.lactate)*prop_amount))

    acet_st = lact_to_acetate(st, goal = acet_prod_goal)
    prop_st = lact_to_acet_prop(st, goal = prop_prod_goal)
    new_st = merge(st,
                   (lactate = goal.lactate,
                    acetate = acet_st.acetate + prop_st.acetate - st.acetate,
                    hydrogen = acet_st.hydrogen + prop_st.hydrogen - st.hydrogen,
                    co2 = acet_st.co2 + prop_st.co2 - st.co2,
                    propionate = prop_st.propionate,
                    water = acet_st.water))
end
function acetogenesis(st; prop_goal = (; propionate = st.propionate),
                      butyr_goal = (; butyrate = st.butyrate),
                      eth_goal = (; ethanol = st.ethanol),
                      lact_goal = (; lactate = st.lactate),
                      hyd_goal = (; hydrogen = st.hydrogen),
                      lact_prop = 0)
    prop_st = propionate_to_acetate(st, goal = prop_goal)
    butyr_st = butyr_to_acetate(st, goal = butyr_goal)
    eth_st = ethanol_to_acetate(st, goal = eth_goal)
    lact_st = lactate_acetogenesis(st, lact_prop, goal = lact_goal)

    new_st = merge(st,
                   (propionate = prop_st.propionate + lact_st.propionate - st.propionate,
                    butyrate = butyr_st.butyrate,
                    ethanol = eth_st.ethanol,
                    lactate = lact_st.lactate,
                    co2 = prop_st.co2 + lact_st.co2 - st.co2,
                    water = prop_st.water + butyr_st.water + eth_st.water + lact_st.water - 3st.water,
                    acetate = prop_st.acetate + butyr_st.acetate + eth_st.acetate + lact_st.acetate - 3st.acetate,
                    hydrogen = prop_st.hydrogen + butyr_st.hydrogen + eth_st.hydrogen + lact_st.hydrogen - 3st.hydrogen))

    #homoacetic_st = homoacetogenic_acetate(new_st, goal = hyd_goal)
end

function glucose_consumption(st, bifidus_amount, eth_amount,
                            heterolact_amount; goal = (; glucose = 0.0),
                            acet_amount = 0)
glycolysis_amount = 1-bifidus_amount-eth_amount-heterolact_amount
bifidus_goal = (; glucose = (st.glucose - (st.glucose - goal.glucose))*bifidus_amount)
eth_goal = (; glucose = (st.glucose - (st.glucose - goal.glucose))*eth_amount)
heterolact_goal = (; glucose = (st.glucose - (st.glucose - goal.glucose))*heterolact_amount)
glycolysis_goal = (; glucose = (st.glucose - (st.glucose - goal.glucose))*glycolysis_amount)

bifidus_st = bifidus_ferment(st, goal)
eth_st = ethanol_fermentation(st, goal)
heterolact_st = heterolactic_ferment(st, goal = goal, acet_amount = acet_amount)
glycolysis_st = glycolysis(st, goal)

new_st = merge(st,
                (glucose = goal.glucose,
                pyruvate = glycolysis_st.pyruvate,
                acetate = heterolact_st.acetate + bifidus_st.acetate - st.acetate,
                ethanol = heterolact_st.ethanol + eth_st.ethanol - st.ethanol,
                lactate = heterolact_st.lactate + bifidus_st.lactate - st.lactate,
                co2 = heterolact_st.co2 + eth_st.co2 - st.co2,
                hydrogen = glycolysis_st.hydrogen + heterolact_st.hydrogen))
end

# Then, after writing all the pathways of glucose consumption, we can
# write the complex reactions of pyruvate to products. We know from
# literature that ethanol-acetate is 1:1 in pyruvate consumption,
# butyrate-acetate is 3:1 and propionate-acetate is 2:1, which are the
# three main compound paths we need to define. We also know that
# ethanol can be produced from EMP pyruvate only together with
# acetate, propionate needs acetate to have enough hydrogen to react
# with and butyrate is also very rarely seen without acetate
# production. However, acetate being the only product is feasible
# either on its own, or via acetogenic reactions. We also know ABE
# fermentation can occur, where acetate, butyrate and ethanol are
# produced during acidogenesis and then, in the solventogenic phase,
# ethanol starts being produced with higher yield (ED pathway) and
# acetacetyl-CoA starts giving acetone and butanol instead of
# butyrate. However, there is not a consistent ratio in which these
# are produced in ABE, so the ratios there will be given as a keyword
# argument.
function acetate_ethanol_fermentation(st; goal = (; pyruvate = 0.0))
acet_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate)*0.5))
eth_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate)*0.5))

acet_st = pyruv_to_acetate(st, goal = acet_goal)
eth_st = pyruv_to_ethanol(st, pyr_goal = eth_goal)

new_st = merge(st,
                (pyruvate = goal.pyruvate,
                acetate = acet_st.acetate,
                ethanol = eth_st.ethanol,
                co2 = acet_st.co2 + eth_st.co2 - st.co2,
                water = acet_st.water))
end

function acetate_butyrate_fermentation(st; goal = (; pyruvate = 0.0))
acet_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate)*0.25))
butyr_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate)*0.75))

acet_st = pyruv_to_acetate(st, goal = acet_goal)
butyr_st = pyruv_to_butyr(st, goal = butyr_goal)

new_st = merge(st,
                (pyruvate = goal.pyruvate,
                acetate = acet_st.acetate,
                butyrate = butyr_st.butyrate,
                hydrogen = acet_st.hydrogen + butyr_st.hydrogen - st.hydrogen,
                co2 = acet_st.co2 + butyr_st.co2 - st.co2))
end

# Reminder that the pyruvate to propionate function has levers for how
# much lactate was produced from each pathway and if lactate or
# succinate are accumulated in the reactor. In the case of
# acetate-propionate fermentation with this stoichiometry, propionate
# is fully converted so these aren't necessary. More complex ones can
# be defined to explain accumulation of lactate and succinate, but
# this is the standard acidogenic route.
function acetate_propionate_fermentation(st; pyr_goal = (; pyruvate = 0.0), lact_goal=(; lactate = 0.0), lact_amount = 1, prop_amount = 2/3)
    acet_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - pyr_goal.pyruvate)*(1-prop_amount)))
    prop_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - pyr_goal.pyruvate)*prop_amount))

    acet_st = pyruv_to_acetate(st, goal = acet_goal)
    prop_st = pyruv_to_propionate(st, lact_amount, pyr_goal = prop_goal, lact_goal = lact_goal)

    new_st = merge(st,
                   (pyruvate = pyr_goal.pyruvate,
                    acetate = acet_st.acetate,
                    propionate = prop_st.propionate,
                    co2 = acet_st.co2,
                    lactate = prop_st.lactate,
                    hydrogen = acet_st.hydrogen + prop_st.hydrogen - st.hydrogen))
end

# In literature, I have not seen a pathway that starts from pyruvate and has as products propionate and ethanol without being paired with acetate. However, experimentally, we have an effluent where lactate, ethanol and propionate are increased significantly but not paired with acetate production. 
function ethanol_propionate_fermentation(st; pyr_goal = (; pyruvate = 0.0),
                                         lact_goal = (; lactate = 0.0),
                                         succin_goal = (; succinate = 0.0),
                                         prop_amount = 0.5, lact_amount = 1)
    eth_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - pyr_goal.pyruvate)*(1-prop_amount)))
    prop_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - pyr_goal.pyruvate)*prop_amount))

    eth_st = pyruv_to_ethanol(st, pyr_goal = eth_goal)
    prop_st = pyruv_to_propionate(st, lact_amount, pyr_goal = prop_goal, lact_goal = lact_goal, succin_goal = succin_goal)

    new_st = merge(st,
                   (pyruvate = pyr_goal.pyruvate,
                    ethanol = eth_st.ethanol,
                    propionate = prop_st.propionate,
                    lactate = prop_st.lactate,
                    co2 = eth_st.co2,
                    hydrogen = eth_st.hydrogen + prop_st.hydrogen - st.hydrogen,
                    succinate = prop_st.succinate))
end

function ABE_fermentation(st; goal = (; pyruvate = 0.0),
                        acet_amount, aceteth_amount, butyr_amount,
                        solveth_amount, acetone_amount)
butanol_amount = 1 - acet_amount - aceteth_amount - butyr_amount - solveth_amount - acetone_amount
acet_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate))*acet_amount)
aceteth_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate))*aceteth_amount)
butyr_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate))*butyr_amount)
solveth_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate))*solveth_amount)
acetone_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate))*acetone_amount)
butanol_goal = (; pyruvate = (st.pyruvate - (st.pyruvate - goal.pyruvate))*butanol_amount)

acet_st = pyruv_to_acetate(st, goal = acet_goal)
aceteth_st = acetate_ethanol_fermentation(st, goal = aceteth_goal)
butyr_st = pyruv_to_butyr(st, goal = butyr_goal)
acidogenic_st = merge(st,
                        (pyruvate = acet_st.pyruvate + aceteth_st.pyruvate + butyr_st.pyruvate - 2st.pyruvate,
                        acetate = acet_st.acetate + aceteth_st.acetate - st.acetate,
                        butyrate = butyr_st.butyrate,
                        ethanol = aceteth_st.ethanol,
                        hydrogen = acet_st.hydrogen,
                        co2 = acet_st.co2 + aceteth_st.co2 + butyr_st.co2 - 2st.co2,
                        water = acet_st.water + aceteth_st.water - st.water))

solveth_st = ethanol_fermentation(acidogenic_st, goal = solveth_goal)
acetone_st = pyruv_to_acetone(acidogenic_st, goal = acetone_goal)
butanol_st = pyruv_to_butanol(acidogenic_st, goal = butanol_goal)
solventogenic_st = merge(acidogenic_st,
                            (pyruvate = goal.pyruvate,

                            ethanol = solveth_st.ethanol,
                            acetone = acetone_st.acetone,
                            butanol = butanol_st.butanol,
                            co2 = solveth_st.co2 + acetone_st.co2 + butanol_st.co2 - 2acidogenic_st.co2,
                            hydrogen = acetone_st.hydrogen + butanol_st.hydrogen - acidogenic_st.hydrogen,
                            water = acetone_st.water + butanol_st.water - acidogenic_st.water))
end

