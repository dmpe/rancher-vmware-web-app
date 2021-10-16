# PoC with Go, FSharp, MariaDB, OpenAPI and Keycloak

## Objective

This is a simple attempt at creting CRUD Web api for storing data related to Rancher and VMware. 

There has been some evolution, therefore this repository also holds some past attempts, with PostGress, etc. documented below.

Without associated `rancher.sql` is project is of no use to anybody. Rancher SQL file is not commited here.

### Status of FSharp

- only `FreeHosts/` Get endpoint is working.

### Status of Go

- new, some tests, but due to lacking OpenAPI3+ Swagger support in the ecosystem (only Swagger2), no further investigations

### Status of Flask

- picked and sticked with it

```
curl -v -H 'Authorization: Basic <admin:admin> in base64' http://xxxx:30836/
```

## TODO:

- have to fix rancher.sql File which needs to be testable!


## Tech Stack/Apps:

- Minikube
- MariaDB
- PHPMyAdmin
- FSharp (for `F#`)
  - `MySqlConnector`
- Flask (for `Python`)
  - `mariadb` from Pypi
  - `gunicorn`
## Recommended Bootstraping on K8s cluster -> Minikube

Drastically simplied with a bunch of scripts:

```
./minikube.sh -> setups the cluster with DB and PHPMyAdmin
./build.sh -> builds docker image
./deploy.sh -> deploys helm chart with FSharp application
```


## Keycloak:


```
helm upgrade --install keycloak ./keycloak-15.0.2/keycloak
minikube service --url keycloak-http
```

## MariaDB & PHPMyAdmin:


```
helm upgrade --install mariadb ./mariadb-9.4.2/mariadb
helm upgrade --install mariadb ./phpmyadmin-8.2.11/phpmyadmin

minikube service --url myadmin-phpmyadmin
```

## FSharp

```
helm upgrade --install fsharp ./lib/helm/fsharp
```


## Other approaches at bootstraping: MicroK8s, K3s


### MicroK8S Dashboard


```
token=$(sudo microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
sudo microk8s kubectl -n kube-system describe secret $token
sudo microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
```

```
export CHANGE_MINIKUBE_NONE_USER=true
sudo sysctl fs.protected_regular=0
```

### K3S

<https://rancher.com/docs/k3s/latest/en/installation/kube-dashboard/>

```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
sudo k3s kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml
kubectl apply -f dash.yaml
sudo k3s kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token'
```

## Past attempts


For the setup I have used these:

### Postgress:

```
sudo microk8s enable helm3
sudo microk8s helm3 install mydb ./postgresql-10.9.2/postgresql/
helm upgrade --install mydb ./postgresql-10.9.2/postgresql/ 

```

### PostgREST:

```
sudo microk8s helm3 upgrade --install rest ./postgrest
sudo microk8s kubectl port-forward deployment/rest-postgrest 3000

```


## PGAdmin 4:

<https://github.com/rowanruseler/helm-charts/tree/master/charts/pgadmin4>

```
sudo microk8s helm3 upgrade --install pgadmin4 ./pgadmin4-1.7.2/pgadmin4
sudo microk8s kubectl port-forward deployment/pgadmin4 5050
helm upgrade --install pgadmin4 ./pgadmin4-1.7.2/pgadmin4

```

```
sudo microk8s kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(sudo microk8s kubectl version | base64 | tr -d '\n')"
sudo microk8s kubectl port-forward -n weave "$(sudo microk8s kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040
```

http://localhost:4040/



