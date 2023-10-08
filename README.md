## Creación de infraestructura
Para crear la infraestructura cloud necesaria, utilizo terraform.

Los archivos de definición de la infraestructura, tanto para AWS como para GCP, se encuentran en la carpeta [terraform](/terraform/), y su documentación está en [este archivo](/docs/terraform.MD).

Como pre-requisito, es necesario tener instalado Terraform, así como configurar la autenticación con la cuenta de AWS o GCP que se vaya a utilizar para conectarse al cloud provider en el proyecto que corresponda. Para AWS, se necesita configurar el profile. Para GCP, definir el proyecto "prueba-cenco" y almacenar la clave de la cuenta de servicio a utilizar en "service-account-key.json".

Una vez se tiene esto listo, para correr estos archivos basta con pararse en el directorio del cloud provider a usar, por ejemplo [AWS](/terraform/aws/), y correr los siguientes comandos:
```
terraform init
```
```
terraform validate
```
```
terraform apply
```

### Demo AWS

### Demo GCP

## Creación y configuración de base de datos

## Creación y configuración de cluster de K3S

## Instalación de herramientas sobre el cluster


## Configuración de app en ArgoCD

