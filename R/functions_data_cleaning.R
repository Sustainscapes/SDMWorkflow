Data_retrieval_and_cleaning <-  function(Taxa_file){
  Taxon_keys <- read_csv(Taxa_file, col_types = cols()) %>%
    dplyr::pull(Name) %>%
    taxize::gnr_resolve(raw_data$Name, data_source_ids = "11", canonical = TRUE, best_match_only = T) %>%
    dplyr::filter(score > 0.9) %>%
    dplyr::pull(matched_name2) %>%
    rgbif::name_backbone_checklist() %>%
    dplyr::pull(usageKey) %>%
    unique()

   Occs <- rgbif::occ_data(taxonKey = Taxon_keys,
                  hasCoordinate = T,
                  continent = "europe",
                  hasGeospatialIssue=FALSE,
                  limit = 100000) %>%
                  purrr::map(~.x$data) %>%
                  purrr::map(~dplyr::mutate(.x, occurrenceStatus = stringr::str_to_lower(occurrenceStatus)))
                  purrr::map(~dplyr::filter(.x, occurrenceStatus == "present")) %>%
                  purrr::map(~dplyr::select(.x, "scientificName", "decimalLatitude", "decimalLongitude",
                                                  "issues", "basisOfRecord", "acceptedScientificName", "iucnRedListCategory",
                                                  "coordinateUncertaintyInMeters","year","countryCode", "country", "habitat"))
}
