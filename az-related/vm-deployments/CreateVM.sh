########################### Creating a Windows VM ###########################

#Login to Azure
az login
az account set --subscription "Azure subscription 1"

#List the current resource groups table format
az group list --output table

# Create a resource group if needed
az group create \
    --name "implementing-IaaS-RG" \
    --location "westeurope"

#Creating a Windows VM
az vm create \
  --resource-group "implementing-IaaS-RG" \
  --name "WinVM" \
  --image "win2019datacenter" \
  --admin-username "demoadmin" \
  --admin-password "Password123!"

#Open RDP for remote access
az vm open-port \
  --resource-group "implementing-IaaS-RG" \
  --name "WinVM" \
  --port "3389"

#Get the IP addresses for Remote Access
az vm list-ip-addresses \
  --resource-group "implementing-IaaS-RG" \
  --name "WinVM" \
  --output table


########################### Creating a Linux VM ###########################

#Login to Azure
az login
az account set --subscription "Azure subscription 1"

#List the current resource groups table format
az group list --output table

# Create a resource group if needed
az create \
    --name "implementing-IaaS-RG" \
    --location "westeurope"

#Generate ssh public key if none existing

#Creating a Windows VM
az vm create \
  --resource-group "implementing-IaaS-RG" \
  --name "LinuxVM" \
  --image "UbuntuLTS" \
  --admin-username "demoadmin" \
  --authentication-type "ssh" \
  --ssh-key-value ~/.ssh/id_rsa.pub

#Open RDP for remote access
az vm open-port \
  --resource-group "implementing-IaaS-RG" \
  --name "LinuxVM" \
  --port "22"

#Get the IP addresses for Remote Access
az vm list-ip-addresses \
  --resource-group "implementing-IaaS-RG" \
  --name "LinuxVM" \
  --output table

#Log into the Linux VM
ssh demoadmin@[the_public_ip_here]

########################### Cleanup resources ###########################
az group delete --name "implementing-IaaS-RG"
