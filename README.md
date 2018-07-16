# DNS Training

The purpose of this project is to test deployment of bind DNS server with Kubernetes/Docker
that is authoritative for a real domain: dns.training.

It contains configuration and scripts that can be used to build and deploy bind docker containers
in Azure.

e.g.
```
$ dig dns.training SOA +noall +answer +authority

; <<>> DiG 9.8.3-P1 <<>> dns.training SOA +noall +answer +authority
;; global options: +cmd
dns.training.		604743	IN	SOA	ns1.dns.training. admin.dns.training. 2017071401 1800 900 604800 300
dns.training.		604743	IN	NS	ns2.dns.training.
dns.training.		604743	IN	NS	ns1.dns.training.
```

## Getting Started

This project has configuration files that can be used to create a bind docker container, push that container to
the Azure Container Registry (acr), and then deploy instances of that container via the Azure Kubernetes Service (aks).

These steps can be performed with the following helper scripts:

* build container: ```./scripts/build.sh``` (using ./Dockerfile, ./entrypoint.sh and bind configs in config/)
* push container to acr and deploy in aks: ```./scripts/deploy.sh <version number>```

There are additional scripts to help with the build process:

* run container locally: ```./scripts/run.sh```
* get shell of locally running container: ```./scripts/shell.sh```


## Prerequisites

The scripts assume an Azure account has been setup with the following components created:

* Azure Container Registry (acs): https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli#create-a-container-registry
* Azure Kubernetes Service (aks): https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#create-aks-cluster

They also assume the shell environment has been set up for the Azure account:

* Install Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
* Authenticate account: ```az login```
* Install Kubernetes CLI: ```az aks install-cli```
* Authenticate Kubernetes: ```az aks get-credentials --resource-group <myAKSCluster> --name <myAKSCluster>```

Finally, Docker must be installed on the server where you are building the container images: https://docs.docker.com/install/


## Build Docker Image

To build a new docker image of bind, use the helper script:

```
$ ./scripts/build.sh
```


Then inspect the imgage just built:

```
$ docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE
bind                                   latest              dbcd14c47700        4 seconds ago       434MB
```

## Run Docker Image

The previously built image can be tested by running it locally:
```
$ ./scripts/run.sh
```

There should now be a bind container running locally. Try to query it:
```
$ dig @localhost +short dns.training SOA
ns1.dns.training. admin.dns.training. 2017071401 1800 900 604800 300
```

## Get Container Shell

If more testing is needed, you can drop into a shell of the bind container:
```
$ ./scripts/shell.sh
[root@408e3062a3c1 /]#
[root@408e3062a3c1 /]# echo hello!
hello!
```

## Deploy Container in Azure Kubernetes Service (aks)

If the bind container seems to be working locally, deploy two bind containers in Azure via kubernetes:
```
$ kubectl create -f kubernetes/ns1.yaml
$ kubectl create -f kubernetes/ns2.yaml
```

After the initial deployment, new builds can be deployed
(note that the version number must be updated on each run):
```
$ ./scripts/deploy <version number (e.g. 001)>
```

## Configuration

The bind service is configured via ./config/named.conf and ./config/zones/db.dns.training. These configurations
are built into the container via a declaration the ```Dockerfile```.

When the container is deployed, these configs will be deployed with it.

## Architecture

This setup has two DNS servers running in master/master. Since the bind configs are deployed as part of the container,
it will be much faster to deploy new configs vs. a typical master/slave setup in which the slave only does a refresh
on the order of 10's of minutes, hours or even days.

## Future Work

* Use a different docker base image that results in smaller image size (perhaps alpine Linux: https://hub.docker.com/_/alpine/). Currently uses centOS base and resultant bind image is ~400mb
* Add other DNS use cases to this project (master/slave, hidden master/slave,slave, resursive server, forwarding server)
* Build out an anycast network and use to serve anycast DNS (https://www.linkedin.com/pulse/build-your-own-anycast-network-9-steps-samir-jafferali/, https://en.wikipedia.org/wiki/Anycast#Domain_Name_System)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
