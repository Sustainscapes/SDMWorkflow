library(targets)

options(tidyverse.quiet = TRUE)

source("R/functions_data_cleaning.R")

tar_option_set(packages = c("dplyr","magrittr", "occOutliers","purrr", "readr", "rgbif","taxize", "terra"))
list(
  tar_target(
    raw_data_file,
    "data/SpeciesMin.csv",
    format = "file"
  ),
  tar_target(
    Occs,
    Taxa_validation_and_retrieval(raw_data_file)
  ),
  tar_target(Cleaned_taxonomy,
             Occs$Cleanded),
  tar_target(
    raw_spatial_file,
    "data/Worldclim.tif",
    format = "file"
  ),
  tar_target(Stack,
             raster::stack(raw_spatial_file)),
  tar_target(Cleaned_data,
             Clean_Occurrences(Occurrences = Occs$Occs, Stack = Stack))
)
