# Greetings
> La aplicación a desplegar debe consistir de un endpoint simple que, al ser accedido en su ruta raíz
(/), ofrezca un saludo como respuesta en json

Para cumplir con este requerimiento, decidí hacer una mini aplicación web usando el framework Flask de Python. 

Elegí usar Flask porque es minimalista y sencillo. Cuando se ejecuta [greetings.py](/greetings.py), se inicia una aplicación web accesible desde cualquier dirección IP, que muestra en la ruta raiz el mensaje "Hi Cencommerce!" en formato json.

La aplicación está contenerizada, para que pueda correr sobre el cluster de Kubernetes.


Definí un [Dockerfile](/Dockerfile) que utiliza la imagen docker python:3.9-slim, instala las dependencias definidas en requirements.txt usando pip, y luego especifica que la aplicación debe escuchar en el puerto 5000 para que el contenedor Docker luego exponga ese puerto. Finalmente, ejecuta el script greetings.py para iniciar la aplicación web.

Por otro lado, el job *push-image-to-docker-hub* en el [workflow build-and-push.yaml](.github/workflow/build-and-push.yaml) se encarga de que, cada vez que haya un cambio en la aplicación, se genere una nueva imagen y se suba a Docker Hub. La tag con la que se sube la imagen es el SHA del commit en el que se detectó una modificación. Luego el job *update-deployment* actualiza el manifiesto del deployment de la app en kubernetes con el nuevo tag de la imagen, para que ArgoCD actualice la aplicación.