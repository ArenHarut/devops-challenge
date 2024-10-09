######################################################################################################################################################################################################################
#  Terraform Boot Strapper
#
# Version 1.2.0
#
# Creates resources for terraform deployments
# ===========================================
# - Resource Group
#   + Storage Account with 7 day retention policy
#   + Container for terraform remote state files
#
# Notes
# =====
#
# *** You must be authenticated to Azure using Connect-AzAccount, ensure you have up-to date Az.* modules installed () ***
# *** Connect-AzAccount -UseDeviceAuthentication.
#
# 
# Version History
#
# V1.0.0
#
######################################################################################################################################################################################################################

$subscription             = "eac3e4f1-4cb3-4775-8ac2-412096a64e43"  
$location                 = "East US"
$baseClienteName        = "apvmax"
$keyVaultName           = "shared-apvmax-kv"


$tags = @{
  envirnoment            = "shared"
  serviceName            = "tf_states_storage"
  deploymentRef          = "PowerShell"
  ProjectName            = "ApprovalMax"

}

connect-azaccount
Select-AzSubscription -SubscriptionName $subscription 

$resourceGroupName = $baseClienteName + "-tfstates" + "-rg"
New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tags

$keyVaultName  = $baseClienteName + "-infsecrets" + "-kv"
New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName -Location $location -Tag $tag

  
$storageAccountName = ($baseClienteName -replace '-','').ToLower() + "tfstates" + "sto"
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storageAccountName -Location $location -SkuName "Standard_LRS" -Tag $tags
$storageAccount | Enable-AzStorageDeleteRetentionPolicy -RetentionDays 7
New-AzStorageContainer -Name "terraform-remote-states" -Context $storageAccount.Context -Permission "off"
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName).Value[0]


$Env:ARM_ACCESS_KEY = $storageAccountKey
#export ARM_ACCESS_KEY={}

Write-Host "Subscription         : $subscription"
Write-Host "Resource Group Name  : $resourceGroupName"
Write-Host "Key Vault Name       : $keyVaultName"
Write-Host "Storage Account Name : $storageAccountName"
Write-Host "Storage Access Key   : Stored in ARM_ACCESS_KEY"
Write-Host "Storage_key:    $storageAccountKey"