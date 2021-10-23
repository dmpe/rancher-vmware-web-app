#!/bin/bash


helm uninstall ${1} 
helm upgrade --install ${1} ./lib/helm/${1}
minikube service --url ${1}