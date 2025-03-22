@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Defines the SKU tier for API Management. Allowed values: Consumption, Developer, BasicV2, StandardV2.')
@allowed([
  'Consumption'
  'Developer'
  'BasicV2'
  'StandardV2'
])
param skuName string = 'Consumption'
@description('The name of the API Management publisher.')
param publisherName string
@description('The email of the API Management publisher.')
param publisherEmail string
@description('Specifies the name of the existing Application Insights resource.')
param appInsightName string
@description('The location where API Management will be deployed.')
param location string = resourceGroup().location
@description('Tags to apply to the API Management resource.')
param tags object


resource appInsight 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightName
}


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' = {
  name: apiManagementName
  location: location
  tags: tags
  sku: {
    name: skuName
    capacity: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publisherName: publisherName
    publisherEmail: publisherEmail
    apiVersionConstraint: {
      minApiVersion: '2019-12-01'
    }
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'False'
    }
  }
}

resource appInsightLogger 'Microsoft.ApiManagement/service/loggers@2024-05-01' = {
  name: 'AppInsightLogger'
  parent: apiManagement
  properties: {
    loggerType: 'applicationInsights'
    resourceId: appInsight.id
  }
}
