param hubVnetId string
param spokeVnetId string
param vnetsCreated bool

resource hubVnetRef 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: last(split(hubVnetId, '/'))
}

resource spokeVnetRef 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: last(split(spokeVnetId, '/'))
}

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  parent: hubVnetRef
  name: '${hubVnetRef.name}-to-${spokeVnetRef.name}'
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnetRef.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
  dependsOn: [
    spokeVnetRef
  ]
}
