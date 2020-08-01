

#Desde aqui les voy diciendo sorry por los comentarios realmente tontos

library(tidyverse)
library(ggplot2)
library(gargle)

#Cargando las variables desde la carpeta local - Google Sheets tardaba muchisimo

getwd()

#Agregando na.strings... para que no lea los datos como int en lugar de chr :) 

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

totales<-prueba%>%
  select(empresa,TOTAL10,FT10,MT10,HISPM10,HISPF10,WHM10,BLKM10,NHOPIM10,ASIANM10,AIANM10,TOMRM10,WHF10,BLKF10,NHOPIF10,ASIANF10,AIANF10,TOMRF10)
str(totales)

####Encontrar los porcentajes de poblacion femenina por empresa####
p_femenino<-totales$FT10/totales$TOTAL10
p_femenino

#Agregar el porcentaje de poblacion femenina por empresa al dataset totales
mutate(totales,p_femenino)

#Redondearlos a dos decimales
p_femenino<-round(p_femenino,4)
p_femenino

ggplot(totales,aes(x=reorder(empresa,p_femenino),y=p_femenino))+
  geom_col(fill="lightblue3")+
  theme_minimal()+
  coord_flip()+
  geom_text(aes(label=p_femenino*100))+
  labs(title="Poblacion Femenina por Empresa",subtitle = "Subtitulo",x="",y="",caption = "Por porcentajes para poder comparar?")


####Conclusion 1: Solo en dos empresas hay mujeres que hombres: Citigroup y Merck####

####Evaluar la representacion por etnicidades####


#### ----------------------------NUEVO NUEVITO NUEVOTE -------------------------------------------####

#Moviendo todas las variables de etnia/sexo a que sean valores de una variable nueva
diversidad_17_compacto <- totales %>%
  pivot_longer(cols = -empresa, 
               names_to = "Etnia_Sexo",
               values_to = "Cantidad")

diversidad_17_compacto

str(diversidad_17_compacto)

#convertir empresa y Etnia_Sexo a factor (lo tomo como chr antes) --- no se si se puede hacer mas limpio
#solo para saber los nombres de las variables - Despues se puede borrar
diversidad_17_compacto$Etnia_Sexo<-as.factor(diversidad_17_compacto$Etnia_Sexo)
diversidad_17_compacto$empresa<-as.factor(diversidad_17_compacto$empresa)
str(diversidad_17_compacto)

#ver los valores o "niveles" (levels) que puedes tomar las variables Etnia_Sexo y empresa
levels(diversidad_17_compacto$Etnia_Sexo)
levels(diversidad_17_compacto$empresa)

#----- Hasta aqui esta bien :) 
#De aqui para abajo, no se jajaja


#agrupando por etnias
#regresando los valores a character
diversidad_17_compacto$Etnia_Sexo<-as.character(diversidad_17_compacto$Etnia_Sexo)
diversidad_17_compacto$empresa<-as.character(diversidad_17_compacto$empresa)
str(diversidad_17_compacto)

head(diversidad_17_compacto)

#indian
indian<-filter(diversidad_17_compacto,Etnia_Sexo=="AIANF10"|Etnia_Sexo=="AIANM10")%>%
  group_by(empresa)%>%
  summarise(Indian=sum(Cantidad))#Le puse esto para que la nueva columna/variable se distinga entre etnicidades
#asian
asian<-filter(diversidad_17_compacto,Etnia_Sexo=="ASIANF10"|Etnia_Sexo=="ASIANM10")%>%
  group_by(empresa)%>%
  summarise(Asian=sum(Cantidad))

#black
black<-filter(diversidad_17_compacto,Etnia_Sexo=="BLKF10"|Etnia_Sexo=="BLKM10")%>%
  group_by(empresa)%>%
  summarise(Black=sum(Cantidad))

#hispanic
hispanic<-filter(diversidad_17_compacto,Etnia_Sexo=="HISPF10"|Etnia_Sexo=="HISPM10")%>%
  group_by(empresa)%>%
  summarise(Hispanic=sum(Cantidad))

