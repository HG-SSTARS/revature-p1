#!/bin/bash

group=$1
webappname=$2
serviceplan=$3

## create resourcegroup
az group create --name $group --location southcentralus

## Create an App Service plan in FREE tier.
az appservice plan create --name $serviceplan --resource-group $group --number-of-workers 3 --sku B1 --is-linux

## Create an storage account with storage kind
az storage account create --name webappstorage --sku Standard_LRS --resource-group $group \
--kind blobStorage --location southcentralus --access-tier Hot 

## Create an container under existing storage account and kind of storage
az storage container create --name blobcontainer --public-access blob --account-key

## Create a web app.
az webapp create --name $webappname --resource-group $group --plan $serviceplan -r "node|10.14"

## Configure local Git and get deployment URL
az webapp deployment source config --name $webappname --resource-group $group --branch master --manual-integretion --repo-url https://github.com/HG-SSTARS/revature-p1
