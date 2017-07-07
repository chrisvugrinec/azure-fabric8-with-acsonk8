#!/bin/bash
echo "name:"
read name
echo "resource group"
read rgroup
echo "location:"
read location

az group create --name $rgroup --location $location

az acs create --name $name --resource-group $rgroup --orchestrator-type=kubernetes --dns-prefix=$name --generate-ssh-keys

echo "now get the kube config to your local drive with this command:"
echo "az acs kubernetes get-credentials --resource-group=$rgroup --name=$name"
