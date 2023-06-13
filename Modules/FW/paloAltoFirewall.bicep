param location string  
param vmSize string  
param adminUsername string  
param adminPassword string  
param firewallImagePublisher string  
param firewallImageOffer string  
param firewallImageSku string  
param firewallImageVersion string  
  
// Add existing subnets as parameters  
param snetCoreFwMgmtId string  
param snetCoreFwUntrustId string  
param snetCoreFwTrustId string  
  
// Create network interfaces for both firewalls  
resource firewallNics 'Microsoft.Network/networkInterfaces@2020-11-01' = [for i in range(0, 6): {  
  name: 'firewall${(i / 3) + 1}Nic${i % 3}'  
  location: location  
  properties: {  
    ipConfigurations: [  
      {  
        name: 'ipconfig1'  
        properties: {  
          privateIPAllocationMethod: 'Dynamic'  
          subnet: {  
            id: (i % 3) == 0 ? snetCoreFwMgmtId : ((i % 3) == 1 ? snetCoreFwUntrustId : snetCoreFwTrustId)  
          }  
        }  
      }  
    ]  
  }  
}]  
  
// Create two identical Palo Alto firewall VMs  
resource firewallVm 'Microsoft.Compute/virtualMachines@2021-04-01' = [for i in range(0, 2): {  
  name: 'firewallVm${i + 1}'  
  location: location  
  plan: {  
    name: firewallImageSku  
    publisher: firewallImagePublisher  
    product: firewallImageOffer  
  }  
  properties: {  
    hardwareProfile: {  
      vmSize: vmSize  
    }  
    storageProfile: {  
      imageReference: {  
        publisher: firewallImagePublisher  
        offer: firewallImageOffer  
        sku: firewallImageSku  
        version: firewallImageVersion  
      }  
      osDisk: {  
        osType: 'Linux'  
        createOption: 'FromImage'  
        caching: 'ReadWrite'  
        managedDisk: {  
          storageAccountType: 'Premium_LRS'  
        }  
        diskSizeGB: 60  
      }  
    }  
    osProfile: {  
      computerName: 'firewallVm${i + 1}'  
      adminUsername: adminUsername  
      adminPassword: adminPassword  
      linuxConfiguration: {  
        disablePasswordAuthentication: false  
        provisionVMAgent: true  
      }  
    }  
    networkProfile: {  
      networkInterfaces: [for j in range(0, 3): {  
        id: firewallNics[(i * 3) + j].id  
      }]  
    }  
  }  
}]  
