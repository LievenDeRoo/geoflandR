#loading libraries
library(httr)
library(ggplot2)
library(ggmap)
library(jsonlite)
library(rjson)
library(sp)
library(tmap)
##core function for geocoding based on Flanders geocoding services
geo_flandR<-function(csvFile, street, number, city, header=TRUE){
  input<-as.data.frame(read.csv(csvFile,sep=";", header=header))
  data<-as.data.frame(input)
  for (i in 1:nrow(data)){
  url<-paste0("http://loc.geopunt.be/v3/location?q=",street[i],"%20",number[i],",","%20",city[i])
  resp<-GET(url)
  coordinaties<-content(resp, as="text")
  json <- lapply(X=coordinaties, fromJSON)
  json<-as.data.frame(json)
  #storing the results#
  data$Lat_WGS84[i]<-json$LocationResult.Location$Lat_WGS84
  data$Lon_WGS84[i]<-json$LocationResult.Location$Lon_WGS84
  }
return(data)
print(data)
}

test<-geo_flandR(input,input$street, input$number, input$city)


####nice to have but not really necessary
lon<-test$Lat_WGS84[1]
lat<-test$Lon_WGS84[1]
map1<-get_map(location = c(lat, lon), zoom=14)
ggmap(map1)+
  geom_point(aes(Lon_WGS84,Lat_WGS84), data=test)