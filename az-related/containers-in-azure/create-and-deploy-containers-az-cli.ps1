#################################################### Create an ACR, a Docker image and push to the registry
#############
#############
#############
############# Define a registry name
# in docker hub I have it as georgeciahir
$ACR_NAME = 'georgeciachirregistry'

############# Login to Azure
az login
az account set --subscription "TestAccount"

############# List the current resource groups table format
az group list --output table

############# Create a resource group if needed
az group create `
    --name "implementing-IaaS-RG" `
    --location "westeurope"

############# Create the container registry
az acr create `
  --resource-group 'implementing-IaaS-RG' `
  --name $ACR_NAME `
  --sku Standard

az acr login --name $ACR_NAME

############# determine the login server name
$ACR_LOGINSERVER = $(az acr show --name $ACR_NAME --query loginServer --output tsv)

############# build and push the image to ACR using docker
docker image build -t azure-iaas-container:1.0 .
docker tag azure-iaas-container:1.0 $ACR_LOGINSERVER/azure-iaas-container:1.0
docker push $ACR_LOGINSERVER/azure-iaas-container:1.0

## list the repositories and  images/tags in thee ACR
az acr repository list --name $ACR_NAME --output table
az acr repository show-tags --name $ACR_NAME --repository azure-iaas-container --output table


############# build and push the image to ACR using ACR task

az acr build --image "azure-iaas-container:1.0" --registry $ACR_NAME .
az acr repository list --name $ACR_NAME --output table
az acr repository show-tags --name $ACR_NAME --repository azure-iaas-container --output table

############# Create a service principal for ACI (couldn't manage to make it work) so that it can pull from ACR
#############
#############
#############
$ACR_NAME = 'georgeciachir'
$ACR_REGISTRY_ID = $(az acr show --name $ACR_NAME --query id --output tsv)
$ACR_LOGINSERVER = $(az acr show --name $ACR_NAME --query loginServer --output tsv)

$SP_NAME = "acr-service-principal"

$SP_PASSWORD = $(az ad sp create-for-rbac `
    --name $SP_NAME `
    --scopes $ACR_REGISTRY_ID `
    --role acrpull `
    --query password `
    --output tsv)

$SP_APPID = $(az ad sp show `
    --id http://$ACR_NAME-pull `
    --query appId `
    --output tsv)

#################################################### Deploying a container from ACR in ACI (Azure Container Instances)
#############
#############
#############

$ACR_LOGINSERVER = $(az acr show --name $ACR_NAME --query loginServer --output tsv)

az container create `
    --resource-group "containers" `
    --name "greeting-app3" `
    --dns-name-label "greeting-app3" `
    --ports 80 `
    --image $ACR_LOGINSERVER/azure-iaas-container:1.0 `
    --registry-login-server $ACR_LOGINSERVER `
    --registry-username georgeciachir `
    --registry-password the_password


#################################################### Deploying a container using YAML
#############
#############
#############
#### For this example, I'm using an image created in the Kubernetes PS courses: https://hub.docker.com/r/georgeciachir/small-app
#### For additional info check out this repo: https://github.com/GeorgeCiachir/learning-k8s
az container create `
    --resource-group 'implementing-IaaS-RG' `
    --file ./yml-deployment/cloud-app-deployment.yml `
    --dns-name-label 'greeting-app'


#################################################### Deploying a container from a public registry (e.g. Docker Hub)
#############
#############
#############
az container create `
    --resource-group implementing-IaaS-RG `
    --name greeting-app-container `
    --dns-name-label greeting-app `
    --image georgeciachir/azure-iaas-container:1.0 `
    --ports 80


#################################################### Show container info
#############
#############
#############
############# Show the container info
az container show --resource-group 'implementing-IaaS-RG' --name 'greeting-app-container'


############# Retrieve the URL, the format is [name].[region].azurecontainer.io
$URL=$(az container show --resource-group 'implementing-IaaS-RG' --name 'greeting-app-container' --query ipAddress.fqdn)
# remove the " from the retrieved url
# access the container on: http://$URL


#################################################### Clean resources
#############
#############
#############
az container delete `
    --resource-group 'implementing-IaaS-RG' `
    --name 'greeting-app-container'
