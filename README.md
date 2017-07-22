# Fabric8 on Azure (acs k8)

See it in action here: https://youtu.be/BaHjpqQ4eso

- What is Fabric8, Why use it
  - Tooling OOB: CICD/ Pipelines, Repo, Nexus3, JForge
  - GoFabric8 —> MiniKube for Local development
  - Engine for Openshift, perhaps interesting for Enterprise development on kubernetes

- NOTE:
  - In order to get this working on Azure, use the Ingress controller: kubectl apply -f http://central.maven.org/maven2/io/fabric8/devops/apps/ingress-nginx/2.2.334/ingress-nginx-2.2.334-kubernetes.yml	
  - kubectl label node [node name] --overwrite fabric8.io/externalIP=true
  - AND per node add the following to your docker daemon: --insecure-registry=10.0.0.0/8    Azure Container Service only accepts 127.0.0.1 as insecure registry by default. By adding this line in the /etc/systemd/ ....  you will accept the default repo from fabric8 as well :)

# GoFabric8 Demo

## Fabric8 Local
- install fabric8 local: gofabric8 start
- minikube start
- gofabric8 deploy
- minikube service fabric8

## Fabric8 on Azure Kubernetes
- install fabric8 on Kubernetes cluster (Azure Container Service)
  - Setup kubernetes cluster and scale out with 5
  - az group create --name $rgroup --location $location
  - az acs create --name $name --resource-group $rgroup --orchestrator-type=kubernetes --dns-prefix=$name --generate-ssh-keys
  - az acs scale --resource-group=vuggiedemo2 --name=vuggiedemo2 --new-agent-count=5
  - gofabric8 
    - show context: kubectl config get-contexts
    - gofabric8 deploy --namespace=superdevs
    - gofabric8 volumes --namespace=superdevs
    - gofabric8 validate --namespace=superdevs
  - Configure fabric8
    - Expose fabric8 svc as Type LoadBalancer
    - Change ExposeController: kubectl edit configmaps exposecontroller: change domain and exposer to LoadBalancer
  - Create Application
    - Show JForge/ Gogs/ Jenkins
    - Get Project Local ...and start developing
    - NB: Add fabric8 to existing maven pom with this command: mvn io.fabric8:fabric8-maven-plugin:3.4.1:setup

## Getting your Springboot App on Kubernetes
- Create Registry on Azure with ACR (Azure Container Registry)
- Create Kubernetes secret: kubectl create secret docker-registry NAMEOFKEY --docker-server=URL_OF_ACR --docker-username=USER --docker-password=PASS  --docker-email=EMAIL
- mvn build package fabric8:build 
- mvn fabric8:resource
- Add Secret to app: src/main/fabric8/deployment.yml 
      imagePullSecrets:
      - name: NAME_OF_KEY
- Example of plugin configuration fabric8.maven.plugin 
- Example of docker-assembly.xml
- mvn fabric8: push
- mvn fabric8: deploy

## Other Stuff Show Helm and Nexus 3
- Helm install and configure Nexus3 : Helm init/ helm search nexus
- Edit config maps: kubctl edit configmaps catalog-nexus
- Edit svc kubect edit svc nexus3

References:
- Helm: https://github.com/kubernetes/helm
- Minikube: https://fabric8.io/guide/getStarted/minikube.html
- GoFabric8: https://github.com/fabric8io/gofabric8
- Maven plugin documentation: https://maven.fabric8.io/
