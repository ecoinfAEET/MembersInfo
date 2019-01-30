
library(dplyr)

library(googledrive)
drive_download(file = as_id("1InBc8vpbZiQS9Bs8dDd2DPft8kJq4z0M7n0UeVPbP8g"),
               path = "Formdata.csv", type = "csv", overwrite = TRUE)

## read data
formdata <- readr::read_csv("Formdata.csv")
allmembers <- readr::read_csv("MembersInfo.csv")

## add new members to membersinfo.csv
newmembers <- dplyr::filter(formdata, !Timestamp %in% allmembers$Timestamp)
if (nrow(newmembers) > 0) {
  newmembers$lat <- NA
  newmembers$lon <- NA
  stopifnot(ncol(newmembers) == ncol(membersinfo))
  allmembers <- dplyr::bind_rows(allmembers, newmembers)
}


## get locations for map
# library(opencage)  # requires free API key
#
# nocoords <- dplyr::filter(allmembers, is.na(lat) | is.na(lon)) %>%
#   dplyr::select(`Afiliación`) %>%
#   distinct()
#
# georef <- lapply(nocoords$Afiliación, opencage_forward, language = "es",
#                  limit = 1, countrycode = "ES",
#                  no_annotations = TRUE, no_record = TRUE,
#                  add_request = FALSE)
# nocoords$lon <- unlist(lapply(georef, function(x) {y <- x$results$geometry.lng; y[is.null(y)] <- NA; y}))
# nocoords$lat <- unlist(lapply(georef, function(x) {y <- x$results$geometry.lat; y[is.null(y)] <- NA; y}))
#
#
# allmembers <- allmembers %>%
#   dplyr::filter(is.na(lat) | is.na(lon)) %>%
#   dplyr::select(-lon, -lat) %>%
#   left_join(nocoords, by = "Afiliación") %>%
#   bind_rows(dplyr::filter(allmembers, !is.na(lat)))



readr::write_csv(allmembers, "MembersInfo.csv")


## render
rmarkdown::render("index.Rmd", encoding = "UTF-8")


