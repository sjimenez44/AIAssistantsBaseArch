@description('Specifies the name of the Azure OpenAI resource.')
param openaiName string
@description('Defines the location where the Azure OpenAI resource will be deployed. Defaults to the resource group location.')
param location string = resourceGroup().location
@description('Defines the tags to be assigned to the Azure OpenAI resource.')
param tags object


resource openai 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: openaiName
  location: location
  tags: tags
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    apiProperties: {}
    customSubDomainName: openaiName
    disableLocalAuth: true
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}
