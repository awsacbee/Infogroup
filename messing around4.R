## Import MZG files

library(readxl)
mzg.july.2016 <- read_excel("~/Data/MZG/MZG_JULY_2016_RAW.xlsx", sheet = 1)
dma <- read_excel("~/Data/MZG/MZG_JULY_2016_RAW.xlsx", sheet = 2)
sales.territories <- read_excel("~/Data/MZG/MZG_JULY_2016_RAW.xlsx", sheet = 3)

names(mzg.july.2016)

## Check to see if any Counties have specific naming conventions
setdiff(mzg.july.2016$CountyDescription, dma$NAME)
mzg.july.2016$CountyDescription <- ifelse(mzg.july.2016$CountyDescription=="San Ls Obispo","San Luis Obispo", mzg.july.2016$CountyDescription)
table(mzg.july.2016$CountyDescription)

## Check number of rows the merge should give
nrow(mzg.july.2016)
nrow(dma)

## Check to see if any Counties have specific naming conventions
test <- merge(mzg.july.2016, dma, by.x = "CountyDescription", by.y="NAME")
nrow(test)
head(test)

#Zip code merge
setdiff(mzg.july.2016$ZipCode, sales.territories$Zip_Code)
test <- merge(test, sales.territories, by.x = "ZipCode", by.y="Zip_Code")
table(test$Rep)

write.csv(test, "~/Data/MZG/MZG_July_2016_R.csv", row.names = T)

## Pull in new businesses


rm(test,dma,mzg.july.2016,sales.territories)