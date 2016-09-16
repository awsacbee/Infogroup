library(plyr)
require(utils)
library(RJSONIO)
library(reshape)

## import
stop("need to set.diff each month")


files <- list.files(path = "~/Data/Infogroup/")
filenames <- paste("~/Data/Infogroup/", files, sep="")

read_csv_filename <- function(filename){
  ret <- read.csv(filename)
  ret$Source <- filename #EDIT
  ret
}

import.list <- ldply(filenames, read_csv_filename)
head(import.list)

import.list$Source

import.list$Market <- sapply(lapply(strsplit(import.list$Source, "New Leads - "), "[", 2), paste, collapse=" ")
names(import.list)
head(import.list)

import.list$FullAddress <- do.call("paste", import.list[,c("ADDRESS","CITY", "STATE", "ZIP.CODE")])
head(import.list$FullAddress)
head(import.list)

## Filter down to only include Sacramento Bee
addresses <- import.list[grep("SAC BEE", import.list$Market),c("FullAddress")]
head(addresses)
sum(addresses>0)

write.csv(import.list, "~/Data/CombinedInfoGroup/NewLeads.AllMarkets.csv")

##############################
## Fill in with our Geocode
##############################

## Remove
rm(files, filenames, df.list, final.df)
