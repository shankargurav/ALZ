// spokeVNet.bicep  
// This script deploys one or more Spoke Virtual Networks (VNets) with the provided subnets,  
// and associates the provided Network Security Group (NSG) and Route Table resources with the subnets,  
// except for the 'GatewaySubnet'  
  
// Input parameters  
param location string  
param spokeVirtualNetworks array  
param nsgResourceId string  
param routeTableResourceId string  
  
// Deploy the Spoke VNets  
resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = [for (vnet, i) in spokeVirtualNetworks: {  
  name: vnet.name  
  location: location  
  properties: {  
    addressSpace: {  
      addressPrefixes: [  
        vnet.addressSpace  
      ]  
    }  
    subnets: [for (subnet, j) in vnet.subnets: {  
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
}]  
  
// Output a boolean flag indicating the VNets have been created  
output vnetsCreated bool = true  
