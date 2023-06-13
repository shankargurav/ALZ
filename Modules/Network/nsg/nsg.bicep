// nsg.bicep  
// This script deploys a Network Security Group (NSG) with the provided security rules  
  
// Input parameters  
param location string  
param properties object  
param securityRules array  
  
// Deploy the Network Security Group (NSG)  
resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {  
  name: properties.name  
  location: location  
}  
  
// Deploy the security rules for the NSG  
resource securityRule 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = [for (rule, i) in securityRules: {  
  parent: nsg  
  name: '${rule.name}'  
  properties: {  
    protocol: rule.protocol  
    sourcePortRange: rule.sourcePortRange  
    destinationPortRange: rule.destinationPortRange  
    sourceAddressPrefix: rule.sourceAddressPrefix  
    destinationAddressPrefix: rule.destinationAddressPrefix  
    access: rule.access  
    priority: rule.priority  
    direction: rule.direction  
  }  
}]  
  
// Output the NSG resource ID  
output nsgResourceId string = nsg.id  
