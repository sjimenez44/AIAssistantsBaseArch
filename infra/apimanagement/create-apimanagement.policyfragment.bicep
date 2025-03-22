@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Defines the unique name of the policy fragment in API Management.')
param apiManagementPolicyFragmentName string
@description('Specifies the XML content of the policy fragment.')
param apiManagementPolicyFragmentValue string


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementName
}


resource apiManagementPolicyFragment 'Microsoft.ApiManagement/service/policyfragments@2024-06-01-preview' = {
  parent: apiManagement
  name: apiManagementPolicyFragmentName
  properties: {
    value: apiManagementPolicyFragmentValue
  }
}
