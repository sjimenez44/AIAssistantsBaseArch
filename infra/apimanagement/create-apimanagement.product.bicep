@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Defines the unique name of the API Management product.')
param apiManagementProductName string
@description('Sets the display name of the API Management product.')
param apiManagementProductDisplayName string
@description('Provides a description of the API Management product.')
param apiManagementProductDescription string
@description('Determines if a subscription is required to access the product.')
param requiredSubscription bool = true


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementName
}


resource apiManagementProduct 'Microsoft.ApiManagement/service/products@2024-06-01-preview' = {
  parent: apiManagement
  name: apiManagementProductName
  properties: {
    displayName: apiManagementProductDisplayName
    description: apiManagementProductDescription
    subscriptionRequired: requiredSubscription
    approvalRequired: false
    state: 'published'
  }
}
