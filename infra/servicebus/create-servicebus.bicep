@description('Specifies the name of the Service Bus namespace.')
param serviceBusName string
@description('Defines the Azure region where the Service Bus namespace will be deployed. Defaults to the resource group location.')
param location string = resourceGroup().location
@description('Specifies the tags to be assigned to the Service Bus namespace.')
param tags object


resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: serviceBusName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    minimumTlsVersion: '1.2'
    disableLocalAuth: true
    zoneRedundant: false
  }
}
