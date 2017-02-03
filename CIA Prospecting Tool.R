
#########################################################
## Import MZG files - Through Sep 2016
#########################################################

library(readxl)
mzg.july.2016     <- read_excel("~/Data/CIA Prospecting Tool/Input/MZG_JULY_2016_RAW.xlsx", sheet = 1)
dma               <- read_excel("~/Data/CIA Prospecting Tool/Input/MZG_JULY_2016_RAW.xlsx", sheet = 2)
sales.territories <- read_excel("~/Data/CIA Prospecting Tool/Input/MZG_JULY_2016_RAW.xlsx", sheet = 3)

is(mzg.july.2016)

#########################################################
## Pull in new businesses (last updated through August) #
#########################################################
NewLeads_AllMarkets_GC <- read_excel("~/Data/CIA Prospecting Tool/Input/NewLeads_AllMarkets_GC.xlsx", sheet = 1)

names(mzg.july.2016)
names(NewLeads_AllMarkets_GC)

##################################################################
## Check to see if any Counties have specific naming conventions #
##################################################################
setdiff(mzg.july.2016$CountyDescription, dma$NAME)
mzg.july.2016$CountyDescription <- ifelse(mzg.july.2016$CountyDescription=="San Ls Obispo","San Luis Obispo", mzg.july.2016$CountyDescription)
table(mzg.july.2016$CountyDescription)

##################################################################
## Cut down on columns to stack
##################################################################
mzg.july.2016.red <- mzg.july.2016[,c("DownloadDate", "ObsoleteDate", "Source", "BusinessName", "MailingAddress","MailingCity",
                                      "MailingState", "MailingZipCode", "MailingZip4", "MailingDeliveryPointBarcode", "MailingCarrierRoute",
                                      "StreetAddress", "City", "State", "ZipCode", "Zip4", "CarrierRoute", "DeliveryPointBarcode", 
                                      "CountyDescription", "CbsaCode", "CbsaDescription", "PrimarySicCode", "PrimarySicDescription",
                                      "SicCode1", "SicDescription1", "SicCode2", "SicDescription2", "NaicsCode1",	"NaicsDescription1",
                                      "Latitude",	"Longitude", "AbiNumber", "ProfessionalTitle", "TitleDescription", "FirstName", "LastName",
                                      "GenderCode", "Fax", "Phone", "YearFirstAppeared", "BusinessStatusDescription", "WebAddress", 
                                      "ActualEmployees", "EmployeeSizeDescription", "ActualSalesVolume", "AnnualSalesVolumeDescription", 
                                      "CreditAlphaScoreCode", "CreditNumericScore", "OfficeSizeDescription", "SquareFootageDescription", 
                                      "PublicPrivateDescription", "PCDescription", "IndustrySpecificDescription", "AdSizeDescription",
                                      "ExpenseAdDescription")]

mzg.july.2016.red$Market <- "SAC BEE MZG July Sep"
mzg.july.2016.red$FullAddress <- do.call("paste", mzg.july.2016.red[,c("StreetAddress", "City", "State", "ZipCode", "Zip4")])
mzg.july.2016.red$New.Established <- "Established"
mzg.july.2016.red$Record_Production_Date <- 20160901

#########################################################
 # Prep for stack
#########################################################
names(NewLeads_AllMarkets_GC) <- c("ROWIDD", "DownloadDate", "ObsoleteDate", "Source", "BusinessName", "StreetAddress", "City",  
                                   "State", "ZipCode", "Zip4", "Zipcode4", "DeliveryPointBarcode", "MailingCarrierRoute", "CountyDescription", 
                                   "Phone", "SALUTATION", "Contact_Full_Name", "LastName","FirstName", "TitleDescription", "GenderCode", 
                                   "WORKSITE_TYPE",  "BUSINESS_TYPE",  
                                   "PrimarySicCode", "PrimarySicDescription", "BRANCH_CODE", "Record_Production_Date", "Market", 
                                   "FullAddress", "Latitude", "Longitude")

NewLeads_AllMarkets_GC.red <- NewLeads_AllMarkets_GC[, c("DownloadDate", "ObsoleteDate", "Source", "BusinessName", "StreetAddress", "City",  
                                                        "State", "ZipCode", "DeliveryPointBarcode", "MailingCarrierRoute", "CountyDescription", 
                                                        "Phone", "LastName","FirstName", "TitleDescription", "GenderCode", 
                                                        "PrimarySicCode", "PrimarySicDescription", "Record_Production_Date", "Market", 
                                                        "FullAddress", "Latitude", "Longitude")]

####################################################################
# Add columns to New Biz files that exist in the Existing Biz file
####################################################################
NewLeads_AllMarkets_GC.red$New.Established <- "New"

NewLeads_AllMarkets_GC.red[,setdiff(names(mzg.july.2016.red), names(NewLeads_AllMarkets_GC.red))] <- rep("NA", length(setdiff(names(mzg.july.2016.red), names(NewLeads_AllMarkets_GC.red))))
head(NewLeads_AllMarkets_GC.red)

####################################################################
# Rbind the files
####################################################################
new.old.stack <- rbind(as.data.frame.matrix(mzg.july.2016.red), as.data.frame.matrix(NewLeads_AllMarkets_GC.red))
head(new.old.stack)

####################################################################
## Check number of rows the merge should give
####################################################################
nrow(mzg.july.2016)
nrow(dma)

####################################################################
## Check to see if any Counties have specific naming conventions
####################################################################
test <- merge(new.old.stack, dma, by.x = "CountyDescription", by.y="NAME", all.x=T)
nrow(test)
head(test)

####################################################################
# Zip code merge
####################################################################
setdiff(mzg.july.2016$ZipCode, sales.territories$Zip_Code)
test2 <- merge(test, sales.territories, by.x = "ZipCode", by.y="Zip_Code", all.x=T)
table(test2$Rep)
names(test2)

test2$SICDesc.Code <- paste(test2$PrimarySicDescription, test2$PrimarySicCode, sep=" - ")
test2$FullName <- paste(test2$FirstName, test2$LastName, sep=" ")

head(test2$SICDesc.Code)


write.csv(test2, "~/Data/CIA Prospecting Tool/Output/MZG_July_2016_R.csv", row.names = F)



rm(test,dma,mzg.july.2016,mzg.july.2016.red,sales.territories, test2, new.old.stack, NewLeads_AllMarkets_GC.red,NewLeads_AllMarkets_GC)