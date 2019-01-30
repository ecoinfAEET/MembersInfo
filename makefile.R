
library(googledrive)
drive_download(file = as_id("1InBc8vpbZiQS9Bs8dDd2DPft8kJq4z0M7n0UeVPbP8g"),
               path = "Formdata.csv", type = "csv", overwrite = TRUE)

## read data
formdata <- readr::read_csv("Formdata.csv")
membersinfo <- readr::read_csv("MembersInfo.csv")

## add new members to membersinfo.csv
newmembers <- dplyr::filter(formdata, !Timestamp %in% membersinfo$Timestamp)
stopifnot(ncol(newmembers) == ncol(membersinfo))
allmembers <- dplyr::bind_rows(membersinfo, newmembers)

readr::write_csv(allmembers, "MembersInfo.csv")


## render
rmarkdown::render("index.Rmd", encoding = "UTF-8")


