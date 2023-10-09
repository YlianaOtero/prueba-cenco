# Prueba técnica
Aquí podrán econtrar un mayor detalle de lo que hice para la prueba técnica. En [app.MD](/docs/app.MD) hay más información sobre la aplicación que implementé.

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
Creamos la infraestructura con terraform:
![Output de terraform apply](/docs/img/tf-apply-aws.png)

Podemos verla en AWS:

**Máquinas virtuales para el cluster de Kubernetes:**
![Instancias de EC2 para nodos del cluster de Kubernetes](/docs/img/aws-ec2-nodes.png)

**Máquina virtual para el servidor de base de datos:**
![Instancia de EC2 para base de datos PostgreSQL](/docs/img/aws-ec2-db-server.png)

**Grupos de seguridad:**
![Grupos de seguridad creados](/docs/img/aws-sg.png)

**Budget:**
![Budget creado](/docs/img/aws-budget.png)


## Creación y configuración de base de datos
Nos conectamos al servidor de base de datos y corremos el script [create-database.sh](/scripts/database-setup/create-database.sh). También podemos simplemente ir corriendo los comandos.

El script create-database.sh instala el cliente de PostgreSQL, crea la base de datos k3s y un usuario para utilizar la base, y permite las conexiones a la base k3s desde cualquier dirección IP, con el usuario creado.

Nos conectamos a la base creada (k3s) con el usuario creado (ubuntu) y vemos que no hay relaciones:

![Empty list of relations](/docs/img/k3s-initial-relations.png)

Una vez que el cluster está creado y configurado para utilizar la base de datos que creamos, sec creará la tabla kine:

![List of relations](/docs/img/k3s-kine-table.png)

