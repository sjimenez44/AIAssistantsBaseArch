@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Defines the unique name of the API in API Management.')
param apiManagementApiName string
@description('Specifies the display name of the API.')
param apiManagementApiDisplayName string
@description('Defines the base path for the API in API Management.')
param apiManagementApiPathName string
@description('Specifies the version name of the API if versioning is enabled.')
param apiManagementApiVersionName string
@description('Determines whether the API requires a subscription key for authentication.')
param withSubsKey bool = true
@description('Indicates whether OAuth authentication is enabled for the API.')
param withOAuth bool = false
@description('Determines whether API versioning is enabled.')
param versionedAPI bool = false


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementName
}


resource apiManagementApiVersionSets 'Microsoft.ApiManagement/service/apiVersionSets@2024-06-01-preview' = {
  parent: apiManagement
  name: guid(apiManagementName, apiManagementApiName, apiManagementApiDisplayName, apiManagementApiVersionName)
  properties: {
    displayName: apiManagementApiDisplayName
    versioningScheme: 'Segment'
  }
}

resource apiManagementAPI 'Microsoft.ApiManagement/service/apis@2024-06-01-preview' = {
  parent: apiManagement
  name: apiManagementApiName
  properties: {
    displayName: apiManagementApiDisplayName
    apiRevision: '1'
    subscriptionRequired: true
    path: apiManagementApiPathName
    protocols: [
      'https'
    ]
    isCurrent: true
    authenticationSettings: withOAuth ? null : {
      oAuth2AuthenticationSettings: []
      openidAuthenticationSettings: []
    }
    subscriptionKeyParameterNames: withSubsKey ? {
      header: 'api-key'
      query: 'api-key'
    } : null
    apiVersion: versionedAPI ? apiManagementApiVersionName : null
    apiVersionSetId: versionedAPI ? apiManagementApiVersionSets.id : null
  }
}
