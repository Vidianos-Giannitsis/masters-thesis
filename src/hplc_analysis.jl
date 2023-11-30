using DataFrames, CSV, StatsPlots

function make_neg_zero(num)
    if num <= 0
        return 0
    else
        return num
    end
end

function sucrose(a)
    C = @. (a - 5131.12)/130943.83
    C = map(make_neg_zero, C)
end

function glucose(a)
    C = @. (a - 7899.51)/264251.52
    C = map(make_neg_zero, C)
end

function fructose(a)
    C = @. (a + 11335.7)/270115.2
    C = map(make_neg_zero, C)
end

function lactate(a)
    C = @. (a - 0.946)/1521.642
    C = map(make_neg_zero, C)
end

function acetate(a)
    C = @. (a + 0.684)/1092.079
    C = map(make_neg_zero, C)
end

function propionate(a)
    C = @. (a + 25.17)/1060.057
    C = map(make_neg_zero, C)
end

function ethanol(a)
    C = @. (a - 8775.42)/113284.075
    C = map(make_neg_zero, C)
end

function plot_conc(t, C, title, fig_name)
    p = scatter(t, C)
    title!(title)
    xlabel!("t (min)")
    ylabel!("C (g/l)")
    savefig(p, fig_name)
end

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

