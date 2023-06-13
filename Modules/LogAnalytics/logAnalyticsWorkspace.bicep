param location string  
param logAnalyticsWorkspaceName string = 'logAnalyticsWorkspace'  
  
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {  
  name: logAnalyticsWorkspaceName  
  location: location  
  properties: {  
    sku: {  
      name: 'PerGB2018'  
    }  
  }  
}  
  
output logAnalyticsWorkspaceId string = logAnalytics.id  
