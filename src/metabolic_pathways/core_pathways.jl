state = (glucose = 16.0, pyruvate = 0.0, hydrogen = 0.0, water = 700.0, co2 = 0.0,
	acetate = 0.0, propionate = 0.0, butyrate = 0.0, ethanol = 0.0,
	lactate = 0.0, succinate = 0.0, formate = 0.0, acetaldehyde = 0.0,
	fructose = 0.0, sucrose = 0.0, butanol = 0.0, acetone = 0.0,
	valerate = 0.0, oxygen = 0.0)

function glycolysis(st; goal = (; glucose = 0.0))
stoic = (glucose = -1, pyruvate = +2, hydrogen = +2)
mass_stoic = (glucose = stoic.glucose*m_glucose(),
		pyruvate = stoic.pyruvate*m_pyruvate(),
		hydrogen = stoic.hydrogen*m_hydrogen())
goal.glucose <= st.glucose || error("Glucose is not sufficient for this goal")
change = (goal.glucose - st.glucose)/mass_stoic.glucose
new_st = merge(st,
		(glucose = goal.glucose,
		pyruvate = st.pyruvate + change*mass_stoic.pyruvate,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

function sucrose_hydrolysis(st; goal = (; sucrose = 0.0))
stoic = (sucrose = -1, glucose = +1, fructose = +1)
mass_stoic = (sucrose = stoic.sucrose*m_sucrose(),
		glucose = stoic.glucose*m_glucose(),
		fructose = stoic.fructose*m_fructose())
goal.sucrose <= st.sucrose || error("Sucrose is not sufficient for this goal")
change = (goal.sucrose - st.sucrose)/mass_stoic.sucrose
new_st = merge(st,
		(sucrose = goal.sucrose,
		glucose = st.glucose + change*mass_stoic.glucose,
		fructose = st.fructose + change*mass_stoic.fructose))
end

function fructolysis(st; goal = (; fructose = 0.0))
stoic = (fructose = -1, glucose = +1)
mass_stoic = (fructose = stoic.fructose*m_fructose(),
		glucose = stoic.glucose*m_glucose())
goal.fructose <= st.fructose || error("Fructose is not sufficient for this goal")
change = (goal.fructose - st.fructose)/mass_stoic.fructose
fruc_st = merge(st,
		(fructose = goal.fructose,
		glucose = st.glucose + change*mass_stoic.glucose))
new_st = glycolysis(fruc_st, goal = (; glucose = st.glucose))
end

function pyruv_to_acetate(st; goal = (; pyruvate = 0.0))
stoic = (pyruvate = -1, water = -1, acetate= +1, hydrogen = +1, co2=+1)
mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
		water = stoic.water*m_water(),
		acetate = stoic.acetate*m_acetate(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		co2 = stoic.co2*m_co2())
goal.pyruvate <= st.pyruvate || error("Pyruvate is not sufficient for this goal")
change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
new_st = merge(st,
		(pyruvate = goal.pyruvate,
		water = st.water + change*mass_stoic.water,
		acetate = st.acetate + change*mass_stoic.acetate,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		co2 = st.co2 + change*mass_stoic.co2))
end

function pyruv_to_acetaldehyde(st; goal = (; pyruvate = 0.0))
stoic = (pyruvate = -1, acetaldehyde = +1, co2 = +1)
mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
		acetaldehyde = stoic.acetaldehyde*m_acetaldehyde(),
		co2 = stoic.co2*m_co2())
goal.pyruvate <= st.pyruvate || error("Pyruvate is not sufficient for this goal")
change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
new_st = merge(st,
		(pyruvate = goal.pyruvate,
		acetaldehyde = st.acetaldehyde + change*mass_stoic.acetaldehyde,
		co2 = st.co2 + change*mass_stoic.co2))
end


function pyruv_to_butyr(st; goal = (; pyruvate = 0.0))
stoic = (pyruvate = -2, butyrate = +1, co2 = +2)
mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
		butyrate = stoic.butyrate*m_butyrate(),
		co2 = stoic.co2*m_co2())
