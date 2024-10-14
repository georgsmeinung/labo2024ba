# limpio entorno
rm(list = ls())

# Determinar el directorio del script actual
# y cambiar el working directory al directorio del script actual
library(rstudioapi)
script_full_path <- rstudioapi::getSourceEditorContext()$path
script_path <- file.path(dirname(script_full_path), "")
setwd(script_path)

# Cargar archivos en los vectores files en un data frame
# diferente cada uno con el mismo nombre de archivo
filesa <- c('a01','a02','a03','a04','a05','a06','a07','a08','a09','a10','a11','a00')
filesb <- c('b01','b02','b03','b04','b05','b06','b07','b08','b09','b10','b11','b00')

# Crear un data frame por cada archivo
# cargar los datos en el data frame

for (i in 1:length(filesa)) {
  # Leer el archivo
  data <- read.csv(paste0(filesa[i], ".csv"), header = TRUE, sep = ",", dec = ".", fill = TRUE)
  # elimino las columnas 2 y 3 del data frame
  data <- data[, -c(2:3)]
  # Crear un data frame con el nombre del archivo
  assign(filesa[i], data)
}

for (i in 1:length(filesb)) {
  # Leer el archivo
  data <- read.csv(paste0(filesb[i], ".csv"), header = TRUE, sep = ",", dec = ".", fill = TRUE)
  # elimino la segunda columna del data frame
  data <- data[, -2]
  # elimito la ultima columna del data frame
  data <- data[, -ncol(data)]
  # divido todos los valores por 1000000, excepto la primera columna
  data[, -1] <- data[, -1] / 1000000
  # Crear un data frame con el nombre del archivo
  assign(filesb[i], data)
}

# Funcion para calcular el test de Wilcoxon pasados dos renglones de un data frame
wilcoxon_test <- function(data1, data2) {
  #eliminar la primera columna de los data frames recibidos
  data1 <- data1[, -1]
  data2 <- data2[, -1]
  #convierto los data frames en vectores numericos
  data1 <- as.numeric(unlist(data1))
  data2 <- as.numeric(unlist(data2))
  # print(data1)
  # print(data2)
  wilcox.test(data1, data2, paired = TRUE)
}

# Evaluar el test de Wilcoxon para cada fila de los data 
# frames con cada uno de los otros data frames

# Crear un data frame con los resultados
resultados <- data.frame()

for (i in 1:length(filesa)) {
  for (j in 1:length(filesb)) {
    # Evaluar el test de Wilcoxon para todas las filas
      for (k in 1:length(get(filesa[i]))) {
          for (l in 1:length(get(filesb[j]))) {
              # Verifico que las filas no contengan NA
              if (any(is.na(get(filesa[i])[k,])) || any(is.na(get(filesb[j])[l,]))) {
                  next
              }
              result <- wilcoxon_test(get(filesa[i])[k,], get(filesb[j])[l,])
              # Calculo el valor promedio de los envios para cada experimento
              # con todos los valores de la fila excepto la columna de envios
              promedio1 <- mean(as.numeric(unlist(get(filesa[i])[k, -1])))
              promedio2 <- mean(as.numeric(unlist(get(filesb[j])[l, -1])))
              # Guardar el resultado en el data frame
              resultados <- rbind(resultados, data.frame(exp1 = paste0(filesa[i],"-",get(filesa[i])[k,]$envios), exp2 = paste0(filesb[j],"-",get(filesb[j])[l,]$envios), p.value = result$p.value, promedio1 = promedio1, promedio2 = promedio2))
          }
  }
}
}

# Agrego una columna que indique si el resultado es significativo
resultados$significativo <- resultados$p.value < 0.05
# Agrergo una columna que indique el resultado es significativo
# que indice cual es el experimento con el mayor promedio
resultados$mayor_promedio <- ifelse(resultados$promedio1 > resultados$promedio2,resultados$exp1, resultados$exp2)

# genero vector con los valores únicos de exp1 y exp2
exp1 <- unique(resultados$exp1)
exp2 <- unique(resultados$exp2)

#genero un dataframe con tantas filas y columnas como experimentos 
#en el data frame resultados

resultados2 <- data.frame(matrix(NA, nrow = length(exp1), ncol = length(exp2)))
rownames(resultados2) <- exp1
colnames(resultados2) <- exp2

#lleno el data frame resultados2 con los valores de p.value
for (i in 1:nrow(resultados)) {
  resultados2[resultados$exp1[i], resultados$exp2[i]] <- resultados$p.value[i]
}

#genero un dataframe con tantas filas y columnas como experimentos 
#en el data frame resultados

resultados3 <- data.frame(matrix(NA, nrow = length(exp1), ncol = length(exp2)))
rownames(resultados3) <- exp1
colnames(resultados3) <- exp2

#lleno el data frame resultados3 con los valores del experimento con mayor promedio si es que el resultado es significativo sino con NA
for (i in 1:nrow(resultados)) {
  if (resultados$significativo[i]) {
    resultados3[resultados$exp1[i], resultados$exp2[i]] <- resultados$mayor_promedio[i]
  } else {
    resultados3[resultados$exp1[i], resultados$exp2[i]] <- NA
  }
}

# guardo resultados 2 en un archivo csv experimentos-pvalue.csv
write.csv(resultados2, "experimentos-pvalue.csv", row.names = TRUE)

# guardo resultados 3 en un archivo csv experimentos-mayor-promedio.csv
write.csv(resultados3, "experimentos-mayor-promedio.csv", row.names = TRUE)

# genero un vector con  los valores únicos no NA en resultados3
valores <- unique(unlist(resultados3))
valores <- valores[!is.na(valores)]

# genero un data frame contando cuantas veces aparacen los valores único en resultados3
resultados4 <- data.frame()
for (i in 1:length(valores)) {
  resultados4 <- rbind(resultados4, data.frame(valor = valores[i], cantidad = sum(unlist(resultados3) == valores[i], na.rm = TRUE)))
}

# guardo resultados 4 en un archivo csv experimentos-cantidad.csv
write.csv(resultados4, "experimentos-cantidad.csv", row.names = TRUE)

# muestro el experimento con mayor cantidad de veces que aparece en resultados4
resultados4[resultados4$cantidad == max(resultados4$cantidad),]



