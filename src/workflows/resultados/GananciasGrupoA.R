# limpio entorno
rm(list = ls())

# Determinar el directorio del script actual
# y cambiar el working directory al directorio del script actual
library(rstudioapi)
script_full_path <- rstudioapi::getSourceEditorContext()$path
script_path <- file.path(dirname(script_full_path), "")
setwd(script_path)

# Cargar archivos en el vector files en un data frame
# diferente cada uno con el mismo nombre de archivo
files <- c('a00-b3f2b43-expw_KA-0030_tb_ganancias.txt','a01-utg54-expw_KA-0003_tb_ganancias.txt','a02-b3f2b43-expw_KA-0033_tb_ganancias.txt','a03-b3f2b43-expw_KA-0032_tb_ganancias.txt','a04-b3f2b43-expw_KA-0031_tb_ganancias.txt','a05-b3f2b43-expw_KA-0035_tb_ganancias.txt','a06-utg54-expw_KA-0004_tb_ganancias.txt','a07-utg54-expw_KA-0002_tb_ganancias.txt','a08-b3f2b43-expw_KA-0034_tb_ganancias.txt','a09-utg54-expw_KA-0005_tb_ganancias.txt','a10-utg54-expw_KA-0006_tb_ganancias.txt','a11-utg54-expw_KA-0007_tb_ganancias.txt')

# Crear un data frame por cada archivo
# cargar los datos en el data frame

for (i in 1:length(files)) {
  # Leer el archivo
  data <- read.table(files[i], header = TRUE, sep = "\t", dec = ".", fill = TRUE)
  # Crear un data frame con el nombre del archivo
  assign(files[i], data)
}

envios <- c(9000,9500,10000,10500,11000,11500,12000,12500,13000)

# para cada data frame, sólo manter las filas
# con valor envios en el verctor envios
for (i in 1:length(files)) {
  # Filtrar el data frame
  data <- get(files[i])
  data <- data[data$envios %in% envios, ]
  # Guardar el data frame filtrado
  assign(files[i], data)
}

# Renombrar los data frames con el numero de experimento
for (i in 1:length(files)) {
  # Renombrar el data frame
  new_name <- substr(files[i], 1, 3)
  assign(new_name, get(files[i]))
  rm(list = files[i])
}

files <- c('a01','a02','a03','a04','a05','a06','a07','a08','a09','a10','a11','a00')

# guardar cada data frame en un archivo .csv separado
for (i in 1:length(files)) {
  # Guardar el data frame en un archivo .csv
  write.csv(get(files[i]), paste0(files[i], ".csv"), row.names = FALSE)
}