**Referencias:**
- [Install and configure PostgreSQL - Ubuntu docs](https://ubuntu.com/server/docs/databases-postgresql)


## Creación y configuración de cluster de K3S
En cada uno de los nodos es necesario correr los siguientes comandos para instalar la utility de k3sup.
```
curl -sLS https://get.k3sup.dev | INSTALL_K3S_EXEC='--flannel-backend=none --disable-network-policy' sh

sudo cp k3sup /usr/local/bin/k3sup
sudo install k3sup /usr/local/bin/k3sup
```

### Crear el cluster

Creamos el cluster de K3s al configurar el primer nodo. 

#### Definir variables
Correr los siguientes comandos, modificando [DB USER] por el nombre de un usuario con acceso sobre la base de datos creada, [DB PASSWORD] por su contraseña, y [DB SERVER IP] por la IP del servidor de base de datos. Sustituir también [MASTER SERVER IP] por la IP del primer nodo master.

```
export DB_USER=[DB USER]
export DB_PASSWORD=[DB PASSWORD]
export DB_SERVER_IP=[DB SERVER IP]

export DATASTORE_ENDPOINT="postgres://$DB_USER:$DB_PASSWORD@$DB_SERVER_IP:5432/k3s"

export K3S_TOKEN=$(head -c 16 /dev/urandom | shasum | cut -d" " -f1)

export MASTER_SERVER_IP=[MASTER SERVER IP]
```


#### Configuración relacionada al endpoint de la base de datos

```
sudo apt-get update
sudo apt install -y postgresql-client
```

#### Instalar k3s

```
k3sup install --ip $MASTER_SERVER_IP --user $USER --token $K3S_TOKEN --datastore $DATASTORE_ENDPOINT --cluster

export KUBECONFIG=/home/$USER/kubeconfig

kubectl config use-context default
```


### Agregar los otros dos nodos del control plane
El siguiente procedimiento lo hacemos en los otros dos nodos.


#### Definir variables
Definimos las siguientes variables de entorno, modificando [FIRST MASTER SERVER IP] por la IP del nodo master definido en el paso anterior, y [NEW MASTER SERVER IP] por la IP de este nodo.


```
export FIRST_MASTER_SERVER_IP=[FIRST MASTER SERVER IP]
export NEW_MASTER_SERVER_IP=[NEW MASTER SERVER IP]
```


#### Unir el nuevo server al cluster
```
k3sup join --ip $NEW_MASTER_SERVER_IP --user $USER --server-user $USER --server-ip $FIRST_MASTER_SERVER_IP --server
```

### Agregar los worker nodes
El siguiente procedimiento lo hacemos en los nodos worker.


#### Definir variables
Definimos las siguientes variables de entorno, modificando [FIRST MASTER SERVER IP] por la IP del nodo master definido en el paso anterior, y [NEW AGENT SERVER IP] por la IP de este nodo.

```
export FIRST_MASTER_SERVER_IP=[FIRST MASTER SERVER IP]
export NEW_AGENT_SERVER_IP=[NEW AGENT SERVER IP]
```


#### Unir el nuevo agente al cluster
```
k3sup join --ip $NEW_AGENT_SERVER_IP --server-ip $FIRST_MASTER_SERVER_IP --user $USER
```

**Referencias:**
- [Quick-Start Guide - K3s docs](https://github.com/alexellis/k3sup)
- [k3sup Github repo](https://github.com/alexellis/k3sup)


## Importante

Pude crear el cluster y la base de datos en AWS, pero a la hora de intentar instalar los componentes sobre el cluster me tranqué porque los comandos demoraban un tiempo excesivo y llegaba a hacer timeout. También se me acabó enseguida el free tier de data transfer, por lo que seguir intentando instalar las cosas me estaba empezando a consumir cargos.

Para no dejarlo sin hacer, y ver si podía ser un problema relacionado a que las máquinas del free tier son muy pequeñas, cree en GCP la infraestructura de la forma más parecida posible, pero utilizando máquinas un poco más grandes. Esto también lo hice usando terraform, y los scripts se pueden encontrar [acá](/terraform/gcp/).


## Instalación de herramientas sobre el cluster
### Instalar Cilium

```
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable-v0.14.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi

curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

cilium install

cilium status --wait
```

![Cilium status](/docs/img/cilium.png)


**Referencias:**
- [Installation Using K3s - Cilium docs](https://docs.cilium.io/en/v1.13/installation/k3s/)


### Instalar Kong
Con los siguientes comandos se instala y despliega Kong Gateway sobre el cluster, usando la helm chart de Kong. Tengo el archivo de valores locales [kong-values.yaml](/kong/kong-values.yaml), en el cual defino que el servicio de proxy se cree como un servicio de tipo NodePort en lugar de un LoadBalancer. Me basé en el archivo de valores locales del repo donde está la chart, y simplemente modifiqué el campo *type* del recurso *proxy*.

Uso NodePort porque mi cluster no tiene una IP externa para asociar a los servicios de LoadBalancer. Al definir los servicios como NodePort, puedo acceder con las IPs de las máquinas virtuales de los nodos, en el puerto que se especifique en la definición del servicio.

También utilizo el archivo [kong-certificates.yaml](/kong/kong-certificates.yaml) para crear los certificados.

```
kubectl create namespace kong

kubectl create secret generic kong-config-secret -n kong \
  --from-literal=portal_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"portal_session","cookie_same_site":"Lax","cookie_secure":false}' \
  --from-literal=admin_gui_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"admin_session","cookie_same_site":"Lax","cookie_secure":false}' \
  --from-literal=pg_host="enterprise-postgresql.kong.svc.cluster.local" \
  --from-literal=kong_admin_password=kong \
  --from-literal=password=kong

kubectl create secret generic kong-enterprise-license --from-literal=license="'{}'" -n kong --dry-run=client -o yaml | kubectl apply -f -

helm repo add jetstack https://charts.jetstack.io ; helm repo update

helm upgrade --install cert-manager jetstack/cert-manager --set installCRDs=true --namespace cert-manager --create-namespace

kubectl apply -f kong-certificates.yaml -n kong

helm repo add kong https://charts.konghq.com ; helm repo update

helm install quickstart kong/kong --namespace kong --values kong-values.yaml
```


![Recursos en namespace kong](/docs/img/kong-resources.png)

### Instalar ArgoCD
Con los siguientes comandos se instala y despliega ArgoCD sobre el cluster. Además, hace un patch al servicio argocd-server para que sea de tipo NodePort en lugar de LoadBalancer, por el mismo motivo por el cual instalé kong proxy como NodePort. Puedo acceder a la interfaz gráfica de ArgoCD mediante la IP de uno de los nodos, y el puerto de ArgoCD.

```
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort", "ports": [{"name": "http", "nodePort": 30080, "port": 80, "protocol": "TCP", "targetPort": 8080}, {"name": "https", "nodePort": 30443, "port": 443, "protocol": "TCP", "targetPort": 8080}]}}'
```

![Recursos en namespace argocd](/docs/img/argocd-resources.png)


**Referencias:**
- [Getting Started - ArgoCD docs](https://argo-cd.readthedocs.io/en/stable/getting_started/)



## Configuración de app en ArgoCD
El primer paso es iniciar sesión en ArgoCD. Yo usé la interfaz gráfica, pero también se puede utilizar la herramienta de línea de comando.

Como expuse argocd-server como un servicio de NodePort con la IP externa de uno de los nodos de mi cluster (34.172.83.64), y el puerto de argocd-server (30080).

![ArgoCD login](/docs/img/argocd-login.png)

Para ver la contraseña inicial de argo:

```
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Iniciamos sesión con el usuario admin y la contraseña que devolvió el comando anterior. Una vez que iniciamos sesión por primera vez, podemos cambiar la contraseña en User Info.

Vamos a Settings -> Repositories -> Connect repo y agregamos las configuraciones para conectarse al repositorio de GitHub que tiene los manifiestos de la aplicación que vamos a subir. En mi caso, es este mismo repositorio, y quiero que ArgoCD se conecte mediante SSH.

![ArgoCD configure repo](/docs/img/argocd-configure-repo.png)
![ArgoCD repositories](/docs/img/argocd-connection.png)

En el archivo [argocd-app.yaml](/argocd/argocd-app.yaml) defino el recurso de tipo Application para ArgoCD. Aquí se declara que la aplicación greetings se implementará en el cluster, que los manifiestos que definen a esa aplicación están en el repositorio YlianaOtero/prueba-cenco en GitHub en el path [kubernetes](/kubernetes), y la conexión a ese repo debe ser mediante SSH.

Es necesario crear el recurso en el cluster de kubernetes:
```
kubectl apply -f argocd-app.yaml
```

Y ahí ArgoCD crea la aplicación, generando los recursos en el cluster
![Greetings resources](/docs/img/greetings-resources.png)

Observar que el servicio de NodePort de la app la expone en el puerto 30641. Si vamos a 34.172.83.64:30641:
![hi-cencommerce](/docs/img/hi-cencommerce.png)

Desde la IU de ArgoCD también podemos ver la aplicación:
![ArgoCD applications](/docs/img/argocd-apps.png)
![ArgoCD greetings](/docs/img/argocd-app-greetings.png)



Para ver la documentación de los manifiestos definidos en el directorio que sincroniza la app de ArgoCD, ver el archivo [kubernetes-deployment.md](/docs/kubernetes-deployment.md). Para ver la documentación sobre la aplicación, ver el archivo [app.MD](/docs/app.MD)