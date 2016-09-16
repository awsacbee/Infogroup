require(downloader)
library(dplyr)
year_start=08252016
year_last=as.integer(format(Sys.Date(), "%Y"))


for (i in year_start:year_last){
  
  if (i==2012){
    url<-"http://www.nber.org/fda/faers/2012/demo2012q4.csv.zip"
    
    download(url,dest="data.zip")
    unzip ("data.zip")
  }
  
  else{
    if (i<year_last){
      j=c(1:4)
      
      for (m in j){
        
        url<-paste0("http://www.nber.org/fda/faers/",i,"/demo",i,"q",m,".csv.zip")
        
        download(url,dest="data.zip")
        unzip ("data.zip")
      }
    }
    
    else if (i==year_last){
      j=c(1:2)
      for (m in j){
        
        url<-paste0("http://www.nber.org/fda/faers/",i,"/demo",i,"q",m,".csv.zip")
        
        download(url,dest="data.zip")
        unzip ("data.zip")
        
      }
    }
    
  }
  
}