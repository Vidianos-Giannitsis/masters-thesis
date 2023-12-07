using CSV, DataFrames, StatsPlots

"""
    cod_equiv(; C=0, H=0, O=0, N=0)

Calculate the COD equivalent of a compound.

Given the carbon, hydrogen, oxygen and nitrogen in a compound, this
function gives the conversion factor between its concentration and
cod_equivalent.
"""
function cod_equiv(; C=0, H=0, O=0, N=0)
    cod = (16*(2C+0.5H-1.5N-O))/(12C+H+16O+14N)
end

"""
    cod_glucose()

Calculate the cod equivalent of glucose.
"""
function cod_glucose()
    cod_equiv(C=6, H=12, O=6)
end

"""
    cod_fructose()

Calculate the cod equivalent of fructose.
"""
function cod_fructose()
    cod_equiv(C=6, H=12, O=6)
end

"""
    cod_sucrose()

Calculate the cod equivalent of sucrose.
"""
function cod_sucrose()
    cod_equiv(C=12, H=24, O=12)
end

"""
    cod_acetate()

Calculate the cod equivalent of acetate.
"""
function cod_acetate()
    cod_equiv(C=2, H=4, O=2)
end

"""
    cod_propionate()

Calculate the cod equivalent of propionate.
"""
function cod_propionate()
    cod_equiv(C=3, H=6, O=2)
end

"""
    cod_ethanol()

Calculate the cod equivalent of ethanol.
"""
function cod_ethanol()
    cod_equiv(C=2, H=6, O=1)
end

"""
    cod_lactate()

Calculate the cod equivalent of lactate.
"""
function cod_lactate()
    cod_equiv(C=3, H=6, O=3)
end

"""
    abs_to_cod(abs; dilution)

Convert absorbance to COD.

This function defines a calibration curve made for converting
absorbance to COD taking in mind dilution. A default value of 20 is
supplied as 1:20 dilutions are fairly common in COD.
"""
function abs_to_cod(abs; dilution = 20)
    cod = @. (2380.407*abs - 19.339)/dilution
end

"""
    process_cod_data(data_num, date; dilution)

Process absorbance data to COD.

A useful helper function that finds raw cod data based on the number
and date it has, collects the absorbance from it and converts it to
COD with `abs_to_cod`, which is the value it returns. However, it also
creates a CSV file where it saves the COD data it made, which is
stored in `datadir` in the processed experimental data directory.
"""
function process_cod_data(data_num, date; dilution = 20) 
    df = CSV.read(datadir("exp_raw", "cod_data_"*data_num*"_"*date*".csv"), DataFrame)
    abs_cod = df.Abs_COD
    COD = abs_to_cod(abs_cod, dilution = dilution)
    cod_table = Tables.table(COD, header = [:COD])
    CSV.write(datadir("exp_pro", "cod_"*data_num*"_"*date*".csv"), cod_table)

    return COD
end