goal.pyruvate <= st.pyruvate || error("Pyruvate is not sufficient for this goal")
change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
new_st = merge(st,
		(pyruvate = goal.pyruvate,
		butyrate = st.butyrate + change*mass_stoic.butyrate,
		co2 = st.co2 + change*mass_stoic.co2))
end

function pyruv_to_butanol(st; goal = (; pyruvate = 0.0))
stoic = (pyruvate = -2, hydrogen = -2, water = +1, butanol = +1, co2 = +2)
mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		water = stoic.water*m_water(),
		butanol = stoic.butanol*m_butanol(),
		co2 = stoic.co2*m_co2())
goal.pyruvate <= st.pyruvate || error("Pyruvate is not sufficient for this goal")
change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
abs(change*mass_stoic.hydrogen) <= st.hydrogen || error("Hydrogen is not sufficient for this goal")
new_st = merge(st,
		(pyruvate = goal.pyruvate,
		butanol = st.butanol + change*mass_stoic.butanol,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		co2 = st.co2 + change*mass_stoic.co2,
		water = st.water + change*mass_stoic.water))
end

function pyruv_to_acetone(st; goal = (; pyruvate = 0.0))
stoic = (pyruvate = -2, water = -1, co2 = +3, hydrogen = +2, acetone = +1)
mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
		water = stoic.water*m_water(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		co2 = stoic.co2*m_co2(),
		acetone = stoic.acetone*m_acetone())
goal.pyruvate <= st.pyruvate || error("Pyruvate is not sufficient for this goal")
change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
new_st = merge(st,
		(pyruvate = goal.pyruvate,
		water = st.water + change*mass_stoic.water,
		co2 = st.co2 + change*mass_stoic.co2,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		acetone = st.acetone + change*mass_stoic.acetone))
end

function pyruv_to_lact(st; goal = (; pyruvate = 0.0))
stoic = (pyruvate = -1, hydrogen = -1, lactate = +1)
mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		lactate = stoic.lactate*m_lactate())
goal.pyruvate <= st.pyruvate || error("Pyruvate is not sufficient for this goal")
change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
abs(change*mass_stoic.hydrogen) <= st.hydrogen || error("Hydrogen is not sufficient for this goal")
new_st = merge(st,
		(pyruvate = goal.pyruvate,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		lactate = st.lactate + change*mass_stoic.lactate))
end


function pyruv_to_succin(st; goal = (; pyruvate = 0.0))
stoic = (pyruvate = -1, co2 = -1, hydrogen = -2, succinate = +1, water = +1)
mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
		co2 = stoic.co2*m_co2(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		succinate = stoic.succinate*m_succinate(),
		water = stoic.water*m_water())
goal.pyruvate <= st.pyruvate || error("Pyruvate is not sufficient for this goal")
change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
abs(change*mass_stoic.hydrogen) <= st.hydrogen || error("Hydrogen is not sufficient for this goal")
abs(change*mass_stoic.co2) <= st.co2 || error("CO2 is not sufficient for this goal")
new_st = merge(st,
		(pyruvate = goal.pyruvate,
		co2 = st.co2 + change*mass_stoic.co2,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		succinate = st.succinate + change*mass_stoic.succinate,
		water = st.water + change*mass_stoic.water))
end

