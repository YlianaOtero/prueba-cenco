# Terraform
Use terraform como herramienta de infraesructura como código para generar la infraestructura cloud de AWS que necesité para completar el proyecto.

## Recursos definidos
### Budget
Más allá de estar utilizando el free tier de Amazon, me pareció importante crear un budget para asegurarme de limitar posibles gastos extras al hacer pruebas, e intentar evitar costos grandes inesperados si trabajo con algun recurso que esté fuera del free tier.

Si se pronostica que en el mes voy a gastar un monto mayor o igual a 20 USD, se envía una notificación a mi correo electrónico para que pueda tomar acción antes de exceder mi presupuesto.

### SSH Key pair
Definí un par de claves SSH para utilizar para conectarme de forma segura a las instancias de EC2 que cree, sin necesitar establecer una password. El script de terraform keys.tf genera el par de claves y descarga localmente el archivo de la clave privada.

### Grupos de seguridad
En security-groups.tf definí el grupo de seguridad a usar en las instancias de EC2 del cluster, junto con sus reglas de ingreso y egreso correspondientes. Las reglas fueron definidas en base a las necesidades de un clúster de Kubernetes. 


### Instancias de EC2
Usé instancias de EC2 para los nodos del cluster de Kubernetes. Estas instancias se dividen en dos grupos: k3s_server (con 2 nodos) y k3s_worker (con 3 nodos). Una vez creadas las instancias, las máquinas k3s_server se configuran para correr los componentes del control plane de Kubernetes, mientras que las máquinas k3s_worker corren los worker nodes.

El free tier de AWS me limita a la hora de elegir la imagen y el tipo de máquina a usar para las instancias. El tipo de instancia es t2.micro, y elegí una imagen con Ubuntu Server 22.04 LTS.

