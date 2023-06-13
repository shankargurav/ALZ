// routetable.bicep  
// This script deploys a Route Table with the provided routes  
  
// Input parameters  
param location string  
param properties object  
param routes array  
  
// Deploy the Route Table  
resource routetable 'Microsoft.Network/routeTables@2020-11-01' = {  
  name: properties.name  
  location: location  
  properties: {  
    disableBgpRoutePropagation: properties.disableBgpRoutePropagation  
  }  
}  
  
// Deploy the routes for the Route Table  
resource route 'Microsoft.Network/routeTables/routes@2020-11-01' = [for (route, i) in routes: {  
  parent: routetable  
  name: '${route.name}'  
  properties: {  
    addressPrefix: route.addressPrefix  
    nextHopType: route.nextHopType  
    nextHopIpAddress: route.nextHopIpAddress  
  }  
}]  
  
// Output the Route Table resource ID  
output routeTableResourceId string = routetable.id  
