# Greetings
> La aplicación a desplegar debe consistir de un endpoint simple que, al ser accedido en su ruta raíz
(/), ofrezca un saludo como respuesta en json

Para cumplir con este requerimiento, decidí hacer una mini aplicación web usando el framework Flask de Python. 

Elegí usar Flask porque es minimalista y sencillo. Cuando se ejecuta greetings.py, se inicia una aplicación web accesible desde cualquier dirección IP, que muestra en la ruta raiz el mensaje "Hello Cencommerce!" en formato json.

La aplicación está contenerizada, para que pueda correr sobre el cluster de Kubernetes.


Definí un Dockerfile que utiliza la imagen docker python:3.9-slim, instala las dependencias definidas en requirements.txt usando pip, y luego especifica que la aplicación debe escuchar en el puerto 5000 para que el contenedor Docker luego exponga ese puerto. Finalmente, ejecuta el script greetings.py para iniciar la aplicación web.