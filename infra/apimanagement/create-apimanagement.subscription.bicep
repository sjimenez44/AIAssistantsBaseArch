@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Defines the unique name of the API Management subscription.')
param apiManagementSubscriptionName string
@description('Sets a user-friendly display name for the API Management subscription.')
param apiManagementSubscriptionDisplayName string
@description('Defines the state of the API Management subscription. Allowed values: submitted, active, rejected, cancelled, suspended.')
@allowed([
  'submitted'
  'active'
  'rejected'
  'cancelled'
  'suspended'
])
param apiManagementSubscriptionState string
@description('Specifies the name of the API Management product to which the subscription belongs.')
param apiManagementProductName string


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementName
}

resource apiManagementProduct 'Microsoft.ApiManagement/service/products@2024-06-01-preview' existing = {
  parent: apiManagement
  name: apiManagementProductName
}


resource apiManagementSubscription 'Microsoft.ApiManagement/service/subscriptions@2024-06-01-preview' = {
  parent: apiManagement
  name: apiManagementSubscriptionName
  properties: {
    scope: apiManagementProduct.id
    displayName: apiManagementSubscriptionDisplayName
    state: apiManagementSubscriptionState
    allowTracing: false
  }
}
