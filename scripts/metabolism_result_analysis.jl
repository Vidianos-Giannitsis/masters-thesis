using DrWatson
@quickactivate "Masters_Thesis"
using JLD2
include(srcdir("metabolic_pathways", "metabolism_results.jl"))

data_dir = wload(datadir("simulations", "metabolic_pathways.jld2"))

st35_0, df35_0, p35_0, v = data_dir["35_0"]
st35_1, df35_1, p35_1, v = data_dir["35_1"]
st35_2, df35_2, p35_2, v = data_dir["35_2"]
st35_4, df35_4, p35_4, v = data_dir["35_4"]
st35_8, df35_8, p35_8, v = data_dir["35_8"]

st40_0, df40_0, p40_0, v = data_dir["40_0"]
st40_1, df40_1, p40_1, v = data_dir["40_1"]
st40_2, df40_2, p40_2, v = data_dir["40_2"]
st40_4, df40_4, p40_4, v = data_dir["40_4"]
st40_8, df40_8, p40_8, v = data_dir["40_8"]

# Convenience code wrapping the process
function generate_flux_tables(st, df, p, v)
    rflux = reaction_fluxes(st, df, p, v)
    cflux = complete_fluxes(st, df, p, v)
    readflux = readable_flux_table(st, df, p, v)
    absflux = absolute_flux_table(st, df, p, v)

    rflux_t = Tables.table(rflux, header = [:SucHyd, :Glycolysis, :Heterolact, :PyrOx, :Acet, :Lact, :Eth, :Aceteth, :Prop, :Acetogenesis])
    cflux_t = Tables.table(cflux, header = [:Init, :SucHyd, :Glycolysis, :Heterolact, :PyrOx, :Acet, :Lact, :Eth, :Aceteth, :Prop, :Acetogenesis, :Final])
    absflux_t = Tables.table(absflux, header = [:Init, :SucHyd, :Glycolysis, :Heterolact, :PyrOx, :Acet, :Lact, :Eth, :Aceteth, :Prop, :Acetogenesis, :Final])

    # The readable flux table already has headers so that process
    # isn't necessary for it.
    return rflux_t, cflux_t, readflux, absflux_t
end

# Example generation of the tables
rflux35_0, cflux35_0, readflux35_0, absflux35_0 = generate_flux_tables(st35_0, df35_0, p35_0, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table35_0.csv"), rflux35_0)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table35_0.csv"), cflux35_0)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table35_0.csv"), readflux35_0)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table35_0.csv"), absflux35_0)

# Doing it for the rest of the datasets.
rflux35_1, cflux35_1, readflux35_1, absflux35_1 = generate_flux_tables(st35_1, df35_1, p35_1, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table35_1.csv"), rflux35_1)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table35_1.csv"), cflux35_1)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table35_1.csv"), readflux35_1)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table35_1.csv"), absflux35_1)

rflux35_2, cflux35_2, readflux35_2, absflux35_2 = generate_flux_tables(st35_2, df35_2, p35_2, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table35_2.csv"), rflux35_2)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table35_2.csv"), cflux35_2)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table35_2.csv"), readflux35_2)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table35_2.csv"), absflux35_2)

rflux35_4, cflux35_4, readflux35_4, absflux35_4 = generate_flux_tables(st35_4, df35_4, p35_4, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table35_4.csv"), rflux35_4)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table35_4.csv"), cflux35_4)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table35_4.csv"), readflux35_4)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table35_4.csv"), absflux35_4)

rflux35_8, cflux35_8, readflux35_8, absflux35_8 = generate_flux_tables(st35_8, df35_8, p35_8, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table35_8.csv"), rflux35_8)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table35_8.csv"), cflux35_8)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table35_8.csv"), readflux35_8)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table35_8.csv"), absflux35_8)

rflux40_0, cflux40_0, readflux40_0, absflux40_0 = generate_flux_tables(st40_0, df40_0, p40_0, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table40_0.csv"), rflux40_0)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table40_0.csv"), cflux40_0)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table40_0.csv"), readflux40_0)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table40_0.csv"), absflux40_0)

rflux40_1, cflux40_1, readflux40_1, absflux40_1 = generate_flux_tables(st40_1, df40_1, p40_1, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table40_1.csv"), rflux40_1)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table40_1.csv"), cflux40_1)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table40_1.csv"), readflux40_1)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table40_1.csv"), absflux40_1)

rflux40_2, cflux40_2, readflux40_2, absflux40_2 = generate_flux_tables(st40_2, df40_2, p40_2, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table40_2.csv"), rflux40_2)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table40_2.csv"), cflux40_2)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table40_2.csv"), readflux40_2)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table40_2.csv"), absflux40_2)

rflux40_4, cflux40_4, readflux40_4, absflux40_4 = generate_flux_tables(st40_4, df40_4, p40_4, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table40_4.csv"), rflux40_4)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table40_4.csv"), cflux40_4)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table40_4.csv"), readflux40_4)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table40_4.csv"), absflux40_4)

