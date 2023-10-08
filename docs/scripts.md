# Scripts
## Base de datos
### PostgreSQL
El script [create-database.sh](/scripts/database-setup/create-database.sh) instala el cliente de PostgreSQL, crea la base de datos k3s y un usuario para utilizar la base, y permite las conexiones a la base k3s desde cualquier dirección IP, con el usuario creado.

### Referencias:
- [Install and configure PostgreSQL - Ubuntu docs](https://ubuntu.com/server/docs/databases-postgresql)

## Nodos de K3S
### Instalar k3sup
El script [install-k3sup.sh](/scripts/nodes-setup/install-k3sup.sh) simplemente instala la herramienta [k3sup](https://github.com/alexellis/k3sup), una utility para configurar los nodos K3S. Este script debe correrse en todos los nodos del cluster.

### Agregar primer nodo del control plane
El script [add-first-master.sh](/scripts/nodes-setup/add-first-master.sh) instala y configura el primer nodo master del cluster de K3s, utilizando la base de datos de PostgreSQL. La instalación de K3s se hace mediante k3sup.

### Agregar n-ésimo nodo del control plane
El script [add-new-master.sh](/scripts/nodes-setup/add-new-master.sh) instala y configura un nuevo nodo master del cluster de K3s. La instalación de K3s se hace mediante k3sup, haciendo un join al cluster ya existente.

### Agregar nodo worker
El script [add-agent.sh](/scripts/nodes-setup/add-agent.sh) instala y configura un nuevo nodo worker del cluster de K3s. La instalación de K3s se hace mediante k3sup, haciendo un join al cluster ya existente, pero como agente en lugar de server.

### Referencias
- [Quick-Start Guide - K3s docs](https://github.com/alexellis/k3sup)
- [k3sup Github repo](https://github.com/alexellis/k3sup)

## Cilium
### Instalar Cilium
El script [install-cilium.sh](/scripts/cilium/install-cilium.sh) simplemente instala la herramienta Cilium en el cluster.

### Referencias:
- [Installation Using K3s - Cilium docs](https://docs.cilium.io/en/v1.13/installation/k3s/)

## Kong
### Instalar Kong
El script [install-kong.sh](/scripts/kong/install-kong.sh) instala y despliega Kong Gateway sobre el cluster, usando la helm chart de Kong. Tengo el archivo de valores locales kong-values.yaml, en el cual defino que el servicio de proxy se cree como un servicio de tipo NodePort en lugar de un LoadBalancer. Me basé en el archivo de valores locales del repo donde está la chart, y simplemente modifiqué el campo *type* del recurso *proxy*.
Uso NodePort porque mi cluster no tiene una IP externa para asociar a los servicios de LoadBalancer. Al definir los servicios como NodePort, puedo acceder con las IPs de las máquinas virtuales de los nodos, en el puerto que se especifique en la definición del servicio.

### Referencias:
- [Install with Kong Gateway using Helm - Kong docs](https://docs.konghq.com/gateway/3.4.x/install/kubernetes/helm-quickstart/)
- [Kong Helm Charts repo](https://github.com/Kong/charts/tree/kong-2.1.0)

## ArgoCD
### Instalar ArgoCD
El script [install-argocd.sh](/scripts/argocd/install-argocd.sh) instala y despliega ArgoCD sobre el cluster. Además, hace un patch al servicio argocd-server para que sea de tipo NodePort en lugar de LoadBalancer, por el mismo motivo por el cual instalé kong proxy como NodePort. Puedo acceder a la interfaz gráfica de ArgoCD mediante la IP de uno de los nodos, y el puerto de ArgoCD.

### Referencias:
- [Getting Started - ArgoCD docs](https://argo-cd.readthedocs.io/en/stable/getting_started/)