
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
function glycolysis(st, goal)
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
# CO2 + 2H2 -> Succinate is the other pathway for propionate, but
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

function acetate_synth(st, goal)
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

function butyrate_synth(st, goal)
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

function mixed_acid_ferment(st, goal, a)
    pyr_st = glycolysis(st, goal)
    acet_goal = (; pyruvate = pyr_st.pyruvate*(1-a))
    but_goal = (; pyruvate = pyr_st.pyruvate*a)
    acet_st = acetate_synth(pyr_st, acet_goal)
    but_st = butyrate_synth(pyr_st, but_goal)
    new_st = merge(pyr_st,
                   (pyruvate = pyr_st.pyruvate - acet_st.pyruvate - but_st.pyruvate,
                    water = acet_st.water,
                    acetate = acet_st.acetate,
                    butyrate = but_st.butyrate,
                    co2 = acet_st.co2 + but_st.co2,
                    hydrogen = acet_st.hydrogen))
end

    
