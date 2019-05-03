#!/bin/bash
resourcegroup1=$1
vmdisk1=$2
vm1=$3
vmadminusername1=$4
snapname1=$5
copyvmdisk1=$6
vmimage1=$7
vm2=$8



## check & create resourcegroup
checkgroup="$( az group list --query [].name | grep -E $resourcegroup1 )" 
if [ -z $checkgroup ]; then
az group create -n $resourcegroup1 -l southcentralus
fi

## check & create disk
checkdisk="$( az disk list --query [].name | grep -E $vmdisk1 )"
if [ -z $checkdisk ]; then
az disk create -g $resourcegroup1 -n $vmdisk1 --size-gb 30
fi

## check & create vm
checkvm="$( az vm list --query [].name | grep -E $vm1 )"
if [ -z $checkvm ]; then
az vm create -g $resourcegroup1 -n $vm1 --attach-data-disks $vmdisk1 --admin-username $vmadminusername1 --custom-data ./webconfig.txt --image UbuntuLTS --generate-ssh-keys
az vm open-port -g $resourcegroup1 -n $vm1 --port 8000
fi

## detach disk, create snap of the disk & create disk off the snap
az vm disk detach -g $resourcegroup1 -n $vmdisk1 --vm-name $vm1
az snapshot create -n $snapname1 -g $resourcegroup1 --source $vmdisk1 
az disk create -g $resourcegroup1 -n $copyvmdisk1 --source $snapname1

## stop vm, deallocate, generalize, create image & create vm out off the image
az vm stop -g $resourcegroup1 -n $vm1
az vm deallocate -g $resourcegroup1 -n $vm1
az vm generalize -g $resourcegroup1 -n $vm1
az image create -n $vmimage1 --source $vm1 -g $resourcegroup1
az vm create -n $vm2 -g $resourcegroup1 --image $vmimage1