

#Desde aqui les voy diciendo sorry por los comentarios realmente tontos. Los he marcado con -T- al principio jajajja 

library(tidyverse)
library(ggplot2)
library(gargle)

#Cargando las variables desde la carpeta local - Google Sheets tardaba muchisimo

getwd()

diversidad_2017<-read.csv("diversity_data_2017.csv", stringsAsFactors = FALSE)
glimpse(diversidad_2017)


# -T- Las subi como factor porque es un ranking
ranking_2017<-read.csv("best_places_diversity_2017.csv",stringsAsFactors = TRUE)
glimpse(ranking_2017)

#Ver y limpiar la base 
#-T- names y colnames hacen lo mismo? Parece que si
colnames(diversidad_2017)
names(diversidad_2017)

#Cambiar nombre columna name a empresa
prueba<-rename(diversidad_2017