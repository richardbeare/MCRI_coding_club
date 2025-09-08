library(tidyverse)

#git2r::clone("https://github.com/richardbeare/MCRI_coding_club.git", "MCRI_coding_club")
#git2r::pull()

# Introduce some programming concepts via a data importing exercise.
# Hopefully at least partly convinced that importing into R is
# useful due to the visualization possibilities. To date we've
# used a dataset that was set up for us. Today we'll be looking
# at creating our own.
# How programming buys us freedom from scale and repeatability.
# How to break down a problem into parts, package those parts,
# then repeat them.

# Lets start by looking at this dataset. It is mostly real, from Volker Hilsenstein
# at Monash Micro Imaging. Output of cell profiler.
# Automatically produced, lots of files with the same format.
# Note that there is important information in the pathnames that
# we want to include in the final data set.

# Begin by loading one file to take a look


# Lots of columns, no special types - everything a number
colspec <- cols(.default=col_double())

j <- read_csv("CellExperiment/Multilabelling_20160609_proj/field--X00--ctlr3/cell_outlines.csv", 
              col_types = colspec)
# Now we know that we can read one of them OK.
# we don't want to type in all the names. How do we avoid this

csvfiles <- list.files(path="CellExperiment/", pattern=glob2rx("*.csv"), 
                       recursive = TRUE, full.names = TRUE)

# We want to get all this data into one "thing" in R (a dataframe/tibble), so that we can plot
# it

## Thing computers are best at
## Loops and repeated actions


for (idx in 1:length(csvfiles)) {
  print(idx)
}


## Start with a traditional looking loop (which we'll throw away later)
## base R
destination <- list()

for (idx in 1:length(csvfiles)) {
  destination[[idx]] <- read_csv(csvfiles[idx], col_types = colspec)
}

finaltable <- do.call(rbind, destination)

# apply family
destination <- lapply(csvfiles, read_csv, col_types = colspec)
finaltable <- do.call(rbind, destination)


# purrr

destination <- map(csvfiles, read_csv, col_types = colspec)
destination <- map(csvfiles, ~read_csv(.x, col_types = colspec))

finaltable <- map_df(csvfiles, read_csv, col_types = colspec)

###
## Diversion - saving the list of names in case more data comes back later
writeLines(csvfiles, "files_tested_at_stage_X.txt")
csvfiles <- readLines("files_tested_at_stage_X.txt")
##

# Doesn't matter how many files there are, provided we can
# get a listing of the names.

# More work to do.
# foldernames contain important information
# Date, field and treatment

ex <- csvfiles[100]
ex

# working with paths
# tools inspired by bash
basename(ex)
dirname(ex)

# cool thing - vectorized
dirname(csvfiles)

d <- dirname(ex)
field <- basename(d)
D <- basename(dirname(d))


# stringr package, part of tidyverse
# equivalent things in base R, but not quite as friendly
# two different ways of doing the same thing
a <- str_split(field, pattern=fixed("--"))
#a <- str_split(csvfiles, pattern="--")
a[[1]]
a[[1]][1]
a[[1]][2]
a[[1]][3]

b <- word(D, 2, sep = fixed("_"))


D <- as.Date(D, format="%Y%m%d")
lubridate::wday(D, label=TRUE)
# Further reading - regular expressions for text manipulation

read_cell_summary <- function(fname) {
  if (!file.exists(fname)) {
    warning(paste("Missing ", fname))
    return(NULL)
  }
  d <- dirname(fname)
  field <- basename(d)
  D <- basename(dirname(d))
  a <- str_split(field, pattern = fixed("--"))
  field <- a[[1]][2]
  treatment <- a[[1]][3]
  DT <- word(D, 2, sep=fixed("_"))
  DT <- as.Date(DT, format="%Y%m%d")
  colspec <- cols(.default=col_double())
  tbl <- read_csv(fname, col_types = colspec)
  tbl <- mutate(tbl, Field = field, Treatment = treatment, Date = DT, origfile=fname)
  tbl <- select(tbl, Treatment, Date, Field, everything())
  return(tbl)
}

finaltable <- map_df(csvfiles, read_cell_summary)

# ready to summarize and plot

# Lessons setting up your own data
# Column names - valid R variables
# Can be added later (for example in the function)
# Make sure tables have identical structure.
# Don't have to be text - could be excel.
