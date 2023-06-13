param location string  
param vnetId string  
param subnetName string  
param dnsServerNames array = ['WUAZRSMADPVW902', 'WUAZRSMADPVW903']  
param vmSize string = 'Standard_D8a_v4'  
param dnsServersAdminUser string  
param dnsServersAdminPassword string  
param storageAccountName string  
param storageAccountKey string  
param scriptUri string  
param dnsServerCount int = 2  

param dnsImageId string = '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/images/GI-2019SQL2019-image-20220113'  
  
resource dnsVms 'Microsoft.Compute/virtualMachines@2020-06-01' = [for (name, i) in dnsServerNames: {  
  name: name  
  location: location  
  properties: {  
    hardwareProfile: {  
      vmSize: vmSize  
    }  
    storageProfile: {  
      imageReference: {  
        id: dnsImageId  
      }  
    }  
    osProfile: {  
      computerName: name  
      adminUsername: dnsServersAdminUser  
      adminPassword: dnsServersAdminPassword  
      windowsConfiguration: {  
        enableAutomaticUpdates: true  
      }  
    }  
    networkProfile: {  
      networkInterfaces: [  
        {  
          id: dnsNics[i].id  
        }  
      ]  
    }  
  }  
}]  
  
resource dnsNics 'Microsoft.Network/networkInterfaces@2020-11-01' = [for (name, i) in dnsServerNames: {  
  name: '${name}-nic'  
  location: location  
  properties: {  
    ipConfigurations: [  
      {  
        name: 'ipconfig1'  
        properties: {  
          subnet: {  
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetId, subnetName)  
          }  
          privateIPAllocationMethod: 'Dynamic'  
        }  
      }  
    ]  
  }  
}]  
  


  
resource dnsCustomScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = [for i in range(0, dnsServerCount): {  
  name: 'dnsServer${i + 1}/CustomScriptExtension'  
  location: location  
  properties: {  
    publisher: 'Microsoft.Compute'  
    type: 'CustomScriptExtension'  
    typeHandlerVersion: '1.10'  
    autoUpgradeMinorVersion: true  
    settings: {  
      fileUris: [  
        scriptUri  
      ]  
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File ConfigureAzureADDNSServers.ps1'  
    }  
    protectedSettings: {  
      storageAccountName: storageAccountName  
      storageAccountKey: storageAccountKey  
    }  
  }  
}]  
