#Set Deployment Variables
$ResourceGroup="ACS-RG"
$Location="westeurope"
$AKSClusterName="BJSS-DEMO-ACS"
$AKSNamespace1="sock-shop"
$AKSNamespace2="monitoring"

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

sleep 300

#Connect to the Kubernetes Cluster
az acs kubernetes get-credentials --resource-group=$ResourceGroup --name=$AKSClusterName

# Return a list of Kubernetes Nodes
nodes=$(kubectl get nodes)
echo "$nodes"

#Create the Kubernetes Namespace
kubectl create namespace $AKSNamespace1
kubectl create namespace $AKSNamespace2

#Deploy SockShop Application
kubectl apply -f https://github.com/stevejowens81/sockshopdemo/tree/master/microservices-demo/deploy/kubernetes/complete-demo.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-alerting/alertmanager-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-alerting/alertmanager-dep.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-alerting/alertmanager-svc.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/grafana-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/grafana-dep.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/grafana-import-dash-batch.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/grafana-svc.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/monitoring-ns.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-alertrules.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-cr.yml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-crb.yml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-dep.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-exporter-disk-usage-ds.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-exporter-kube-state-dep.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-exporter-kube-state-svc.yaml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-sa.yml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-svc.yaml

kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-logging/elasticsearch.yml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-logging/fluentd-cr.yml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-logging/fluentd-crb.yml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-logging/fluentd-daemon.yml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-logging/fluentd-sa.yml
kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-logging/kibana.yml


steve@Azure:~$ kubectl apply -f https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-cr.yml
Error from server (Forbidden): error when creating "https://raw.githubusercontent.com/stevejowens81/sockshopdemo/master/microservices-demo/deploy/kubernetes/manifests-monitoring/prometheus-cr.yml": clusterroles.rbac.authorization.k8s.io "prometheus" is forbidden: attempt to grant extra privileges: [PolicyRule{Resources:["nodes"], APIGroups:[""], Verbs:["get"]} PolicyRule{Resources:["nodes"], APIGroups:[""], Verbs:["list"]} PolicyRule{Resources:["nodes"], APIGroups:[""], Verbs:["watch"]} PolicyRule{Resources:["nodes/proxy"], APIGroups:[""], Verbs:["get"]} PolicyRule{Resources:["nodes/proxy"], APIGroups:[""], Verbs:["list"]} PolicyRule{Resources:["nodes/proxy"], APIGroups:[""], Verbs:["watch"]} PolicyRule{Resources:["services"], APIGroups:[""], Verbs:["get"]} PolicyRule{Resources:["services"], APIGroups:[""], Verbs:["list"]} PolicyRule{Resources:["services"], APIGroups:[""], Verbs:["watch"]} PolicyRule{Resources:["endpoints"], APIGroups:[""], Verbs:["get"]} PolicyRule{Resources:["endpoints"], APIGroups:[""], Verbs:["list"]} PolicyRule{Resources:["endpoints"], APIGroups:[""], Verbs:["watch"]} PolicyRule{Resources:["pods"], APIGroups:[""], Verbs:["get"]} PolicyRule{Resources:["pods"], APIGroups:[""], Verbs:["list"]} PolicyRule{Resources:["pods"], APIGroups:[""], Verbs:["watch"]} PolicyRule{NonResourceURLs:["/metrics"], Verbs:["get"]}] user=&{kubeconfig  [system:authenticated] map[]} ownerrules=[] ruleResolutionErrors=[]



