#!/bin/sh
az acr login --name dnsTraining 
docker tag bind dnstraining.azurecr.io/bind:9.9.4
docker push dnstraining.azurecr.io/bind:9.9.4
