
# Glycolysis is the metabolic pathway in which glucose is broken down
# into energy, pyruvate and hydrogen (in the form of NADH). Pyruvate
# is the intermediate from which all reactions occur.
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

# But glucose is not the only substrate. We also need to describe how
# sucrose breaks down to glucose and fructose, as well as how fructose
# enters the EMP pathway. During that pathway, glucose breaks down to
# dihydroxyacetone-phosphate and glyceraldehyde-3-phosphate the latter
# of which gives pyruvate. During fructolysis, the same amount of ATP
# is used to create 2 moles of glyceraldehyde-3-phosphate, but through
# a different pathway. For simplicity purposes, since this system only
# lists the key intermediates which we measure, we will assume that
# fructose isomerises to glucose, despite knowing that its not the
# actual mechanism, as mass balance wise (on which mass balance this
# is based), it is not incorrect. The goal will be fructose
# consumption as fructose can be measured to see how much entered the
# EMP pathway.

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

# Then, we can write reactions of pyruvate into products when produced
# in the EMP pathway. Trying to avoid unnecessary intermediates, this
# includes: Pyruvate -> Acetaldehyde + CO2, which then goes to
# Acetaldehyde + H2 -> Ethanol using the hydrogen produced from
# glycolysis. Pyruvate + Water -> Acetate + CO2 + H2, which is the
# core reaction and pathway for acetate production. For butyrate
# production, writing the intermediates will be confusing, so write it
# directly. 2Pyruvate -> Butyrate + 2CO2, where 2 CO2 and 2 H2 are
# removed to go from Pyruvate to Acetyl-CoA twice, because then 2
# Acetyl-CoA are used for Acetoacetyl-CoA, which is then reduced to
# butyryl-CoA and then directly to Butyrate. These reduction steps
# take both the hydrogens from the Acetyl-CoA oxidation. Then,
# Pyruvate + H2 -> Lactate which is an important reaction. Lactate +
# H2 -> Propionate which is one of the propionate pathways. Pyruvate +
# CO2 + H2 -> Succinate is the other pathway for propionate, but since
# succinate can be noticed as an intermediate that is retained, I will
# include it. From Pyruvate, a CO2 is taken in order to produce
# succinate and 2 reduction steps are needed. This CO2 is given from
# succinate as it breaks down to propionate usually. So for propionate
# the reaction is Succinate + CO2 -> Propionate, which is why CO2
# isn't even seen in the Propionate production pathway as it is
# commonly self contained. Then, for ABE, write 2Pyruvate + 2H_2 ->
# Water + Butanol + 2CO_2 and 2Pyruvate + Water -> 3 CO2 + 2 H_2 +
# Acetone. Lastly, formate balance with CO2 and H2 will be mentioned.
# All of these reactions will be written with pyruvate concentration
# as the goal, which can be generated from glycolysis. 

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

