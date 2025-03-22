@description('Specifies the name of the Event Grid topic.')
param eventGridTopicName string
@description('Specifies the location of the Event Grid topic. Defaults to the resource group location.')
param location string = resourceGroup().location

resource eventGrid 'Microsoft.EventGrid/topics@2025-02-15' = {
  name: eventGridTopicName
  location: location
  properties: {
    inputSchema: 'CloudEventSchemaV1_0'
    minimumTlsVersionAllowed: '1.2'
    disableLocalAuth: true
    dataResidencyBoundary: 'WithinRegion'
  }
}
