param eventGridTopicName string
param eventGridEventSubsName string
param withFilter bool = false
param eventTypesList array = []
param rgServiceBusName string
param serviceBusName string
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
