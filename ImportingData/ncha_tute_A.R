library(tidyverse)

j <- read_csv("CellExperiment/Multilabelling_20160610_proj/field--X00--ctrl/cell_outlines.csv")
j
spec(j)
j$num_normLog2_num_ATUB_tophat_cell_min_intensity
col_spec <- cols(.default = col_double())

j <- read_csv("CellExperiment/Multilabelling_20160610_proj/field--X00--ctrl/cell_outlines.csv",
              col_types = col_spec)

csvfiles <- list.files(path = "CellExperiment", pattern = glob2rx("*.csv"), recursive = TRUE, full.names = TRUE)

ex <- csvfiles[22]

basename(ex)
field <- basename(dirname(ex))

word(ex, start=-2, sep=fixed("/"))
D <- word(ex, start=-3, sep=fixed("/"))

D <- word(D, 2, sep="_")
D <- as.Date(D, format="%Y%m%d")
lubridate::wday(D, label=TRUE)
