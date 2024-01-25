prod45 = select(df45_1, 1, 5:8)

# Day 0
d0_prod = prod45[1:7, 2:5]
std_d0 = std.(eachcol(d0_prod))
# Corrected ethanol std
std_eth = std(prod45[2:7, 5])
std_d0[4] = std_eth

# Day 1
d1_prod = prod45[8:10, 2:5]
std_d1 = std.(eachcol(d1_prod))

# Day 2
d2_prod = prod45[11:13, 2:5]
std_d2 = std.(eachcol(d2_prod))

# Day 3
d3_prod = prod45[14:16, 2:5]
std_d3 = std.(eachcol(d3_prod))
# Corrected acetate std
std_acet = std([prod45[14, 3], prod45[16, 3]])
std_d3[2] = std_acet

std_final = mean([std_d0, std_d1, std_d2, std_d3])
