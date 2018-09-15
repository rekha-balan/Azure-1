#!/usr/bin/bash

# variable defintion 
baseName=testnw
rg=rg-$baseName
vnet=vnet-$baseName
subnet=default
nsgName=nsg-$baseName
vmSize=Standard_D8s_v3
adminUsername=azuretest
adminPassword=L8ytNthsJDk4fQB
location=southcentralus

# create group / network / nsg 
az group create -n $rg  -l $location 

az network vnet create -g $rg \
--name $vnet --address-prefix 10.10.0.0/24 \
--subnet-name $subnet --subnet-prefix 10.10.0.0/25

az network nsg create --resource-group $rg \
  --name $nsgName

az network nsg rule create --resource-group  $rg \
  --nsg-name $nsgName --name allow-ssh \
  --protocol tcp --direction inbound --priority 1000 --source-address-prefix '*' \
  --source-port-range '*' --destination-address-prefix '*' --destination-port-range 22 \
  --access allow

az network nsg rule create --resource-group  $rg \
  --nsg-name $nsgName --name allow-http \
  --protocol tcp --direction inbound --priority 1001 --source-address-prefix '*' \
  --source-port-range '*' --destination-address-prefix '*' --destination-port-range 80 \
  --access allow

## bastion server 
vmPrefix=bastion1
imageName=OpenLogic:CentOS:7.5:7.5.20180815
vmSize=Standard_D4s_v3
baseNameBastion=$vmPrefix

az network public-ip create --resource-group $rg \
    --name pip-$baseNameBastion --allocation-method static --idle-timeout 4

az network nic create \
    -n nic-$baseNameBastion \
    -g $rg \
    --subnet $subnet \
    --network-security-group $nsgName \
    --public-ip-address pip-$baseNameBastion \
    --vnet-name $vnet 

az vm create \
    -g $rg \
    --os-disk-name osdisk-$baseNameBastion \
    --name vm-$baseNameBastion \
    --nics nic-$baseNameBastion \
    --storage-sku premium_lrs \
    --size $vmSize \
    --image $imageName \
    --admin-username $adminUsername \
    --admin-password $adminPassword \
    --authentication-type password

az vm extension set --resource-group $rg --vm-name vm-$baseNameBastion --name customScript --publisher Microsoft.Azure.Extensions --settings '{"fileUris": ["https://raw.githubusercontent.com/mvsoares/Azure/master/enable-docker-scripts/install-centos.sh"],"commandToExecute": "bash install-centos.sh"}'

vmSize=Standard_D8s_v3
# Ubuntu ACC
vmPrefix=ubuntu-acc
accNet=true
imageName=UbuntuLTS
for i in {1..2}; 
do
    baseNameLoop=$vmPrefix$i
    echo $baseNameLoop

    az network nic create \
        -n nic-$baseNameLoop \
        -g $rg \
        --subnet $subnet \
        --network-security-group $nsgName \
        --vnet-name $vnet \
        --accelerated-networking $accNet

    az vm create \
        -g $rg \
        --os-disk-name osdisk-$baseNameLoop \
        --name vm-$baseNameLoop \
        --nics nic-$baseNameLoop \
        --storage-sku premium_lrs \
        --size $vmSize \
        --image $imageName \
        --admin-username $adminUsername \
        --admin-password $adminPassword \
        --authentication-type password
        
    az vm extension set -g $rg --vm-name vm-$baseNameLoop --name customScript --publisher Microsoft.Azure.Extensions --settings '{"fileUris": ["https://raw.githubusercontent.com/mvsoares/Azure/master/enable-docker-scripts/install-ubuntu.sh"],"commandToExecute": "bash install-ubuntu.sh"}'
done

# Ubuntu NON-ACC
vmPrefix=ubuntu-noacc
accNet=false
imageName=UbuntuLTS
for i in {1..2}; 
do
    baseNameLoop=$vmPrefix$i
    echo $baseNameLoop

    az network nic create \
        -n nic-$baseNameLoop \
        -g $rg \
        --subnet $subnet \
        --network-security-group $nsgName \
        --vnet-name $vnet \
        --accelerated-networking $accNet

    az vm create \
        -g $rg \
        --os-disk-name osdisk-$baseNameLoop \
        --name vm-$baseNameLoop \
        --nics nic-$baseNameLoop \
        --storage-sku premium_lrs \
        --size $vmSize \
        --image $imageName \
        --admin-username $adminUsername \
        --admin-password $adminPassword \
        --authentication-type password

    az vm extension set -g $rg --vm-name vm-$baseNameLoop --name customScript --publisher Microsoft.Azure.Extensions --settings '{"fileUris": ["https://raw.githubusercontent.com/mvsoares/Azure/master/enable-docker-scripts/install-ubuntu.sh"],"commandToExecute": "bash install-ubuntu.sh"}'

done

# centos ACC
vmPrefix=centos-acc
accNet=true
imageName=OpenLogic:CentOS:7.5:7.5.20180815
for i in {1..2}; 
do
    baseNameLoop=$vmPrefix$i
    echo $baseNameLoop

    az network nic create \
        -n nic-$baseNameLoop \
        -g $rg \
        --subnet $subnet \
        --network-security-group $nsgName \
        --vnet-name $vnet \
        --accelerated-networking $accNet

    az vm create \
        -g $rg \
        --os-disk-name osdisk-$baseNameLoop \
        --name vm-$baseNameLoop \
        --nics nic-$baseNameLoop \
        --storage-sku premium_lrs \
        --size $vmSize \
        --image $imageName \
        --admin-username $adminUsername \
        --admin-password $adminPassword \
        --authentication-type password

    az vm extension set --resource-group $rg --vm-name vm-$baseNameLoop --name customScript --publisher Microsoft.Azure.Extensions --settings '{"fileUris": ["https://raw.githubusercontent.com/mvsoares/Azure/master/enable-docker-scripts/install-centos.sh"],"commandToExecute": "bash install-centos.sh"}'
done

# centos NON-ACC
vmPrefix=centos-noacc
accNet=false
imageName=OpenLogic:CentOS:7.5:7.5.20180815
for i in {1..2}; 
do
    baseNameLoop=$vmPrefix$i
    echo $baseNameLoop

    az network nic create \
        -n nic-$baseNameLoop \
        -g $rg \
        --subnet $subnet \
        --network-security-group $nsgName \
        --vnet-name $vnet \
        --accelerated-networking $accNet

    az vm create \
        -g $rg \
        --os-disk-name osdisk-$baseNameLoop \
        --name vm-$baseNameLoop \
        --nics nic-$baseNameLoop \
        --storage-sku premium_lrs \
        --size $vmSize \
        --image $imageName \
        --admin-username $adminUsername \
        --admin-password $adminPassword \
        --authentication-type password

    az vm extension set --resource-group $rg --vm-name vm-$baseNameLoop --name customScript --publisher Microsoft.Azure.Extensions --settings '{"fileUris": ["https://raw.githubusercontent.com/mvsoares/Azure/master/enable-docker-scripts/install-centos.sh"],"commandToExecute": "bash install-centos.sh"}'
done