using DataFrames, CSV, StatsPlots

"""
    make_neg_zero(num)

Make `num` zero if it is less than 0.

This has an application in the code below as the HPLC calibration
curves may give negative concentrations for very small signals, but
the cause of that is that it is not well calibrated at very small
concentrations. These values can be safely considered 0 concentration
however, and this function implements that.
"""
function make_neg_zero(num)
    if num <= 0
        return 0
    else
        return num
    end
end

"""
    sucrose(a)

Make `a` into a concentration vector.

The `a` given is a vector of areas and through the calibration curve
it can be converted to sucrose concentration.
"""
function sucrose(a)
    C = @. (a - 5131.12)/130943.83
    C = map(make_neg_zero, C)
end

"""
    glucose(a)

Make `a` into a concentration vector.

The `a` given is a vector of areas and through the calibration curve
it can be converted to glucose concentration.
"""
function glucose(a)
    C = @. (a - 7899.51)/264251.52
    C = map(make_neg_zero, C)
end


"""
    fructose(a)

Make `a` into a concentration vector.

The `a` given is a vector of areas and through the calibration curve
it can be converted to fructose concentration.
"""
function fructose(a)
    C = @. (a + 11335.7)/270115.2
    C = map(make_neg_zero, C)
end

"""
    lactate(a)

Make `a` into a concentration vector.

The `a` given is a vector of areas and through the calibration curve
it can be converted to lactate concentration.
"""
function lactate(a)
    C = @. (a - 0.946)/1521.642
    C = map(make_neg_zero, C)
end

"""
    acetate(a)

Make `a` into a concentration vector.

The `a` given is a vector of areas and through the calibration curve
it can be converted to acetate concentration.
"""
function acetate(a)
    C = @. (a + 0.684)/1092.079
    C = map(make_neg_zero, C)
end

"""
    propionate(a)

Make `a` into a concentration vector.

The `a` given is a vector of areas and through the calibration curve
it can be converted to propionate concentration.
"""
function propionate(a)
    C = @. (a + 25.17)/1060.057
    C = map(make_neg_zero, C)
end

"""
    ethanol(a)

Make `a` into a concentration vector.

The `a` given is a vector of areas and through the calibration curve
it can be converted to ethanol concentration.
"""
function ethanol(a)
    C = @. (a - 8775.42)/113284.075
    C = map(make_neg_zero, C)
end

"""
    create_conc_table(df, table_name)

Create a CSV named `table_name` containing concentrations.

`df` is a dataframe containing area information and through the
functions above, it is converted to a table of concentrations which
then writes to CSV.
"""
function create_conc_table(df, table_name)
    data_vector = [df.Time', sucrose(df.Sucrose)', glucose(df.Glucose)',
                   fructose(df.Fructose)', lactate(df.Lactate)',
                   acetate(df.Acetate)', propionate(df.Propionate)',
                   ethanol(df.Ethanol)', df.pH', df.EC']
    data_matrix = reduce(hcat, transpose.(data_vector))
    data_table = Tables.table(data_matrix, header = [:Time, :Sucrose, :Glucose,
                                                     :Fructose, :Lactate,
                                                     :Acetate, :Propionate,
                                                     :Ethanol, :pH, :EC])
    CSV.write(table_name, data_table)
end

"""
    create_conc_table2(df, table_name)

Create a CSV named `table_name` containing concentrations.

The difference of this function to the `create_conc_table` is that
this function does not expect pH or EC to be in the dataframe. These
were not measured in the experiment of 23/10 so this function was
necessary to analyze that. Otherwise it is fully equivalent to it.
"""
function create_conc_table2(df, table_name)
    data_vector = [df.Time', sucrose(df.Sucrose)', glucose(df.Glucose)',
                   fructose(df.Fructose)', lactate(df.Lactate)',
                   acetate(df.Acetate)', propionate(df.Propionate)',
                   ethanol(df.Ethanol)']
    data_matrix = reduce(hcat, transpose.(data_vector))
    data_table = Tables.table(data_matrix, header = [:Time, :Sucrose, :Glucose,
                                                     :Fructose, :Lactate,
                                                     :Acetate, :Propionate,
                                                     :Ethanol])
    CSV.write(table_name, data_table)
end

"""
    process_area_data(area, conc)

Create `conc` from `area` and read it into a dataframe.

`area` is a CSV file containing area information which is converted to
`conc`, another CSV file via `create_conc_table`. The output of the
function is a dataframe for the concentration data.
"""
function process_area_data(area, conc)
    df_area = CSV.read(area, DataFrame)
    create_conc_table(df_area, conc)
    df_conc = CSV.read(conc, DataFrame)
end

"""
    process_area_data2(area, conc)

Create `conc` from `area` and read it into a dataframe.

This is equivalent to `process_area_data` but uses
`create_conc_table2` instead of `create_conc_table`. For more info,
read the docstrings of the according functions.
"""
function process_area_data2(area, conc)
    df_area = CSV.read(area, DataFrame)
    create_conc_table2(df_area, conc)
    df_conc = CSV.read(conc, DataFrame)
end

"""
    get_area_csv(date, amount)

Helper function to get file names for area CSVs.
"""
function get_area_csv(date, amount)
    datadir("exp_raw", "hplc_area_"*date*"_"*amount*".csv")
end

"""
    get_conc_csv(date, amount)

Helper function to get file names for conc CSVs.
"""
function get_conc_csv(date, amount)
    datadir("exp_pro", "hplc_conc_"*date*"_"*amount*".csv")
end

"""
    get_plot_name(name, date, plot_type)

Helper function to name generated plots.

The plot should go in plotsdir, in the subdirectory of the date and
have a filename of name_plot_type_date.png which helps making plots
more streamlined.
"""
function get_plot_name(name, date, plot_type)
    plotsdir(date, name*"_"*plot_type*"_"*date*".png")
end

