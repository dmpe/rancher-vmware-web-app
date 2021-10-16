#!/bin/bash

set -e

export CHANGE_MINIKUBE_NONE_USER=true
sudo sysctl fs.protected_regular=0

sudo -E minikube start --driver=none

# helm upgrade --install keycloak ./lib/helm/keycloak-15.0.2/keycloak
helm upgrade --install mariadb ./lib/helm/mariadb-9.4.2/mariadb
helm upgrade --install myadmin ./lib/helm/phpmyadmin-8.2.11/phpmyadmin

minikube service --url myadmin-phpmyadmin
# minikube service --url keycloak-http
minikube dashboard
