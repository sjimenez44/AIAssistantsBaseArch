@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Defines the unique identifier (path) for the API within API Management.')
param apiPath string
@description('Specifies the unique ID for the API endpoint operation.')
param endpointId string
@description('Sets a user-friendly name for the API endpoint operation.')
param endpointDisplayName string
@description('Defines the HTTP method for the API endpoint operation. Allowed values: GET, POST, PUT, DELETE.')
@allowed([
  'GET'
  'POST'
  'PUT'
  'DELETE'
])
param endpointMethod string
@description('Defines the URL template for the API endpoint operation.')
param endpointUrlTemplate string
@description('Specifies the XML-based policy to be applied to the API endpoint operation.')
param endpointPolicyValue string


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementName
}

resource api 'Microsoft.ApiManagement/service/apis@2024-05-01' existing = {
  name: apiPath
  parent: apiManagement
}


resource apiEndpoint 'Microsoft.ApiManagement/service/apis/operations@2024-05-01' = {
  name: endpointId
  parent: api
  properties: {
    displayName: endpointDisplayName
    method: endpointMethod
    urlTemplate: endpointUrlTemplate
  }
}

resource endpointPolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2024-05-01' = {
  name: 'policy'
  parent: apiEndpoint
  properties: {
    format: 'xml'
    value: endpointPolicyValue
  }
}
