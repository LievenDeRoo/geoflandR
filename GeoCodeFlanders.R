#loading libraries
library(httr)
library(ggplot2)
library(ggmap)
library(jsonlite)
library(rjson)
library(sp)
library(tmap)
##core function for geocoding based on Flanders geocoding services
csvFile<-c("C:/Users/ldro/Documents/Example Dataset/geocode.csv")
geo_flandR<-function(csvFile, street, number, city, header=TRUE){
  input<-as.data.frame(read.csv(csvFile,sep=";", header=header, stringsAsFactor=FALSE))
  data<-as.data.frame(input)
  for (i in 1:nrow(data)){
    url<-paste0("http://loc.geopunt.be/v3/location?q=",data[i,street],"%20",data[i,number],",","%20",data[i,city])
    resp<-GET(url)
    coordinaties<-content(resp, as="text")
    json <- lapply(X=coordinaties, fromJSON)
    json<-as.data.frame(json)
    #storing the results#
    data$Lat_WGS84[i]<-json$LocationResult.Location.Lat_WGS84
    data$Lon_WGS84[i]<-json$LocationResult.Location.Lon_WGS84
  }
return(data)
}
test<-geo_flandR(csvFile, "straat", "nummer", "gemeente")



####nice to have but not really necessary
lon<-mean(test$Lat_WGS84[1])
lat<-mean(test$Lon_WGS84[1])
map1<-get_map(location = c(lat, lon), zoom=13)
ggmap(map1)+
  geom_point(aes(Lon_WGS84,Lat_WGS84),col="red", data=test)