rflux40_8, cflux40_8, readflux40_8, absflux40_8 = generate_flux_tables(st40_8, df40_8, p40_8, v)
CSV.write(datadir("simulations", "flux_tables", "reaction_flux_table40_8.csv"), rflux40_8)
CSV.write(datadir("simulations", "flux_tables", "complete_flux_table40_8.csv"), cflux40_8)
CSV.write(datadir("simulations", "flux_tables", "readable_flux_table40_8.csv"), readflux40_8)
CSV.write(datadir("simulations", "flux_tables", "absolute_flux_table40_8.csv"), absflux40_8)

f35_0 = generate_metabolic_graph(st35_0, df35_0, p35_0, v, T = "35 C", mix = "0 ml")
save(plotsdir("metabolic_results", "35_0.png"), f35_0)
f35_1 = generate_metabolic_graph(st35_1, df35_1, p35_1, v, T = "35 C", mix = "1 ml")
save(plotsdir("metabolic_results", "35_1.png"), f35_1)
f35_2 = generate_metabolic_graph(st35_2, df35_2, p35_2, v, T = "35 C", mix = "2 ml")
save(plotsdir("metabolic_results", "35_2.png"), f35_2)
f35_4 = generate_metabolic_graph(st35_4, df35_4, p35_4, v, T = "35 C", mix = "4 ml")
save(plotsdir("metabolic_results", "35_4.png"), f35_4)
f35_8 = generate_metabolic_graph(st35_8, df35_8, p35_8, v, T = "35 C", mix = "8 ml")
save(plotsdir("metabolic_results", "35_8.png"), f35_8)

f40_0 = generate_metabolic_graph(st40_0, df40_0, p40_0, v, T = "40 C", mix = "0 ml")
save(plotsdir("metabolic_results", "40_0.png"), f40_0)
f40_1 = generate_metabolic_graph(st40_1, df40_1, p40_1, v, T = "40 C", mix = "1 ml")
save(plotsdir("metabolic_results", "40_1.png"), f40_1)
f40_2 = generate_metabolic_graph(st40_2, df40_2, p40_2, v, T = "40 C", mix = "2 ml")
save(plotsdir("metabolic_results", "40_2.png"), f40_2)
f40_4 = generate_metabolic_graph(st40_4, df40_4, p40_4, v, T = "40 C", mix = "4 ml")
save(plotsdir("metabolic_results", "40_4.png"), f40_4)
f40_8 = generate_metabolic_graph(st40_8, df40_8, p40_8, v, T = "40 C", mix = "8 ml")
save(plotsdir("metabolic_results", "40_8.png"), f40_8)

gluc_fluxes = [p35_0[1], p35_1[1], p35_2[1], p35_4[1], p35_8[1], p40_0[1], p40_1[1], p40_2[1], p40_4[1], p40_8[1]]
x = 1:length(gluc_fluxes)
ticklabels = ["35 C\n 0 ml", "35 C\n 1 ml", "35 C\n 2 ml", "35 C\n 4 ml", "35 C\n 8 ml", "40 C\n 0 ml", "40 C\n 1 ml", "40 C\n 2 ml", "40 C\n 4 ml", "40 C\n 8 ml"]

het_plot = barplot(x, gluc_fluxes,
		   axis = (xticks = (x, ticklabels),
			   title = "% of Glucose Consumed in Heterolactic Fermentation",
			   limits = (nothing, (0.0, 0.9))))
save(plotsdir("metabolic_results", "heterolactate_flux.png"), het_plot)

lact_cons35_0 = lactate_dist(st35_0, df35_0, p35_0, v)[3]
lact_cons35_1 = lactate_dist(st35_1, df35_1, p35_1, v)[3]
lact_cons35_2 = lactate_dist(st35_2, df35_2, p35_2, v)[3]
lact_cons35_4 = lactate_dist(st35_4, df35_4, p35_4, v)[3]
lact_cons35_8 = lactate_dist(st35_8, df35_8, p35_8, v)[3]

lact_cons40_0 = lactate_dist(st40_0, df40_0, p40_0, v)[3]
lact_cons40_1 = lactate_dist(st40_1, df40_1, p40_1, v)[3]
lact_cons40_2 = lactate_dist(st40_2, df40_2, p40_2, v)[3]
lact_cons40_4 = lactate_dist(st40_4, df40_4, p40_4, v)[3]
lact_cons40_8 = lactate_dist(st40_8, df40_8, p40_8, v)[3]

lact_fluxes = abs.([lact_cons35_0, lact_cons35_1, lact_cons35_2, lact_cons35_4, lact_cons35_8, lact_cons40_0, lact_cons40_1, lact_cons40_2, lact_cons40_4, lact_cons40_8])

prop_35_p = barplot(x[1:5], lact_fluxes[1:5],
		    axis = (xticks = (x[1:5], ticklabels[1:5]),
			    title = "% of Lactate Reduced to Propionate - 35 C"))

prop_40_p = barplot(x[6:10], lact_fluxes[6:10],
		    axis = (xticks = (x[6:10], ticklabels[6:10]),
			    title = "% of Lactate Reduced to Propionate - 40 C"))

