@description('Specifies the name of the resource group where the Log Analytics workspace is located.')
param rgLogAnalyticsName string
@description('Specifies the name of the Log Analytics workspace.')
param logAnalyticsName string
@description('Specifies the name of the Application Insights resource.')
param appInsightsName string
@description('Defines the location where the Application Insights resource will be deployed. Defaults to the resource group location.')
param location string = resourceGroup().location
@description('Defines the tags to be assigned to the Application Insights resource.')
param tags object


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(rgLogAnalyticsName)
}


resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'other'
  properties: {
    Application_Type: 'other'
    WorkspaceResourceId: logAnalytics.id
  }
}
