@description('The name of the storage account.')
param storageAccountName string
@description('The location of the storage account. Defaults to the resource group location.')
param location string = resourceGroup().location
@description('The SKU type for the storage account. Allowed values: Standard_LRS, Standard_GRS.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
])
param skuType string
@description('The storage account kind. Allowed values: Storage, StorageV2, BlobStorage, BlockBlobStorage.')
@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'BlockBlobStorage'
])
param kindType string


resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuType
  }
  kind: kindType
  properties: {
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource storageAccountBlobService 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource storageAccountFileService 'Microsoft.Storage/storageAccounts/fileServices@2024-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccountQueueService 'Microsoft.Storage/storageAccounts/queueServices@2024-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource storageAccountTableService 'Microsoft.Storage/storageAccounts/tableServices@2024-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
