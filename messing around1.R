library(plyr)
require(utils)

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

import.list$Market <- strsplit(import.list$Source, "New Leads - ")[2]

## geocode
geocode <- function(address,reverse=FALSE)  {
  require("RJSONIO")
  baseURL <- "http://maps.google.com/maps/api/geocode/json?sensor=false&"
  
  # This is not necessary, 
  # because the parameter "address" accepts both formatted address and latlng
  
  conURL <- ifelse(reverse,paste0(baseURL,'latlng=',URLencode(address)),
                   paste0(baseURL,'address=',URLencode(address)))  
  con <- url(conURL)  
  data.json <- fromJSON(paste(readLines(con), collapse=""))
  close(con) 
  status <- data.json["status"]
  if(toupper(status) == "OK"){
    t(sapply(data.json$results,function(x) {
      list(address=x$formatted_address,lat=x$geometry$location[1],
           lng=x$geometry$location[2])}))
  } else { 
    warning(status)
    NULL 
  }
}

#i<-1
x <- list()
#for(i in 1:length(addresses)){
for(i in 1:1500){
  print(i)
  x[[i]] <- geocode(addresses[[i]])
}
warnings()
is(x)
write.csv(import.list, "~/Data/Infogroup/NewLeads.AllMarkets.csv")

## Remove
rm(files, filenames, df.list, final.df)
