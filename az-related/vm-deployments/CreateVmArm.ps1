#Login
Connect-AzAccount -SubscriptionName 'TestAccoount'


#Ensure you're pointed at your correct subscription
Set-AzContext -SubscriptionName 'TestAccoount'


#If you resources already exist, you can use this to remove the resource group
Remove-AzResourceGroup -Name 'implementing-IaaS-RG'


#Recreate the Resource Group
New-AzResourceGroup -Name "implementing-IaaS-RG" -Location "westeurope"


#We can deploy ARM Templates using the Portal, Azure CLI or PowerShell
#Make sure to set the "adminPassword" parameter in parameters.json prior to deployment.
New-AzResourceGroupDeployment `
    -Name "VM_Deployment" `
    -ResourceGroupName 'implementing-IaaS-RG' `
    -TemplateFile './template/template.json' `
    -TemplateParameterFile './template/parameters.json'


############################################ Clean up resources ############################################
Remove-AzResourceGroup -Name 'implementing-IaaS-RG'


############################################ Clean up a deployment ############################################
Remove-AzResourceGroupDeployment `
    -ResourceGroupName 'implementing-IaaS-RG' `
    -Name 'VM_Deployment'