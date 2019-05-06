#!/bin/bash

group=$1
webappname=$2
serviceplan=$3
acccosmosdb=tacccosmosdb
databaseName=tcosmosdb

## create resourcegroup
az group create --name $group --location southcentralus

## Create an App Service plan in FREE tier.
az appservice plan create --name $serviceplan --resource-group $group --number-of-workers 3 --sku B1 --is-linux

## Create an storage account with storage kind
az storage account create --name webappstorage --sku Standard_LRS --resource-group $group \
--kind blobStorage --location southcentralus --access-tier Hot 

## Create an container under existing storage account and kind of storage
## create a container for blobstorage
az storage container create --name blobcontainer --public-access blob \
--account-key SMbLkFIoNkTxNN6VcwkxjDwDriKc8wmfMwupkOOwgOvbE5S5GdFRk4PGdUpKGvIPrCg63ZfSNop0sAA9A0tNBw== \
--account-name twebappstorage

## Create a web app.
az webapp create --name $webappname --resource-group $group --plan $serviceplan -r "node|10.14"

## Configure local Git and get deployment URL
az webapp deployment source config --name $webappname --resource-group $group --branch master --manual-integretion --repo-url https://github.com/HG-SSTARS/revature-p1

## Create a SQL API CosmosDB account
az cosmosdb create --resource-group $group --name $acccosmosdb --kind GlobalDocumentDB

## Create a cosmosdb database
az cosmosdb database create --resource-group $group --name $acccosmosdb --db-name $databaseName
