#################################################### ARM template - Deploying a container using ARM template
# of course, it can also be deployed using an ARM template
New-AzResourceGroupDeployment `
    -Name "ACI-deployment" `
    -ResourceGroupName 'implementing-IaaS-RG' `
    -TemplateFile './template/aci-template.json' `
    -TemplateParameterFile './template/ACI-parameters.json'