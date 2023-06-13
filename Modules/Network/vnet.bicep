param location string  
param dnsServers array  
param vnet object  
  
resource mainVnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {  
  name: vnet.vnetName  
  location: vnet.location  
  properties: {  
    addressSpace: {  
      addressPrefixes: vnet.addressPrefixes  
    }
    dhcpOptions: {  
      dnsServers: dnsServers  
    }
    subnets: [for subnet in vnet.subnets: {  
      name: subnet.name  
      properties: {  
        addressPrefix: subnet.addressPrefix  
        serviceEndpoints: subnet.serviceEndpoints  
        delegations: subnet.delegation ? [{  
          name: subnet.delegation.name  
          properties: {  
            serviceName: subnet.delegation.serviceName  
            actions: subnet.delegation.actions  
          }  
        }] : null  
        routeTable: subnet.routeTable ? {  
          id: subnet.routeTable.id  
        } : null  
      }  
    }]  
  }  
}  
