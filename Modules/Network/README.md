# Network Modules  
  
This repository contains Bicep templates for deploying and configuring network resources in Azure. The templates are organized into modules for better maintainability and reusability.  
  
## Modules  
  
### hub  
  
The `hub` module deploys a Hub Virtual Network (VNet) with the provided subnets and associates the provided Network Security Group (NSG) and Route Table resources with the subnets, except for the 'GatewaySubnet'.  
  
- hubVnet.bicep  
- hubVnet.parameters.json  
  
### nsg  
  
The `nsg` module deploys a Network Security Group (NSG) with the provided security rules.  
  
- nsg.bicep  
- nsg.parameters.json  
  
### peering  
  
The `peering` module deploys Virtual Network (VNet) peering between two virtual networks.  
  
- vnetPeering.bicep  
  
### routetable  
  
The `routetable` module deploys a Route Table with the provided routes.  
  
- routetable.bicep  
- routetable.parameters.json  
  
### spoke  
  
The `spoke` module deploys one or more Spoke Virtual Networks (VNets) with the provided subnets and associates the provided Network Security Group (NSG) and Route Table resources with the subnets, except for the 'GatewaySubnet'.  
  
- spokeVNet.bicep  
- spokeVNet.parameters.json  
  
## Usage  
  
To deploy a specific module, navigate to the respective folder and use the `az deployment group create` command with the appropriate Bicep file and parameters file.  
  
For example, to deploy the `hub` module:  
  
```bash  
az deployment group create --name hubVnetDeployment --resource-group myResourceGroup --template-file hubVnet.bicep --parameters @hubVnet.parameters.json  
