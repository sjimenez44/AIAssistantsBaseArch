@description('The name of the existing storage account.')
param storageAccountName string
@description('The name of the blob container to be created.')
param containerName string
@description('The public access level for the blob container. Allowed values: None, Blob, Container. Default value \'None\'.')
@allowed([
  'None'
  'Blob'
  'Container'
])
param publicAccessType string = 'None'


resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = {
  name: storageAccountName
}

resource storageAccountBlobService 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' existing = {
  parent: storageAccount
  name: 'default'
}


resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: storageAccountBlobService
  name: containerName
  properties: {
    publicAccess: publicAccessType
  }
}
