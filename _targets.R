library(targets)

options(tidyverse.quiet = TRUE)

source("R/functions_data_cleaning.R")

tar_option_set(packages = c("dplyr","magrittr","purrr", "readr", "rgbif","taxize"))
list(
  tar_target(
    raw_data_file,
    "data/Species.csv",
    format = "file"
  ),
  tar_target(
    raw_data,
    read_csv(raw_data_file, col_types = cols())
  ),
  tar_target(
    cleaned_presences,
    Data_retrieval_and_cleaning(raw_data)
  )
)
