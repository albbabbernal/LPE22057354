# LOADING LIBS ------------------------------------------------------------
pacman::p_load(httr, tidyverse, leaflet, janitor, readr, sparklyr)
url_<-"https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/"
httr::GET(url_)
library(sparklyr)
library(httr)
library(tidyverse)
library(leaflet)
library(janitor)

df_source <- f_raw$ListaEESSPrecio %>% glimpse()
df2 <- df_source %>% janitor::clean_names() %>% type_convert(locale=locale(decimal_mark=','))

# CLASIFICAMOS GASOLINERAS ------------------------------------------------

df_low<-df2 %>% mutate(expensive=!rotulo %in%c('CEPSA', 'REPSOL', 'BP', 'SHELL'))
ds22057354<-df_source

# CALCULAR PRECIO MEDIO DE GASOLINA ---------------------------------------

df_low %>% select(precio_gasoleo_a, idccaa, rotulo, expensive) %>% drop_na() %>% group_by(idccaa, expensive) %>% summarise(mean(precio_gasoleo_a)) %>% view()
df_low %>% glimpse()

# CREAR NUEVA COLUMNA QUE IDENTIFIQUE EL ID -------------------------------

ccaa <- c("Andalucía", "Aragón", "Asturias, Principado", "de Baleares, Illes", "Canarias", "Cantabria", "Castilla y León", "Castilla - La Mancha", "Cataluña",
          "Comunitat Valenciana", "Extremadura", "Galicia", "Madrid", "Comunidad de Murcia", "Región de Navarra, Comunidad Floral de", "País Vasco", "Rioja, La", 
          "Ceuta", "Melilla")

id_ccaa<-c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19")

data_ccaa<-data.frame(ccaa,id_ccaa)


# CREAMOS DATASETS CON 33 Y 34 COLUMNAS -----------------------------------

ds22057354_33<-df_low
ds22057354_34<-df_low

ds22057354_34 <-merge(ds22057354_34, data_ccaa)
ds22057354_34 %>% view()

# EXTRAER DATASETS --------------------------------------------------------

write.csv(ds22057354_33,"C:\\Users\\albab\\LPE\\ds22057354_33.csv", row.names = FALSE)
write.csv(ds22057354_34,"C:\\Users\\albab\\LPE\\ds22057354_34.csv", row.names = FALSE)
