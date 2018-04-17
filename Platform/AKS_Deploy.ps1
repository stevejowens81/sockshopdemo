#Set Deployment Variables
$ResourceGroup="ACS-RG"
$Location="westeurope"
$AKSClusterName="BJSS-DEMO-ACS"
$AKSNamespace1="sock-shop"
$AKSNamespace2="vote"

# Enable the Required Azure Resource Providers
az provider register -n Microsoft.Network
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Compute
az provider register -n Microsoft.ContainerService

# Create a Azure Resourge Group
az group create --name $ResourceGroup --location $Location

# Create the Kubernetes Cluster
az acs create --orchestrator-type kubernetes --resource-group $ResourceGroup --name $AKSClusterName --generate-ssh-keys

#Install the Kubernetes Command Line Interface
az acs kubernetes install-cli

sleep 1200

#Connect to the Kubernetes Cluster
az acs kubernetes get-credentials --resource-group=$ResourceGroup --name=$AKSClusterName

# Return a list of Kubernetes Nodes
nodes=$(kubectl get nodes)
echo "$nodes"

#Create the Kubernetes Namespace
kubectl create namespace $AKSNamespace1
kubectl create namespace $AKSNamespace2

#Deploy SockShop Application
kubectl apply -f https://bjssdemoacs.blob.core.windows.net/yaml/sockshop/microservices-demo/deploy/kubernetes/complete-demo.yaml
kubectl apply -f https://bjssdemoacs.blob.core.windows.net/yaml/sockshop/microservices-demo/deploy/kubernetes/manifests-alerting/
kubectl apply -f https://bjssdemoacs.blob.core.windows.net/yaml/sockshop/microservices-demo/deploy/kubernetes/manifests-monitoring/
kubectl apply -f https://bjssdemoacs.blob.core.windows.net/yaml/sockshop/microservices-demo/deploy/kubernetes/manifests-logging