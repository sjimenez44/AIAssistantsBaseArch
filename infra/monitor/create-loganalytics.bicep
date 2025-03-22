@description('Specifies the name of the Log Analytics workspace.')
param logAnalyticsName string
@description('Defines the location where the Log Analytics workspace will be deployed. Defaults to the resource group location.')
param location string = resourceGroup().location
@description('Defines the tags to be assigned to the Log Analytics workspace.')
param tags object


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}
