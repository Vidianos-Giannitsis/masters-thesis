function propionate_to_acetate(st; goal = (; propionate = 0.0))
stoic = (propionate = -1, water = -2, acetate = +1, co2 = +1, hydrogen = +3)
mass_stoic = (propionate = stoic.propionate*m_propionate(),
		water = stoic.water*m_water(),
		acetate = stoic.acetate*m_acetate(),
		co2 = stoic.co2*m_co2(),
		hydrogen = stoic.hydrogen*m_hydrogen())
goal.propionate <= st.propionate || error("Propionate is not sufficient for this goal")
change = (goal.propionate - st.propionate)/mass_stoic.propionate
new_st = merge(st,
		(propionate = goal.propionate,
		water = st.water + change*mass_stoic.water,
		acetate = st.acetate + change*mass_stoic.acetate,
		co2 = st.co2 + change*mass_stoic.co2,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

function butyr_to_acetate(st; goal = (; butyrate = 0.0))
stoic = (butyrate = -1, water = -2, acetate = +2, hydrogen = +2)
mass_stoic = (butyrate = stoic.butyrate*m_butyrate(),
		water = stoic.water*m_water(),
		acetate = stoic.acetate*m_acetate(),
		hydrogen = stoic.hydrogen*m_hydrogen())
goal.butyrate <= st.butyrate || error("Butyrate is not sufficient for this goal")
change = (goal.butyrate - st.butyrate)/mass_stoic.butyrate
new_st = merge(st,
		(butyrate = goal.butyrate,
		water = st.water + change*mass_stoic.water,
		acetate = st.acetate + change*mass_stoic.acetate,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

function ethanol_to_acetate(st; goal = (; ethanol = 0.0))
    stoic = (ethanol = -1, water = -2, acetate = +1, hydrogen = +2)
    mass_stoic = (ethanol = stoic.ethanol*m_ethanol(),
		  water = stoic.water*m_water(),
		  acetate = stoic.acetate*m_acetate(),
		  hydrogen = stoic.hydrogen*m_hydrogen())
    goal.ethanol <= st.ethanol || error("Ethanol is not sufficient for this goal")
    change = (goal.ethanol - st.ethanol)/mass_stoic.ethanol
    new_st = merge(st,
		   (ethanol = goal.ethanol,
		    water = st.water + change*mass_stoic.water,
		    acetate = st.acetate + change*mass_stoic.acetate,
		    hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

function lact_to_acetate(st; goal = (; lactate = 0.0))
    stoic = (lactate = -1, water = -1, acetate = +1, hydrogen = +2, co2 = +1)
    mass_stoic = (lactate = stoic.lactate*m_lactate(),
		  water = stoic.water*m_water(),
		  acetate = stoic.acetate*m_acetate(),
		  co2 = stoic.co2*m_co2(),
		  hydrogen = stoic.hydrogen*m_hydrogen())
    goal.lactate <= st.lactate || error("Lactate is not sufficient for this goal")
    change = (goal.lactate - st.lactate)/mass_stoic.lactate
    new_st = merge(st,
		   (lactate = goal.lactate,
		    water = st.water + change*mass_stoic.water,
		    acetate = st.acetate + change*mass_stoic.acetate,
		    co2 = st.co2 + change*mass_stoic.co2,
		    hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

# In some cases, lactate acetogenesis can also happen together with
# its reduction to propionate.

function lact_to_acet_prop(st; goal = (; lactate = 0.0))
    stoic = (lactate = -2, acetate = +1, propionate = +1, hydrogen = +1, co2 = +1)
    mass_stoic = (lactate = stoic.lactate*m_lactate(),
		  acetate = stoic.acetate*m_acetate(),
		  co2 = stoic.co2*m_co2(),
		  propionate = stoic.propionate*m_propionate(),
		  hydrogen = stoic.hydrogen*m_hydrogen())
    goal.lactate <= st.lactate || error("Lactate is not sufficient for this goal")
    change = (goal.lactate - st.lactate)/mass_stoic.lactate
    new_st = merge(st,
		   (lactate = goal.lactate,
		    acetate = st.acetate + change*mass_stoic.acetate,
		    propionate = st.propionate + change*mass_stoic.propionate,
		    hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

# For this reason, we can also define a compound reaction that lists
# both pathways of lactate acetogenesis (conversion to acetate or
# conversion to a mixture of it and propionate due to the surplus of
# hydrogen allowing for lactate reduction) with the extent to which
# the propionate producing reaction happens.

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

function homoacetogenic_acetate(st; goal = (; hydrogen = 0.0))
    stoic = (hydrogen = -4, co2 = -2, acetate = +1, water = +1)
    mass_stoic = (hydrogen = stoic.hydrogen*m_hydrogen(),
		  co2 = stoic.co2*m_co2(),
		  acetate = stoic.acetate*m_acetate(),
		  water = stoic.water*m_water())
    goal.hydrogen <= st.hydrogen || error("Hydrogen is not sufficient for this goal")
    abs(change*mass_stoic.co2) <= st.co2 || error("CO2 is not sufficient for this goal")
    change = (goal.hydrogen - st.hydrogen)/mass_stoic.hydrogen
    new_st = merge(st,
		   (hydrogen = goal.hydrogen,
		    co2 = st.co2 + change*mass_stoic.co2,
		    acetate = st.acetate + change*mass_stoic.acetate,
		    water = st.water + change*mass_stoic.water))
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
