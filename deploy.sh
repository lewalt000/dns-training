#!/bin/sh
az container create --resource-group dns-container-service --name bind --image dnstraining.azurecr.io/bind:9.9.4 --cpu 1 --memory 1 --registry-username dnsTraining --registry-password "XpZokru/nu72aQTMRte0cb0wr6YIxlRJ" --dns-name-label nameserver1 --ports 53 --protocol UDP
