@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Defines the unique name of the Named Value in API Management.')
param apiManagementNamedValueName string
@description('Specifies the content of the Named Value. If secret is set to true, it will be stored securely.')
param apiManagementNamedValueContent string


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementName
}


resource apiManagementNamedValue 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  parent: apiManagement
  name: apiManagementNamedValueName
  properties: {
    displayName: apiManagementNamedValueName
    value: apiManagementNamedValueContent
    secret: true
  }
}
