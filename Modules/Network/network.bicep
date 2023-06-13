// network.bicep  
param location string  
param nsg object  
param routetable object  
param hubVirtualNetwork object  
param spokeVirtualNetworks array  
param targetResourceGroupName string

targetScope = 'subscription'  
  
resource newResourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {  
  name: targetResourceGroupName  
  location: location  
}  

module nsgModule './nsg/nsg.bicep' = {  
  name: 'nsgModule'
  scope: newResourceGroup 
  params: {  
    location: location  
    properties: nsg.properties  
    securityRules: nsg.securityRules  
  }  
}  

module routeTableModule './routetable/routeTable.bicep' = {  
  name: 'routeTableModule'
  scope: newResourceGroup   
  params: {  
    location: location  
    properties: routetable.properties  
    routes: routetable.routes  
  }  
} 

var nsgResourceId  = nsgModule.outputs.nsgResourceId  
var routeTableResourceId = routeTableModule.outputs.routeTableResourceId  
  
module hubVnetModule './hub/hubVNet.bicep' = {  
  name: 'hubVnetDeployment'
  scope: resourceGroup(hubVirtualNetwork.subscriptionId, hubVirtualNetwork.resourceGroup)  
  params: {  
    location: location  
    hubVirtualNetwork: hubVirtualNetwork  
    nsgResourceId: nsgResourceId  
    routeTableResourceId: routeTableResourceId  
  }  
}  
  
module spokeVnetModule './spoke/spokeVNet.bicep' = {  
  name: 'spokeVNetDeployment'  
  scope: resourceGroup(spokeVirtualNetworks[0].subscriptionId, spokeVirtualNetworks[0].resourceGroup)   
  params: {  
    location: location  
    spokeVirtualNetworks: spokeVirtualNetworks  
    nsgResourceId: nsgResourceId  
    routeTableResourceId: routeTableResourceId  
  }  
}  
  

module vnetPeering './peering/vnetPeering.bicep' = [for (spokeVnetwork, i) in spokeVirtualNetworks: {  
  name: 'vnetPeering-${i}' 
  scope: resourceGroup(targetResourceGroupName) 
  params: {  
    hubVnetId: hubVnetModule.outputs.hubVnetResourceId  
    spokeVnetId: resourceId('Microsoft.Network/virtualNetworks', spokeVnetwork.name)  
    vnetsCreated: spokeVnetModule.outputs.vnetsCreated  
  }  
  dependsOn: [  
    nsgModule, routeTableModule,hubVnetModule  
  ]  
}]  


