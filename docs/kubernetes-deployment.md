# Manifiestos de la app en Kubernetes
En el directorio [kubernetes](/kubernetes/) se encuentran los manifiestos yaml para crear los recursos de la aplicación en Kubernetes. Este es el directorio que sincroniza ArgoCD para implementar la app en el cluster: si hay un cambio en alguno de los archivos de este directorio, se actualiza la app en ArgoCD de manera automática.

## Recursos
### Namespace
En [namespace.yaml](/kubernetes/namespace.yaml) se define el namespace *greetings*, donde pondremos todos los demás recursos de la aplicación: ingress, deployment, servicios, pods, etc.

## Deployment
En [deployment.yaml](/kubernetes/deployment.yaml) se define el deployment de la aplicación. Aquí indico que quiero que mi aplicación se implemente en un único pod, con un contenedor que corre la imagen definida, en el puerto 5000 del contenedor. El campo imagen se completa automáticamente por el job *update-deployment* definido en [build-and-push.yaml](/.github/workflows/build-and-push.yaml), segun la imagen docker generada y subida a Docker hub en el job *push-image-to-docker-hub* definido en el mismo workflow.

Si, por ejemplo, se modifica el código de la aplicación en [greetings.py](/greetings.py), se dispara el workflow, entonces se hace el build de la nueva imagen, se sube a Docker hub y se actualiza [deployment.yaml](/kubernetes/deployment.yaml) con la nueva imagen. ArgoCD detecta que hubo un cambio en el deployment, e implementa la nueva versión de la aplicación en el cluster de Kuberentes.

