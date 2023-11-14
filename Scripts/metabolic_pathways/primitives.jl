
# Primitive to calculate molar mass
function molar_mass(; C=0, H=0, O=0, N=0, S=0)
    mass = 12C + H + 16O + 14N + 32S
    return mass
end

# Calculate the molar masses of all used substances
function m_glucose()
    molar_mass(C=6, H=12, O=6)
end

function m_pyruvate()
    molar_mass(C=3, H=4, O=3)
end

function m_hydrogen()
    molar_mass(H=2)
end

function m_co2()
    molar_mass(C=1, O=2)
end

function m_water()
    molar_mass(H=2, O=1)
end

function m_acetate()
    molar_mass(C=2, H=4, O=2)
end

function m_propionate()
    molar_mass(C=3, H=6, O=2)
end

function m_butyrate()
    molar_mass(C=4, H=8, O=2)
end

function m_ethanol()
    molar_mass(C=2, H=6, O=1)
end

function m_lactate()
    molar_mass(C=3, H=6, O=3)
end

function m_succinate()
    molar_mass(C=4, H=6, O=4)
end

function m_formate()
    molar_mass(C=1, H=2, O=2)
end

function m_acetaldehyde()
    molar_mass(C=2, H=4, O=1)
end

# Define an initial state
state = (glucose = 16.0, pyruvate = 0.0, hydrogen = 0.0, water = 700.0, co2 = 0.0,
         acetate = 0.0, propionate = 0.0, butyrate = 0.0, ethanol = 0.0,
         lactate = 0.0, succinate = 0.0, formate = 0.0, acetaldehyde = 0.0)

# Glycolysis is the metabolic pathway in which glucose is broken down
# into energy, pyruvate and hydrogen (in the form of NADH). Pyruvate
# is the intermediate from which all reactions occur.
function glycolysis(st; goal = (; glucose = 0.0))
    stoic = (glucose = -1, pyruvate = +2, hydrogen = +2)
    mass_stoic = (glucose = stoic.glucose*m_glucose(),
                  pyruvate = stoic.pyruvate*m_pyruvate(),
                  hydrogen = stoic.hydrogen*m_hydrogen())
    change = (goal.glucose - st.glucose)/mass_stoic.glucose
    new_st = merge(st,
                   (glucose = goal.glucose,
                    pyruvate = st.pyruvate + change*mass_stoic.pyruvate,
                    hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

# Reactions to write down (trying to avoid including many
# intermediates and things with CoA). Pyruvate -> Acetaldehyde + CO2,
# which then goes to Acetaldehyde + H2 -> Ethanol using the hydrogen
# produced from glycolysis. Pyruvate + Water -> Acetate + CO2 + H2,
# which is the core reaction and pathway for acetate production. For
# butyrate production, writing the intermediates will be confusing, so
# write it directly. 2Pyruvate -> Butyrate + 2CO2, where 2 CO2 and 2
# H2 are removed to go from Pyruvate to Acetyl-CoA twice, because then
# 2 Acetyl-CoA are used for Acetoacetyl-CoA, which is then reduced to
# butyryl-CoA and then directly to Butyrate. These reduction steps
# take both the hydrogens from the Acetyl-CoA oxidation. Then,
# Pyruvate + H2 -> Lactate which is an important reaction. Lactate +
# H2 -> Propionate which is one of the propionate pathways. Pyruvate +
# CO2 + H2 -> Succinate is the other pathway for propionate, but
# since succinate can be noticed as an intermediate that is retained,
# I will include it. From Pyruvate, a CO2 is taken in order to produce
# succinate and 2 reduction steps are needed. This CO2 is given from
# succinate as it breaks down to propionate usually. So for propionate
# the reaction is Succinate + CO2 -> Propionate, which is why CO2
# isn't even seen in the Propionate production pathway as it is
# commonly self contained. Lastly, formate balance with CO2 and H2
# will be mentioned. Maybe Butanol and Acetone are listed eventually
# but not as a priority. All of these reactions will be written with
# pyruvate concentration as the goal, which can be generated from
# glycolysis. After, we need to define the backwards pass of all these
# functions, were the goal is the product of its reaction and try to
# go to glucose backwards. But that's harder so let's implement
# forward first.

function pyruv_to_acetate(st; goal = (; pyruvate = 0.0))
    stoic = (pyruvate = -1, water = -1, acetate= +1, hydrogen = +1, co2=+1)
    mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
                  water = stoic.water*m_water(),
                  acetate = stoic.acetate*m_acetate(),
                  hydrogen = stoic.hydrogen*m_hydrogen(),
                  co2 = stoic.co2*m_co2())
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
    change = (goal.acetaldehyde - st.acetaldehyde)/mass_stoic.acetaldehyde
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
    change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
    new_st = merge(st,
                   (pyruvate = goal.pyruvate,
                    butyrate = st.butyrate + change*mass_stoic.butyrate,
                    co2 = st.co2 + change*mass_stoic.co2))
end

function pyruv_to_lact(st; goal = (; pyruvate = 0.0))
    stoic = (pyruvate = -1, hydrogen = -1, lactate = +1)
    mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
                  hydrogen = stoic.hydrogen*m_hydrogen(),
                  lactate = stoic.lactate*m_lactate())
    change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
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
    change = (goal.lactate - st.lactate)/mass_stoic.lactate
    new_st = merge(st,
                   (lactate = goal.lactate,
                    hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
                    propionate = st.propionate + change*mass_stoic.propionate))
end

