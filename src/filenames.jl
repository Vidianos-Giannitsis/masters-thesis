using DrWatson
@quickactivate "Masters_Thesis"

"""
    get_area_csv(date, amount)

Helper function to get file names for hplc area CSVs.
"""
function get_area_csv(date, amount)
    datadir("exp_raw", "hplc_area_"*date*"_"*amount*".csv")
end

"""
    get_conc_csv(date, amount)

Helper function to get file names for hplc conc CSVs.
"""
function get_conc_csv(date, amount)
    datadir("exp_pro", "hplc_conc_"*date*"_"*amount*".csv")
end

"""
    get_cod_csv(date)

Helper function to get file names for cod CSVs.

If there are multiple files in a day, the num keyword argument can be
used to get the correct one. Note that num should have an underscore
after the number as well.
"""
function get_cod_csv(date; num = "")
    datadir("exp_pro", "cod_"*num*date*".csv")
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


