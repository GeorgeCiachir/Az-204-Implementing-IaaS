# Az Powershell documentation: https://docs.microsoft.com/en-us/powershell/module/az.accounts/?view=azps-7.2.0#accounts

############################################ Login ############################################
Connect-AzAccount -SubscriptionName 'TestAccount'

############################################ Verify I'm using the correct subscription ############################################
Set-AzContext -SubscriptionName 'TestAccount'

############################################ Create a resource group ############################################
New-AzResourceGroup -Name "implementing-IaaS-RG" -Location "westeurope"

############################################ Create a credential to use in the VM creation ############################################
$username = 'demoadmin'
$password = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ($username, $password)

############################################ Create a VM ############################################
New-AzVM `
    -ResourceGroupName 'implementing-IaaS-RG' `
    -Name 'WinVM' `
    -Image 'win2019datacenter' `
    -PublicIpAddressName 'WinVM' `
    -Credential $WindowsCred `
    -OpenPorts 3389


############################################ Get the public Ip of the VM ############################################
# Get the public Ip of the VM
# Method 1
# -> get all the Public Ip Addresses and try to match the VM by name (WinVM-ip most likely corresponds to the WinVM VM)
Get-AzPublicIpAddress `
    -ResourceGroupName 'implementing-IaaS-RG' `

# Method 2
# -> inspect the VirtualMachine object and get the NetworkInterfaces / Id
# -> you'll get something like  /subscriptions/ce7d2e68-c192-4a1d-909d-747e98edcfab/resourceGroups/implementing-IaaS-RG/providers/Microsoft.Network/networkInterfaces/WinVM470
# -> in this case, WinVM470 is the Network interface name
Get-AzVM  `
    -ResourceGroupName 'implementing-IaaS-RG' `
    -Name 'WinVM' -DisplayHint 'Expand'

# -> inspect the previously discovered network interface
# -> get the name of the public ip object from IpConfigurations.PublicIpAddress.Name
Get-AzNetworkInterface `
    -ResourceGroupName 'implementing-IaaS-RG' `
    -Name 'WinVM470'



# inspect the Get the PublicIpAddress object and extract the actual IpAddress
Get-AzPublicIpAddress `
    -ResourceGroupName 'implementing-IaaS-RG' `
    -Name 'WinVM-ip'

# Method 3
# It assumes that the associated public address has been defined at the VM creation
# in order for the assumption to be correct, the PublicIpAddressName needs to be specified at the VM creation ->  -PublicIpAddressName 'the name' `
Get-AzPublicIpAddress `
    -ResourceGroupName 'implementing-IaaS-RG' `
    -Name 'WinVM' | Select-Object IpAddress


############################################ Clean up resources ############################################
Remove-AzResourceGroup -Name 'implementing-IaaS-RG'