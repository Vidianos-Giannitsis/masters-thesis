
# Primitive to calculate molar mass
function molar_mass(; C=0, H=0, O=0, N=0, S=0)
mass = 12C + H + 16O + 14N + 32S
return mass
end

# Calculate the molar masses of all used substances
function m_glucose()
molar_mass(C=6, H=12, O=6)
end

function m_fructose()
molar_mass(C=6, H=12, O=6)
end

function m_sucrose()
molar_mass(C=12, H=24, O=12)
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

function m_acetone()
molar_mass(C=3, H=6, O=1)
end

function m_butanol()
molar_mass(C=4, H=10, O=1)
end

function m_valerate()
molar_mass(C=5, H=10, O=2)
end

# Define an initial state. The system will expect this to be in mass
# value and not concentration for sake of simplicity. We can however
# define a function that does the conversion so both can work.
# state = (glucose = 16.0, pyruvate = 0.0, hydrogen = 0.0, water = 700.0, co2 = 0.0,
#         acetate = 0.0, propionate = 0.0, butyrate = 0.0, ethanol = 0.0,
#         lactate = 0.0, succinate = 0.0, formate = 0.0, acetaldehyde = 0.0,
#         fructose = 0.0, sucrose = 0.0, butanol = 0.0, acetone = 0.0,
#         valerate = 0.0, oxygen = 0.0)

function conc_to_mass(st, volume)
new_st = NamedTuple{keys(st)}(values(st).*volume)
end
# We also ideally want output in concentration, so ideally we also
# want the opposite conversion.
function mass_to_conc(st, volume)
new_st = NamedTuple{keys(st)}(values(st)./volume)
end

