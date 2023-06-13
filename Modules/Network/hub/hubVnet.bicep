// hubVirtualNetwork.bicep  
// This script deploys a Hub Virtual Network (VNet) with the provided subnets,  
// and associates the provided Network Security Group (NSG) and Route Table resources with the subnets,  
// except for the 'GatewaySubnet'  
  
param location string  
param hubVirtualNetwork object  
param nsgResourceId string  
param routeTableResourceId string  
  
// Add a dependsOn property to ensure the VNet is created after the NSG and Route Table resources  
resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {  
  name: hubVirtualNetwork.name  
  location: location  
  properties: {  
    addressSpace: {  
      addressPrefixes: [  
        hubVirtualNetwork.addressSpace  
      ]  
    }  
    subnets: [for (subnet, j) in hubVirtualNetwork.subnets: {  
      name: subnet.name  
      properties: {  
        addressPrefix: subnet.addressPrefix  
        serviceEndpoints: contains(subnet, 'serviceEndpoints') ? subnet.serviceEndpoints : null  
        routeTable: !empty(routeTableResourceId) && subnet.name != 'GatewaySubnet' ? {  
          id: routeTableResourceId  
        } : null  
        networkSecurityGroup: !empty(nsgResourceId) && subnet.name != 'GatewaySubnet' ? {  
          id: nsgResourceId  
        } : null  
      }  
    }]  
  }  
  dependsOn: [     
  ]  
}  
  
output hubVnetResourceId string = vnet.id  
