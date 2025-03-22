@description('Specifies the name of the existing Service Bus namespace where the queue will be created.')
param serviceBusName string
@description('Defines the name of the Service Bus queue to be created.')
param serviceBusQueueName string
@description('Indicates whether the queue requires sessions for message processing. Defaults to false.')
param requiresSession bool = false
@description('Specifies whether duplicate detection is enabled for the queue. Defaults to false.')
param requiresDuplicateDetection bool = false
@description('Defines the time window for detecting duplicate messages. Defaults to 15 minutes.')
param duplicateDetectionWindow string = 'PT15M'
@description('Indicates whether messages that expire should be sent to the dead-letter queue. Defaults to false.')
param deadLetteringOnMessageExpiration bool = false


resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusName
}


resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  parent: serviceBus
  name: serviceBusQueueName
  properties: {
    lockDuration: 'PT1M'
    maxSizeInMegabytes: 1024
    defaultMessageTimeToLive: 'P14D'
    maxDeliveryCount: 10
    enableBatchedOperations: true
    requiresSession: requiresSession
    requiresDuplicateDetection: requiresDuplicateDetection
    duplicateDetectionHistoryTimeWindow: requiresDuplicateDetection ? duplicateDetectionWindow : 'PT10M'
    deadLetteringOnMessageExpiration: deadLetteringOnMessageExpiration
  }
}
