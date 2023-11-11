using DataFrames, CSV, StatsPlots

function make_neg_zero(vec)
    for i in length(vec)
        if vec[i] <= 0
            vec[i] = 0
        end
    end
    vec
end


function sucrose(a)
    C = @. (a - 5131.12)/130943.83
    C = make_neg_zero(C)
end

function glucose(a)
    C = @. (a - 7899.51)/264251.52
    C = make_neg_zero(C)
end

function fructose(a)
    C = @. (a + 11335.7)/270115.2
    C = make_neg_zero(C)
end

function lactate(a)
    C = @. (a - 0.946)/1521.642
    C = make_neg_zero(C)
end

function acetate(a)
    C = @. (a + 0.684)/1092.079
    C = make_neg_zero(C)
end

function propionate(a)
    C = @. (a + 25.17)/1060.057
    C = make_neg_zero(C)
end

function ethanol(a)
    C = @. (a - 8775.42)/113284.075
    C = make_neg_zero(C)
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

function create_plots(df, fig_name)
    t = df.Time
    plot_conc(t, sucrose(df.Sucrose), "Sucrose Concentration", "Sucrose " * fig_name)
    plot_conc(t, glucose(df.Glucose), "Glucose Concentration", "Glucose " * fig_name)
    plot_conc(t, fructose(df.Fructose), "Fructose Concentration", "Fructose " * fig_name)
    plot_conc(t, lactate(df.Lactate), "Lactate Concentration", "Lactate " * fig_name)
    plot_conc(t, acetate(df.Acetate), "Acetate Concentration", "Acetate " * fig_name)
    plot_conc(t, propionate(df.Propionate), "Propionate Concentration", "Propionate " * fig_name)
    plot_conc(t, ethanol(df.Ethanol), "Ethanol Concentration", "Ethanol " * fig_name)
end


