

#Desde aqui les voy diciendo sorry por los comentarios realmente tontos. Los he marcado con -T- al principio jajajja 

library(tidyverse)
library(ggplot2)
library(gargle)

#Cargando las variables desde la carpeta local - Google Sheets tardaba muchisimo

getwd()

diversidad_2017_orig<-read.csv("diversity_data_2017.csv", stringsAsFactors = FALSE)
glimpse(diversidad_2017)


# -T- Las subi como factor porque es un ranking
ranking_2017<-read.csv("best_places_diversity_2017.csv",stringsAsFactors = TRUE)
glimpse(ranking_2017)

#Ver y limpiar la base 
#-T- names y colnames hacen lo mismo? Parece que si
colnames(diversidad_2017)
names(diversidad_2017)

#Cambiar nombres a las columnas: name a empresa
prueba<-rename(diversidad_2017_orig, empresa = name)
names(prueba)

#Quedarse con los que tienen la data completa 
prueba<-filter(prueba,data.avail=="Y")
dim(prueba)

#Quitar columnas de urls
prueba<-select(prueba,-data.url,-diversity.pg.url)
dim(prueba)


#-T- Leer el diccionario de datos para entender las demas variables


# (?!!) Como convertir todos los numeros que estan como chr a int (?) - Me salio solo hacerlo uno por uno asi que solo hice los totales
str(prueba)

totales<-prueba%>%
  select(empresa,TOTAL10,FT10,MT10)

head(totales)
str(totales)

totales$TOTAL10<-as.numeric(as.character(totales$TOTAL10))
str(totales)

totales$FT10<-as.numeric(as.character(totales$FT10))
str(totales)

totales$MT10<-as.numeric(as.character(totales$MT10))
str(totales)

#Encontrar los porcentajes de poblacion femenina por empresa
p1<-totales$FT10/totales$TOTAL10
p1

#Agregar el porcentaje de poblacion femenina por empresa al dataset totales
mutate(totales,p1)


ggplot(totales,aes(x=reorder(empresa,p1),y=p1))+
  geom_col(fill="lightblue3")+
  theme_minimal()+
  coord_flip()+
  geom_text(aes(label=p1))+
  labs(title="Poblacion Femenina por Empresa",subtitle = "Subtitulo",x="",y="",caption = "Por porcentajes para poder comparar?")
#Los decimales se ven horrible

#Solo en dos empresas hay mas hombres que mujeres


# (?) COMO GUARDAR EL ESTILO EN UN OBJETO? - NO ME SALE :( 

#Ideas y otros: Usar summarise para encontrar los % de hombres y mujeres por "jerarquia" de puestos, por empresa para graficar
#Que estamos considerando como diversidad?
#Evaluar por etnicidades tambien

  


