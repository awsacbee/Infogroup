library(plyr)
require(utils)
library(RJSONIO)
library(reshape)

## import
stop("need to set.diff each month")


files.2016 <- list.files(path = "~/Data/Infogroup/InfoGroupNewLeads/2016/")
files.2017 <- list.files(path = "~/Data/Infogroup/InfoGroupNewLeads/")
filenames.2016 <- paste("~/Data/Infogroup/InfoGroupNewLeads/2016/", files.2016, sep="")
filenames.2017 <- paste("~/Data/Infogroup/InfoGroupNewLeads/", files.2017, sep="")

## stack 2016 and 2017 and check that they all imported
filenames <- c(filenames.2017, filenames.2016)
length(filenames)
is(filenames)

read_csv_filename <- function(filename){
  ret <- read.csv(filename)
  ret$Source <- filename #EDIT
  ret
}

import.list <- sapply(filenames, read_csv_filename)
head(import.list)

ret <- read.csv(filenames[1])
ret$Source <- filenames[1]
ret
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
