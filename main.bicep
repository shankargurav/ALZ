/*To pass the vNet IDs from the first deployment to the next deployment, you can use the az deployment group create command with the --parameters flag to provide the vNet IDs as a parameter to the next deployment.
Create a new Bicep file, nextDeployment.bicep, and add a parameter to accept the vNet IDs as an input. For example:
param vnetIds array  
...  
// your next deployment resources and configuration  
 
2. Deploy hubVnet.bicep and obtain the vNet IDs using the az deployment group show command mentioned earlier:
vnet_ids=$(az deployment group show --resource-group <YourResourceGroupName> --name <YourDeploymentName> --query 'properties.outputResources[].id' -o tsv)  
 
3. Deploy nextDeployment.bicep using the az deployment group create command with the --parameters flag to pass the vNet IDs:
az deployment group create --resource-group <YourResourceGroupName> --template-file nextDeployment.bicep --parameters vnetIds="$vnet_ids"  
 
Replace <YourResourceGroupName> with the name of your resource group. This command deploys the nextDeployment.bicep file and provides the vNet IDs from the previous deployment as a parameter.

By following these steps, you can pass the vNet IDs from the first deployment to the next deployment as a parameter.

*/

param location string  
param hubVirtualNetworks array  
param spokeVirtualNetworks array  
param vnetPeeringSettings array  
param vnetId string  
param backupVaultName string  
param dailyBackupTime string  
param vmBackupPolicyName string  
param sqlBackupPolicyName string  
param dailyRetentionDays int  
param weeklyRetentionWeeks int  
param monthlyRetentionMonths int  
param yearlyRetentionYears int  
  
module backupVault './modules/Backup/backupVault.bicep' = {  
  name: 'backupVaultModule'  
  params: {  
    location: location  
    backupVaultName: backupVaultName  
    dailyBackupTime: dailyBackupTime  
    vmBackupPolicyName: vmBackupPolicyName  
    sqlBackupPolicyName: sqlBackupPolicyName  
    dailyRetentionDays: dailyRetentionDays  
    weeklyRetentionWeeks: weeklyRetentionWeeks  
    monthlyRetentionMonths: monthlyRetentionMonths  
    yearlyRetentionYears: yearlyRetentionYears  
  }  
}  
  

module networkPairing './Modules/Network/networkPairing.bicep' = {  
  name: 'networkPairing'  
  params: {  
    location: location  
    hubVirtualNetworks: hubVirtualNetworks  
    spokeVirtualNetworks: spokeVirtualNetworks  
    vnetPeeringSettings: vnetPeeringSettings  
  }  
}

  

module logAnalyticsWorkspace './/Modules/LogAnalytics/logAnalyticsWorkspace.bicep' = {  
  name: 'logAnalyticsWorkspace'  
  params: {  
    location: location  
  }  
}  

module paloAltoFirewall './Modules/FW/paloAltoFirewall.bicep' = {  
  name: 'paloAltoFirewall'  
  params: {  
    location: location  
    hubVNetId: vnetId 
  }  
}  

module dnsServers './/Modules/dns/dnsServers.bicep' = {  
  name: 'dnsServers'  
  params: {  
    location: location  
    vnetId: vnetId  
    subnetName: 'dnsSubnet'  
    storageAccountName: 'yourStorageAccountName'  
    storageAccountKey: 'yourStorageAccountKey'  
    scriptUri: 'https://yourStorageAccount.blob.core.windows.net/scripts/ConfigureAzureADDNSServers.ps1'  
  }  
}  


