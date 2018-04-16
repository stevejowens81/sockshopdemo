#!/bin/bash
#Set Deployment Variables
ResourceGroup="SockShopDemo-RG"
Location="uksouth"
AKSClusterName="SockShopDemo-AKS"
AKSNodes="3"


# Enable the Required Azure Resource Providers
az provider register -n Microsoft.Network
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Compute
az provider register -n Microsoft.ContainerService



# Create a Azure Resourge Group
az group create \
    --name $ResourceGroup \
    --location $Location

az aks create \
    --resource-group $ResourceGroup \
    --name $AKSClusterName \
    --node-count $AKSNodes \
    --generate-ssh-keys

#Install the Kubernetes Command Line
az aks install-cli

#Connect to the Kubernetes Cluster
az aks get-credentials --resource-group $ResourceGroup --name $AKSClusterName

# Return a list of Kubernetes Nodes
nodes=$(kubectl get nodes)
echo "$nodes"