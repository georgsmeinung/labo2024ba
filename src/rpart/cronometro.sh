#!/bin/bash

# Verificar si se proporcionó un comando
if [ -z "$1" ]; then
    echo "Uso: $0 <comando>"
    exit 1
fi

# Registrar tiempo de inicio
start_time=$(date +%s)
echo "Inicio: $(date)"

# Ejecutar el comando pasado como argumento
"$@"

# Registrar tiempo de finalización
end_time=$(date +%s)
echo "Final: $(date)"

# Calcular la duración total
duration=$((end_time - start_time))
echo "Duración total: $duration segundos"
