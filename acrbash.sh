#! /bin/bash
ACR_NAME=lovenregistry
SERVICE_PRINCIPAL_ID=5142f1f9-9eff-45d8-95dd-d23ede5aa703
PASSWORD=CY54v9j7LI3l9qwVsc9lk6ZSrgiY9+PPZi2zMZHwUqs=
APPLICATION_ID=1a0ce872-606b-434b-b8b5-226295377303
TENANT=2aefe889-aca6-4c73-bbf5-03150e7ab661

echo " Logging into Azure Portal"
sleep 2
read -sp "PLEASE ENTER AZURE PASSWORD: " AZ_PASS && echo && az login -u pavan.vn101@gmail.com -p $AZ_PASS

# find the acr registry id
#ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)
#az login --service-principal --username $APPLICATION_ID --password $PASSWORD --tenant $TENANT
#echo " Script is logging into the azure account"
#sleep 2
	#if [[ $(az login  --service-principal --username "$APPLICATION_ID" --password "$PASSWORD" --tenant "$TENANT") ]]; then
	#	echo "Login to azure environment with service principal is Success"
	#	sleep 2
	#	echo "......................................................."
	#fi
	#echo " Bash is trying to log into the acr registry"
	#sleep 2
	#echo "....................................................."
	#if [[ $(az acr login --name "$ACR_NAME") ]]; then
	#	echo "You successfully login into the acr registry"
	#fi
#az acr list --subscription 5142f1f9-9eff-45d8-95dd-d23ede5aa703 --resource-group myresourcegroup --query "[].{acrLoginServer:loginServer}" --output table
#az acr show --name $ACR_NAME --query id --output tsv
echo "Creating resource"
sleep 2
if [[ $(az group create --name lovenresource --location eastus) ]]; then
echo "Resource is created"
fi
echo "Creating the Azure Registry"
echo "..........................."
az acr create --resource-group lovenresource --name privatediwo --sku Basic
echo " Displaying the ACR_ID ......."
sleep 2
ACR_ID=$(az acr show --name privatediwo --query id --output tsv)
echo $ACR_ID
echo " Displaying the server id of the ACR Registry"
sleep 2
az acr list --subscription 5142f1f9-9eff-45d8-95dd-d23ede5aa703 --resource-group lovenresource --query "[].{acrLoginServer:loginServer}" --output table
ACR_REGISTRY=privatediwo
echo "Logging into ACR Registry"
echo "....................................................."
        if [[ $(az acr login --name "$ACR_REGISTRY") ]]; then
               echo "You successfully login into the acr registry"
        fi
echo "........................."
echo "........................."
echo "Check the docker images"
#docker images
#docker tag azure-vote-front privatediwo.azurecr.io/azure-vote-front:v1 && docker push  privatediwo.azurecr.io/azure-vote-front:v1
echo "List the docker images of the ACR_REGISTR"
echo "........................................"
az acr repository list --name "$ACR_REGISTRY" --output table
echo "Assign the pull role for ACR"
echo "................."
sleep 2
az role assignment create --assignee $APPLICATION_ID --scope $ACR_ID --role acrpull
#az aks create --resource-group lovenresource --name bashcluster  --node-count 1 --service-principal $APPLICATION_ID --client-secret $PASSWORD --generate-ssh-keys
echo "merge the created cluster into the kube config file"
echo ".........................................."
echo "Check the status and the orchestrator of the vm"
echo "................................"
az aks get-credentials --resource-group lovenresource --name bashcluster
az vm list -d --query "[?powerState=='VM running']" | grep orchestrator


