@description('Specifies the name of the Event Grid topic.')
param eventGridTopicName string
@description('Specifies the name of the Event Grid event subscription.')
param eventGridEventSubsName string
@description('Indicates whether event filtering should be enabled. Defaults to false.')
param withFilter bool = false
@description('Defines the list of event types to be included in the filter when filtering is enabled.')
param eventTypesList array = []
@description('Specifies the name of the resource group containing the Service Bus namespace.')
param rgServiceBusName string
@description('Specifies the name of the Service Bus namespace.')
param serviceBusName string
@description('Specifies the name of the Service Bus queue.')
param serviceBusQueueName string


resource eventGrid 'Microsoft.EventGrid/topics@2025-02-15' existing = {
  name: eventGridTopicName
}

resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusName
  scope: resourceGroup(rgServiceBusName)
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' existing = {
  parent: serviceBus
  name: serviceBusQueueName
}


resource eventGridServiceBusEventSubscription 'Microsoft.EventGrid/topics/eventSubscriptions@2025-02-15' = {
  parent: eventGrid
  name: eventGridEventSubsName
  properties: {
    destination: {
      properties: {
        resourceId: serviceBusQueue.id
      }
      endpointType: 'ServiceBusQueue'
    }
    filter: withFilter ? {
      includedEventTypes: eventTypesList
      enableAdvancedFilteringOnArrays: true
    } : null
    eventDeliverySchema: eventGrid.properties.inputSchema
  }
}
