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

solveth_st = pyruv_to_ethanol(acidogenic_st, goal = solveth_goal)
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
