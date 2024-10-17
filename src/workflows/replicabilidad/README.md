![Universidad Austral](https://www.austral.edu.ar/wp-content/uploads/2022/09/logo-md-austral-1.png)
## MCD - Laboratorio de Implementación 1 - Jorge Nicolau
### Instrucciones para la replicabilidad del experimento de Entrega Final
- **Configuración de ambiente**: el experimento se ejecutó usando la semilla primigenia `703733`. El resto de los parámetros de configuración se encuentran en el archivo `miAmbiente.yml`. Para poder reproducir el experimento es importante copiar este archivo a `~/buckets/b1/miAmbiente.yml` porque es la ubicación desde donde lo toman los scripts del framework workflow.
- **Acceso a Kaggle**: es necesario para calcular las ganacias de Kaggle que esté configurado el acceso al mismo con el correspondiente archivo `~/buckets/b1/kaggle.json` con al cuenta que va a hacer el submit. Por supuesto, es necesario que la cuenta que se use esté inscripta en la competencia **labo-i-vivencial-2024-ba**.
- **Script de Inicio**: el script para reproducir el experimento debe iniciarse con el archivo `902archivo.r`. 
- **Script que implementa el workflow**: el script que utiliza el script de inicio es el `929archio.r`, por cual es importante que este archivo esté correctame referenciado en la línea 4 del archivo `902archivo.r` debe estar correctamente referenciado (de acuedo a donde se descarguen los scripts) en el comando `PARAM <- "929archivo.r"`.
- **Inicio del script**: Se recomienda ejecutar el archivo en forma desatendida desde la terminal del sistema Ubuntu con el comando `nohup Rscript archivo.r &`.
- **Seguimiento del script:** puede seguirse la ejecución del script en cualquier momento entrando al directorio donde se inicio el script y utilizando el comando `tail -f nohup.out`
