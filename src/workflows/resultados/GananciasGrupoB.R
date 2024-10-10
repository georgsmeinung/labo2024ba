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
files <- c('b01-expw_EV-0011_ganancias_01_056.txt','b02-expw_EV-0012_ganancias_01_035.txt','b03-expw_EV-0013_ganancias_01_055.txt','b04-expw_EV-0014_ganancias_01_074.txt','b05-expw_EV-0016_ganancias_01_024.txt','b06-expw_EV-0015_ganancias_01_040.txt','b07-expw_EV-0018_ganancias_01_048.txt','b08-expw_EV-0017_ganancias_01_052.txt','b09-expw_EV-0020_ganancias_01_052.txt','b10-expw_EV-0019_ganancias_01_045.txt','b11-expw_EV-0021_ganancias_01_073.txt','b00-expw_EV-0010_ganancias_01_061.txt')

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

files <- c('b01','b02','b03','b04','b05','b06','b07','b08','b09','b10','b11','b00')

# guardar cada data frame en un archivo .csv separado
for (i in 1:length(files)) {
  # Guardar el data frame en un archivo .csv
  write.csv(get(files[i]), paste0(files[i], ".csv"), row.names = FALSE)
}
