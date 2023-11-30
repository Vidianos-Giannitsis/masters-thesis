
function cod_equiv(; C=0, H=0, O=0, N=0)
    cod = (16*(2C+0.5H-1.5N-O))/(12C+H+16O+14N)
end

function cod_glucose()
    cod_equiv(C=6, H=12, O=6)
end

function cod_fructose()
    cod_equiv(C=6, H=12, O=6)
end

function cod_sucrose()
    cod_equiv(C=12, H=24, O=12)
end

function cod_acetate()
    cod_equiv(C=2, H=4, O=2)
end

function cod_propionate()
    cod_equiv(C=3, H=6, O=2)
end

function cod_ethanol()
    cod_equiv(C=2, H=6, O=1)
end

function cod_lactate()
    cod_equiv(C=3, H=6, O=3)
end

function abs_to_cod(abs; dilution = 50)
    cod = @. (2380.407*abs - 19.339)/20
end
