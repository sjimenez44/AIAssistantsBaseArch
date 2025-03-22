@description('Specifies the name of the API Management instance.')
param apiManagementName string
@description('Specifies the name of the backend to be configured in API Management.')
param backendName string
@description('Defines the protocol used by the backend. Currently, only HTTP is allowed.')
@allowed([
  'http'
])
param backendProtocol string
@description('Specifies the URL of the backend service.')
param backendUrl string


resource apiManagement 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementName
}


resource apiBackend 'Microsoft.ApiManagement/service/backends@2024-05-01' = {
  name: backendName
  parent: apiManagement
  properties: {
    protocol: backendProtocol
    url: backendUrl
    tls: {
      validateCertificateChain: true
      validateCertificateName: true
    }
  }
}