#hawaiian
hawaiian<-filter(diversidad_17_compacto,Etnia_Sexo=="NHOPIF10"|Etnia_Sexo=="NHOPIM10")%>%
  group_by(empresa)%>%
  summarise(Hawaiian=sum(Cantidad))%>%
  replace(., is.na(.), 0)#Porque a la hora de hacer el grafico me salia que habia valores nulos

#two races
two_races<-filter(diversidad_17_compacto,Etnia_Sexo=="TOMRF10"|Etnia_Sexo=="TOMRM10")%>%
  group_by(empresa)%>%
  summarise(Two_races=sum(Cantidad))%>%
  replace(., is.na(.), 0)

#white
white<-filter(diversidad_17_compacto,Etnia_Sexo=="WHF10"|Etnia_Sexo=="WHM10")%>%
  group_by(empresa)%>%
  summarise(White=sum(Cantidad))


#convertir todos a df (se guardaron como tibble)
as.data.frame(indian)
as.data.frame(asian)
as.data.frame(black)
as.data.frame(hispanic)
as.data.frame(hawaiian)
as.data.frame(two_races)
as.data.frame(white)

#creando un objeto para agregar los totales por etnia por empresa
totales_etnias_2017<-select(totales,empresa,TOTAL10)
totales_etnias_2017
str(totales_etnias_2017)

totales_etnias_2017

#agregar los objetos -- Se puede agregar todos a la vez?
totales_etnias_2017<-left_join(indian,totales_etnias_2017)%>%
  as.data.frame(totales_etnias_2017)

totales_etnias_2017<-left_join(asian,totales_etnias_2017)%>%
  as.data.frame(totales_etnias_2017)

totales_etnias_2017<-left_join(black,totales_etnias_2017)%>%
  as.data.frame(totales_etnias_2017)

totales_etnias_2017<-left_join(hispanic,totales_etnias_2017)%>%
  as.data.frame(totales_etnias_2017)

totales_etnias_2017<-left_join(hawaiian,totales_etnias_2017)%>%
  as.data.frame(totales_etnias_2017)

totales_etnias_2017<-left_join(two_races,totales_etnias_2017)%>%
  as.data.frame(totales_etnias_2017)

totales_etnias_2017<-left_join(white,totales_etnias_2017)%>%
  as.data.frame(totales_etnias_2017)

head(totales_etnias_2017)


#Bailecito de celebracion por el nuevo dataframe :) 
#... En realidad falta limpiar los N/A que sean ceros

#Graficando para ver la diversidad (por etnia por empresa) 
#fill no servia, utilice colour??
#y alguna otra forma de colorearlo??

ggplot(totales_etnias_2017) +
  geom_point(colour="blue",aes(x=empresa,y=White/TOTAL10)) +
  geom_point(colour="red",aes(x=empresa,y=Two_races/TOTAL10)) +
  geom_point(colour="yellow",aes(x=empresa,y=Hawaiian/TOTAL10)) +
  geom_point(colour="orange",aes(x=empresa,y=Hispanic/TOTAL10)) +
  geom_point(colour="green",aes(x=empresa,y=Black/TOTAL10)) +
  geom_point(colour="purple",aes(x=empresa,y=Asian/TOTAL10)) +
  geom_point(aes(x=empresa,y=Indian/TOTAL10)) +
  geom_hline(yintercept = 0.5, col = "red") +
  coord_flip()+
  labs(title = "Vista de todas las empresas a la vez",
       subtitle = "Por etnia",
       x = "",
       y = "Porcentaje") #Como mostrarlo como porcentaje??



#En realidad creo que tendria mas sentido moverlo al reves? Osea poner las etnicidades en lugar de las empresas




####NOTAS-------------------------------------####
# (?) COMO GUARDAR EL ESTILO EN UN OBJETO? - NO ME SALE :( 