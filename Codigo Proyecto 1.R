

#Desde aqui les voy diciendo sorry por los comentarios realmente tontos

library(tidyverse)
library(ggplot2)
library(gargle)

#Cargando las variables desde la carpeta local - Google Sheets tardaba muchisimo

getwd()

#Agregando na.strings... leyo los datos como int en lugar de chr :) 

diversidad_2017_orig<-read.csv("diversity_data_2017.csv", stringsAsFactors = FALSE,na.strings = c("n/a","NaN", " "))
glimpse(diversidad_2017_orig)
str(diversidad_2017_orig)


# Las subi como factor porque es un ranking
ranking_2017<-read.csv("best_places_diversity_2017.csv",stringsAsFactors = TRUE)
glimpse(ranking_2017)

##### Ver y limpiar la base ####
#names y colnames hacen lo mismo? Parece que si
colnames(diversidad_2017_orig)
names(diversidad_2017_orig)

#Cambiar nombres a las columnas: name a empresa
prueba<-rename(diversidad_2017_orig, empresa = name)
names(prueba)

#Quedarse con los que tienen la data completa 
prueba<-filter(prueba,data.avail=="Y")
dim(prueba)

#Quitar columnas de urls
prueba<-select(prueba,-data.url,-diversity.pg.url)
dim(prueba)


#Leer el diccionario de datos para entender las demas variables

####Encontrar los porcentajes de poblacion femenina por empresa####
p1<-totales$FT10/totales$TOTAL10
p1

#Agregar el porcentaje de poblacion femenina por empresa al dataset totales
mutate(totales,p1)

#Redondearlos a dos decimales
p1<-round(p1,4)
p1

ggplot(totales,aes(x=reorder(empresa,p1),y=p1))+
  geom_col(fill="lightblue3")+
  theme_minimal()+
  coord_flip()+
  geom_text(aes(label=p1*100))+
  labs(title="Poblacion Femenina por Empresa",subtitle = "Subtitulo",x="",y="",caption = "Por porcentajes para poder comparar?")


####Conclusion 1: Solo en dos empresas hay mujeres que hombres: Citigroup y Merck####

####Evaluar la representacion por etnicidades####






####NOTAS-------------------------------------####
#Ideas y otros:  encontrar los % de hombres y mujeres por "jerarquia" de puestos, por empresa para graficar
#Que estamos considerando como diversidad?
#Evaluar por etnicidades tambien
# (?) COMO GUARDAR EL ESTILO EN UN OBJETO? - NO ME SALE :( 
  
#Prueba fallida:
ggplot(totales) +
  geom_histogram(aes(x=p1)) +
  geom_hline(yintercept = 0.5, col = "red") +
  facet_wrap(~empresa) +
  labs(title = "Vista de todas las empresas a la vez",
       subtitle = "Subtitulo",
       x = "Porcentaje de poblacion",
       y = "Cantidad")