save(plotsdir("metabolic_results", "propionate_flux_35.png"), prop_35_p)
save(plotsdir("metabolic_results", "propionate_flux_40.png"), prop_40_p)

pyr35_0 = pyruvate_cons_dist(st35_0, df35_0, p35_0, v)
pyr35_1 = pyruvate_cons_dist(st35_1, df35_1, p35_1, v)
pyr35_2 = pyruvate_cons_dist(st35_2, df35_2, p35_2, v)
pyr35_4 = pyruvate_cons_dist(st35_4, df35_4, p35_4, v)
pyr35_8 = pyruvate_cons_dist(st35_8, df35_8, p35_8, v)

pyr40_0 = pyruvate_cons_dist(st40_0, df40_0, p40_0, v)
pyr40_1 = pyruvate_cons_dist(st40_1, df40_1, p40_1, v)
pyr40_2 = pyruvate_cons_dist(st40_2, df40_2, p40_2, v)
pyr40_4 = pyruvate_cons_dist(st40_4, df40_4, p40_4, v)
pyr40_8 = pyruvate_cons_dist(st40_8, df40_8, p40_8, v)

labels = ["Kreb's Cycle", "Acetate", "Lactate", "Ethanol", "Acetate/Ethanol\n type Fermentation"]
colors = Makie.wong_colors()[1:length(labels)]

pyr_ind_f = Figure(size=(600, 400))
Label(pyr_ind_f[1,1:3], "Pyruvate Flux Distribution for the \nindigenous microorganisms", fontsize = 20, font = :bold)
ax1, plt = pie(pyr_ind_f[2,1], pyr35_0, color = colors, axis = (aspect=DataAspect(), title = "35 C"))
ax2, plt = pie(pyr_ind_f[2,2], pyr40_0, color = colors, axis = (aspect=DataAspect(), title = "40 C"))
Legend(pyr_ind_f[2,3], [PolyElement(color=c) for c in colors], labels, framevisible=false)
hidedecorations!(ax1)
hidedecorations!(ax2)
hidespines!(ax1)
hidespines!(ax2)
save(plotsdir("metabolic_results", "pyr_flux_ind.png"), pyr_ind_f)

pyr_flux_f = Figure(size = (1350, 900))
Label(pyr_flux_f[1,1:3], "Pyruvate Flux Distribution", fontsize = 32, font = :bold)
Label(pyr_flux_f[2, 1:3], "Temperature = 35 C", fontsize = 25)

ax1, plt = pie(pyr_flux_f[3,1], pyr35_0, color = colors, axis = (aspect=DataAspect(), title = "0 ml", titlesize = 20))
ax2, plt = pie(pyr_flux_f[3,2], pyr35_1, color = colors, axis = (aspect=DataAspect(), title = "1 ml", titlesize = 20))
ax3, plt = pie(pyr_flux_f[3,3], pyr35_2, color = colors, axis = (aspect=DataAspect(), title = "2 ml", titlesize = 20))
ax4, plt = pie(pyr_flux_f[4,1], pyr35_4, color = colors, axis = (aspect=DataAspect(), title = "4 ml", titlesize = 20))
ax5, plt = pie(pyr_flux_f[4,2], pyr35_8, color = colors, axis = (aspect=DataAspect(), title = "8 ml", titlesize = 20))
hidedecorations!(ax1)
hidedecorations!(ax2)
hidedecorations!(ax3)
hidedecorations!(ax4)
hidedecorations!(ax5)
hidespines!(ax1)
hidespines!(ax2)
hidespines!(ax3)
hidespines!(ax4)
hidespines!(ax5)
Legend(pyr_flux_f[4:6,3], [PolyElement(color=c) for c in colors], labels, framevisible=false, labelsize = 22)

Label(pyr_flux_f[5, 1:3], "Temperature = 40 C", fontsize= 25)

ax6, plt = pie(pyr_flux_f[6,1], pyr40_0, color = colors, axis = (aspect=DataAspect(), title = "0 ml", titlesize = 20))
ax7, plt = pie(pyr_flux_f[6,2], pyr40_1, color = colors, axis = (aspect=DataAspect(), title = "1 ml", titlesize = 20))
ax8, plt = pie(pyr_flux_f[7,1], pyr40_2, color = colors, axis = (aspect=DataAspect(), title = "2 ml", titlesize = 20))
ax9, plt = pie(pyr_flux_f[7,2], pyr40_4, color = colors, axis = (aspect=DataAspect(), title = "4 ml", titlesize = 20))
ax10, plt = pie(pyr_flux_f[7,3], pyr40_8, color = colors, axis = (aspect=DataAspect(), title = "8 ml", titlesize = 20))
hidedecorations!(ax5)
hidedecorations!(ax6)
hidedecorations!(ax7)
hidedecorations!(ax8)
hidedecorations!(ax9)
hidedecorations!(ax10)
hidespines!(ax5)
hidespines!(ax6)
hidespines!(ax7)
hidespines!(ax8)
hidespines!(ax9)
hidespines!(ax10)

save(plotsdir("metabolic_results", "pyr_flux_tot.png"), pyr_flux_f)
