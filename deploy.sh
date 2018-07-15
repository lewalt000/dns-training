#!/bin/sh
if [ "$#" -ne 1 ]; then
	echo "Usage ./deploy.sh <version> Example ./deploy.sh 003"
else
  # push new docker container to Azure container registry
	az acr login --name dnsTraining
	docker tag bind dnstraining.azurecr.io/bind:$1
	docker push dnstraining.azurecr.io/bind:$1

	# deploy new docker container
  kubectl set image deployment/ns1-deployment ns1=dnstraining.azurecr.io/bind:$1
  kubectl set image deployment/ns2-deployment ns2=dnstraining.azurecr.io/bind:$1
fi
