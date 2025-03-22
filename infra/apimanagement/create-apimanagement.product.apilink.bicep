@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Defines the unique name of the API to be linked to the product.')
param apiManagementApiName string


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementName
}

resource apiManagementProduct 'Microsoft.ApiManagement/service/products@2024-06-01-preview' existing = {
  parent: apiManagement
  name: 'assistants'
}

resource apiManagementAPI 'Microsoft.ApiManagement/service/apis@2024-06-01-preview' existing = {
  parent: apiManagement
  name: apiManagementApiName
}


resource apiManagementProductAPILink 'Microsoft.ApiManagement/service/products/apiLinks@2024-06-01-preview' = {
  parent: apiManagementProduct
  name: 'apimlink-${guid(apiManagementName, apiManagementApiName)}'
  properties: {
    apiId: apiManagementAPI.id
  }
}