function pyruv_to_succin(st, goal = (; pyruvate = 0.0))
    stoic = (pyruvate = -1, co2 = -1, hydrogen = -1, succinate = +1)
    mass_stoic = (pyruvate = stoic.pyruvate*m_pyruvate(),
                  co2 = stoic.co2*m_co2(),
                  hydrogen = stoic.hydrogen*m_hydrogen(),
                  succinate = stoic.succinate*m_succinate())
    change = (goal.pyruvate - st.pyruvate)/mass_stoic.pyruvate
    new_st = merge(st,
                   (pyruvate = goal.pyruvate,
                    co2 = st.co2 + change*mass_stoic.co2,
                    hydrogen = st.hydrogen + change*mass_stoic.hydrogen,
                    succinate = st.succinate + change*mass_stoic.succinate))
end 

function succin_to_propionate(st; goal = (; succinate = 0.0))
    stoic = (succinate = -1, propionate = +1, co2 = +1)
    mass_stoic = (succinate = stoic.succinate*m_succinate(),
                  propionate = stoic.propionate*m_propionate(),
                  co2 = stoic.co2*m_co2())
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
    new_st = merge(st,
                   (formate = goal.formate,
                    co2 = st.co2 + change*mass_stoic.co2,
                    hydrogen = st.hydrogen + change*mass_stoic.hydrogen))
end

# Then, we need to combine some reactions to write the full reactions
# of pyruvate to ethanol and pyruvate to propionate. Propionate also
# needs another function as to talk about propionate, we need to talk
# about lactate production and there's two pathways for lactate
# production, homolactate and heterolactate.
function pyruv_to_ethanol(st; pyr_goal = (; pyruvate = 0.0),
                          acet_goal = (; acetaldehyde = 0.0))
    acetaldehyde_st = pyruv_to_acetaldehyde(st, pyr_goal)
    new_st = acetaldehyde_to_ethanol(acetaldehyde_st, acet_goal)
end

function homolactic_ferment(st; goal = (; glucose = 0.0))
    pyr_st = glycolysis(st, goal)
    new_st = pyruv_to_lact(pyr_st)
end

function heterolactic_ferment(st; goal = (; glucose = 0.0))
    pyr_st = glycolysis(st, goal)
    eth_goal = (; pyruvate = pyr_st.pyruvate/2)
    lact_goal = (; pyruvate = pyr_st.pyruvate/2)

    eth_st = pyruv_to_ethanol(pyr_st, pyr_goal = eth_goal)
    lact_st = pyruv_to_lact(pyr_st, goal = lact_goal)
    new_st = merge(pyr_st,
                   (pyruvate = pyr_st.pyruvate - eth_st.pyruvate - lact_st.pyruvate,
                    hydrogen = pyr_st.hydrogen - eth_st.hydrogen - lact_st.hydrogen,
                    ethanol = eth_st.ethanol,
                    lactate = lact_st.lactate,
                    co2 = eth_st.co2))
end

function gluc_to_lact(st, het_amount; goal = (; glucose = 0.0))
    homo_goal = (; glucose = (st.glucose - (st.glucose - goal.glucose)*(1-het_amount)))
    het_goal = (; glucose = (st.glucose - (st.glucose - goal.glucose)*(het_amount)))

    homo_st = homolactic_ferment(st, goal = homo_goal)
    het_st = heterolactic_ferment(st, goal = het_goal)
    new_st = merge(st,
                   (glucose = goal.glucose,
                    hydrogen = st.hydrogen - homo_st.hydrogen - het_st.hydrogen,
                    lactate = homo_st.lactate + het_st.lactate,
                    ethanol = het_st.ethanol,
                    co2 = het_st.co2))
end

function gluc_to_succin(st; goal = (; glucose = 0.0))
    pyr_st = glycolysis(st, goal)
    new_st = pyruv_to_succin(pyr_st)
end

function gluc_to_propionate(st, lact_amount, hetlact_amount;
                            gluc_goal = (; glucose = 0.0),
                            lact_goal = (; lactate = 0.0),
                            succin_goal = (; succinate = 0.0))
    lact_prod_goal = (; glucose = (st.glucose - (st.glucose - gluc_goal.glucose)*lact_amount))
    succin_prod_goal = (; glucose = (st.glucose - (st.glucose - gluc_goal.glucose)*(1-lact_amount)))

    lact_st = gluc_to_lact(st, hetlact_amount, goal = lact_prod_goal)
    succin_st = gluc_to_succin(st, goal = succin_prod_goal)
    prop_st1 = lact_to_propionate(lact_st, goal = lact_goal)
    prop_st2 = succin_to_propionate(succin_st, goal = succin_goal)

    new_st = merge(st,
                   (glucose = gluc_goal.glucose,
                    lactate = lact_goal.lactate,
                    succinate = succin_goal.succinate,
                    propionate = prop_st1.propionate + prop_st2.propionate,
                    hydrogen = prop_st1.hydrogen + prop_st2.hydrogen,
                    co2 = prop_st1.co2 + prop_st2.co2,
                    ethanol = prop_st1.ethanol))
end

# Then, we can move on to writing complete reactions from the
# Acetyl-CoA pathways. 1 mol of glucose, through this pathway, can
# become 1 mol of butyrate, 2 moles of acetate, 2 moles of ethanol or
# 1 mol of acetate and 1 of ethanol.
function gluc_to_butyr(st; goal = (; glucose = 0.0))
    pyr_st = glycolysis(st, goal)
    new_st = pyruv_to_butyr(pyr_st)
end

    
