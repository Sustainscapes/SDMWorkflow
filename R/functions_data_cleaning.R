Taxa_validation_and_retrieval <-  function(Taxa_file){
  Cleanded <- read_csv(Taxa_file, col_types = cols()) %>%
    dplyr::pull(Name) %>%
    taxize::gnr_resolve(data_source_ids = "11", canonical = TRUE, best_match_only = T) %>%
    dplyr::filter(score > 0.9) %>%
    dplyr::pull(matched_name2) %>%
    rgbif::name_backbone_checklist()

  Taxon_Keys <- Cleanded %>%
    dplyr::pull(usageKey) %>%
    unique()

   Occs <- rgbif::occ_data(taxonKey = Taxon_Keys,
                  hasCoordinate = T,
                  continent = "europe",
                  hasGeospatialIssue=FALSE,
                  limit = 100000) #%>%

   for(i in 1:length(Occs)){
     Occs[[i]] <- Occs[[i]]$data
   }

   Occs <- Occs %>%
     purrr::map(~dplyr::mutate(.x, occurrenceStatus = stringr::str_to_lower(occurrenceStatus))) %>%
                  purrr::map(~dplyr::filter(.x, occurrenceStatus == "present")) %>%
                  purrr::map(~dplyr::select(.x, matches(c("scientificName", "decimalLatitude", "decimalLongitude",
                                                  "issues", "basisOfRecord", "acceptedScientificName", "iucnRedListCategory",
                                                  "coordinateUncertaintyInMeters","year","countryCode", "country", "habitat"))))
                  return(list(Occs = Occs, Cleanded = Cleanded))
}

Clean_Occurrences <- function(Occurrences, Stack){
  StackSpat <- rast(Stack)
  ## Remove NAs
  #  for(i in 1:length(Occurrences)){
  #  Coords <- Occurrences[[i]] %>%
  #    dplyr::select(decimalLongitude, decimalLatitude) %>%
  #    dplyr::rename(lon = decimalLongitude,
  #                  lat = decimalLatitude)
  #  Extracted <- terra::extract(StackSpat, Coords)
  #  Extracted <- Extracted[complete.cases(Extracted),]
  #  Occurrences[[i]][Extracted$ID,]
  #}
  ## Remove Spatial and Geografical outlayers
  #CleanedOccurrences <- list()

  #for(i in 1:length(Occurrences)){
  #  CleanedOccurrences[[i]] <- Occurrences[[i]]
  #}
  return(StackSpat)
}
