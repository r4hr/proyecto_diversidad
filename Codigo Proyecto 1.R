library(tidyverse)
library(ggplot2)
library(googlesheets4)
library(gargle)


#Guarde la data en la carpeta compartida de Drive
best_places_diversity_2017<-sheets_read("https://docs.google.com/spreadsheets/d/1JXYQnRbevDvJ7ZFBQVXGQrxE2d5LEpP62zBxn1BkOkg/edit#gid=0",skip=2)
head(best_places_diversity_2017)


Diversity_2017<-sheets_read("https://docs.google.com/spreadsheets/d/1JXYQnRbevDvJ7ZFBQVXGQrxE2d5LEpP62zBxn1BkOkg/edit#gid=0",sheet="Diversity_2017",skip=2)
head(Diversity_2017)

#testing making a change and uploading

testingdata<-read.csv("diversity_data.csv")

