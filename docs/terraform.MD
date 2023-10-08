# Terraform
Usé terraform como herramienta de infraesructura como código para generar la infraestructura cloud que necesité para completar el proyecto.

## AWS
### Recursos definidos
#### Budget
Más allá de estar utilizando el free tier de Amazon, me pareció importante crear un budget para asegurarme de limitar posibles gastos extras al hacer pruebas, e intentar evitar costos grandes inesperados si trabajo con algun recurso que esté fuera del free tier. Esto es más que nada porque es la primera vez que trabajo con el free tier de AWS.

Si se pronostica que en el mes voy a gastar un monto mayor o igual a 20 USD, se envía una notificación a mi correo electrónico para que pueda tomar acción antes de exceder mi presupuesto.

#### SSH Key pair
Definí un par de claves SSH para utilizar para conectarme de forma segura a las instancias de EC2 que cree, sin necesitar establecer una password. El script de terraform [keys.tf](/terraform/aws/keys.tf) genera el par de claves y descarga localmente el archivo de la clave privada.

#### Grupos de seguridad
En [security-groups.tf](/terraform/aws/security-groups.tf) definí el grupo de seguridad a usar en las instancias de EC2 del cluster, junto con sus reglas de ingreso y egreso correspondientes. Las reglas fueron definidas en base a las [necesidades de un clúster de K3s](https://docs.k3s.io/installation/requirements#inbound-rules-for-k3s-server-nodes). 

Los grupos de seguridad utilizan la variable source_ip_range para definir el rango de direcciones IP del bloque CIDR. El valor por defecto es 0.0.0.0/0.

#### Instancias de EC2
Se definen tres tipos de instancias:
- Servidor de base de datos PostgreSQL
- Nodos master para cluster de Kubernetes (3)
- Nodos worker para cluster de Kuberntes (2)

El servidor de base de datos se define en [security-groups.tf](/terraform/aws/security-groups.tf), mientras que los nodos se definen en [nodes.tf](/terraform/aws/nodes.tf).

El free tier de AWS me limita a la hora de elegir la imagen y el tipo de máquina a usar para las instancias. El tipo de instancia es t2.micro, la cual cuenta con 1 vCPU y 1 GB de memoria. Para el sistema operativo, elegí una imagen con Ubuntu Server 22.04 LTS.

Las configuraciones de red se identifican mediante el security group asociado a cada instancia.

## GCP
### Recursos definidos
#### Firewall
El archivo [firewall.tf](/terraform/gcp/firewall.tf) cumple una función similar a [security-groups.tf](/terraform/aws/security-groups.tf), pero en GCP. Acá se definen las reglas de firewall a utilizar para las distintas máquinas virtuales.
El primer recurso se llama k3s_nodes_fw y permite el tráfico entrante en varios [puertos TCP y UDP que se necesitan para el cluster de Kubernetes](https://docs.k3s.io/installation/requirements#inbound-rules-for-k3s-server-nodes). El segundo recurso se llama postgres_fw y permite el tráfico entrante en el puerto TCP 5432, que se utiliza para conexión a la base de datos PostgreSQL. El tercer recurso se llama default_egress_fw y permite el tráfico saliente a cualquier destino en cualquier protocolo.

Los tres recursos tienen un atributo source_ranges que especifica los rangos de IP desde los cuales se permite el tráfico entrante, y un atributo network que refiere a la VPC. La VPC se define en la variable network_name, que tiene como valor por defecto "default". El rango de IP se define en una variable llamada source_ip_range, que tiene un valor predeterminado de 10.128.0.0/20 (el rango de IPs de la VPC default de GCP). Esto significa que solo se permite el tráfico entrante desde direcciones IP dentro del rango 10.128.0.0/20.

Los recursos k3s_nodes_fw y postgres_fw tienen un atributo target_tags que especifica las etiquetas de instancia de GCP a las que se aplican las reglas de firewall. El recurso k3s_nodes_fw se aplica a instancias con la etiqueta k3s-nodes, mientras que el recurso postgres_fw se aplica a instancias con la etiqueta postgres.

#### Instancias de Compute Engine
Se definen tres tipos de instancias:
- Servidor de base de datos PostgreSQL
- Nodos master para cluster de Kubernetes (3)
- Nodos worker para cluster de Kuberntes (2)

El servidor de base de datos se define en [postgres-server.tf](/terraform/gcp/postgres-server.tf), mientras que los nodos se definen en [nodes.tf](/terraform/gcp/nodes.tf). Todas las instancias son de tipo e2-medium, que cuentan con 2 vCPU y 4 GB de memoria.

La red se identifica con la variable network_name, y se utilizan network tags para aplicarles a los servidores las reglas de firewall correspondientes. El parámetro access_config se utiliza para especificar que la instancia debe tener una dirección IP externa.