function acetaldehyde_to_ethanol(st; goal = (; acetaldehyde = 0.0))
stoic = (acetaldehyde = -1, hydrogen = -1, ethanol = +1)
mass_stoic = (acetaldehyde = stoic.acetaldehyde*m_acetaldehyde(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		ethanol = stoic.ethanol*m_ethanol())
goal.acetaldehyde <= st.acetaldehyde || error("Acetaldehyde is not sufficient for this goal")
change = (goal.acetaldehyde - st.acetaldehyde)/mass_stoic.acetaldehyde
abs(change*mass_stoic.hydrogen) <= st.hydrogen || error("Hydrogen is not sufficient for this goal")
new_st = merge(st,
		(acetaldehyde = goal.acetaldehyde,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		ethanol = st.ethanol + change*mass_stoic.ethanol))
end


function lact_to_propionate(st; goal = (; lactate = 0.0))
stoic = (lactate = -1, hydrogen = -1, propionate = +1)
mass_stoic = (lactate = stoic.lactate*m_lactate(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		propionate = stoic.propionate*m_propionate())
goal.lactate <= st.lactate || error("Lactate is not sufficient for this goal")
change = (goal.lactate - st.lactate)/mass_stoic.lactate
abs(change*mass_stoic.hydrogen) <= st.hydrogen || error("Hydrogen is not sufficient for this goal")
new_st = merge(st,
		(lactate = goal.lactate,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		propionate = st.propionate + change*mass_stoic.propionate))
end


function succin_to_propionate(st; goal = (; succinate = 0.0))
stoic = (succinate = -1, propionate = +1, co2 = +1)
mass_stoic = (succinate = stoic.succinate*m_succinate(),
		propionate = stoic.propionate*m_propionate(),
		co2 = stoic.co2*m_co2())
goal.succinate <= st.succinate || error("Succinate is not sufficient for this goal")
change = (goal.succinate - st.succinate)/mass_stoic.succinate
new_st = merge(st,
		(succinate = goal.succinate,
		propionate = st.propionate + change*mass_stoic.propionate,
		co2 = st.co2 + change*mass_stoic.co2))
end

# The formate balance isn't exactly like all the other reactions where
# the goal is the main reactant. It is a reaction very close to
# equilibrium that in pH near neutral or higher is favored on
# formate. If you expect that formate will be produced, you can give a
# goal that formate has this concentration and it will remove enough
# co2 and hydrogen for it to be feasible. Since it is common for none
# to be produced, the default value will be expect that none will be
# produced.
function formate_balance(st; goal = (; formate = 0.0))
stoic = (co2 = -1, hydrogen = -1, formate = +1)
mass_stoic = (co2 = stoic.co2*m_co2(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		formate = stoic.formate*m_formate())
change = (goal.formate - st.formate)/mass_stoic.formate
abs(change*mass_stoic.hydrogen) <= st.hydrogen || error("Hydrogen is not sufficient for this goal")
abs(change*mass_stoic.co2) <= st.co2 || error("CO2 is not sufficient for this goal")
new_st = merge(st,
		(formate = goal.formate,
		co2 = st.co2 + change*mass_stoic.co2,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end


function propionate_to_valerate(st; goal = (; valerate = 0.0))
stoic = (propionate = -1, co2 = -2, hydrogen = -6, valerate =+1)
mass_stoic = (propionate = stoic.propionate*m_propionate(),
		co2 = stoic.co2*m_co2(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		valerate = stoic.valerate*m_valerate())
goal.valerate <= m_valerate()*st.propionate/m_propionate() || error("Propionate is not sufficient for this goal")
change = (goal.valerate - st.valerate)/mass_stoic.valerate
new_st = merge(st,
		(valerate = goal.valerate,
		propionate = st.propionate + change*mass_stoic.propionate,
		co2 = st.co2 + change*mass_stoic.co2,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

function ethanol_heterolactate(st; goal = (; glucose = 0.0))
stoic = (glucose = -1, pyruvate = +1, ethanol = +1, hydrogen = +1, co2 = +2)
mass_stoic = (glucose = stoic.glucose*m_glucose(),
		pyruvate = stoic.pyruvate*m_pyruvate(),
		ethanol = stoic.ethanol*m_ethanol(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		co2 = stoic.co2*m_co2())
goal.glucose <= st.glucose || error("Glucose is not sufficient for this goal")
change = (goal.glucose - st.glucose)/mass_stoic.glucose
pyr_st = merge(st,
		(glucose = goal.glucose,
		pyruvate = st.pyruvate + change*mass_stoic.pyruvate,
		ethanol = st.ethanol + change*mass_stoic.ethanol,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		co2 = st.co2 + change*mass_stoic.co2))

new_st = pyruv_to_lact(pyr_st)
end

function acetate_heterolactate(st; goal = (; glucose = 0.0))
stoic = (glucose = -1, pyruvate = +1, acetate = +1, hydrogen = +3, co2 = +2)
mass_stoic = (glucose = stoic.glucose*m_glucose(),
		pyruvate = stoic.pyruvate*m_pyruvate(),
		acetate = stoic.acetate*m_acetate(),
		hydrogen = stoic.hydrogen*m_hydrogen(),
		co2 = stoic.co2*m_co2())
goal.glucose <= st.glucose || error("Glucose is not sufficient for this goal")
change = (goal.glucose - st.glucose)/mass_stoic.glucose
pyr_st = merge(st,
		(glucose = goal.glucose,
		pyruvate = st.pyruvate + change*mass_stoic.pyruvate,
		acetate = st.acetate + change*mass_stoic.acetate,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
		co2 = st.co2 + change*mass_stoic.co2))

new_st = pyruv_to_lact(pyr_st)
end


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

function bifidus_ferment(st; goal = (; glucose = 0.0))
stoic = (glucose = -1, acetate = +1.5, pyruvate = +1, hydrogen = +1)
mass_stoic = (glucose = stoic.glucose*m_glucose(),
		acetate = stoic.acetate*m_acetate(),
		pyruvate = stoic.pyruvate*m_pyruvate(),
		hydrogen = stoic.hydrogen*m_hydrogen())
goal.glucose <= st.glucose || error("Glucose is not sufficient for this goal")
change = (goal.glucose - st.glucose)/mass_stoic.glucose
pyr_st = merge(st,
		(glucose = goal.glucose,
		pyruvate = st.pyruvate + change*mass_stoic.pyruvate,
		acetate = st.acetate + change*mass_stoic.acetate,
		hydrogen = st.hydrogen + change*mass_stoic.hydrogen))

new_st = pyruv_to_lact(pyr_st)
end

function ethanol_fermentation(st; goal = (; glucose = 0.0))
stoic = (glucose = -1, ethanol = +2, co2 = +2)
mass_stoic = (glucose = stoic.glucose*m_glucose(),
		ethanol = stoic.ethanol*m_ethanol(),
		co2 = stoic.co2*m_co2())
goal.glucose <= st.glucose || error("Glucose is not sufficient for this goal")
change = (goal.glucose - st.glucose)/mass_stoic.glucose
new_st = merge(st,
		(glucose = goal.glucose,
		ethanol = st.ethanol + change*mass_stoic.ethanol,
		co2 = st.co2 + change*mass_stoic.co2))
end

function aerobic_pyruvate_oxidation(st; goal = (; oxygen = 0.0))
    stoic = (pyruvate = -1, water = -3, oxygen = -2, co2 = +3, hydrogen = +5)
    mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
		  water = stoic.water*m_water(),
		  oxygen = stoic.oxygen*m_oxygen(),
		  co2 = stoic.co2*m_co2(),
		  hydrogen = stoic.hydrogen*m_hydrogen())
    goal.oxygen <= st.oxygen || error("Oxygen is not sufficient for this goal")
    change = (goal.oxygen - st.oxygen)/mass_stoic.oxygen
    abs(change*mass_stoic.pyruvate) <= st.pyruvate || error("Pyruvate is not sufficient for this goal")
    new_st = merge(st,
		   (oxygen = goal.oxygen,
		    pyruvate = st.pyruvate + change*mass_stoic.pyruvate,
		    water = st.water + change*mass_stoic.water,
		    co2 = st.co2 + change*mass_stoic.co2,
		    hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end
