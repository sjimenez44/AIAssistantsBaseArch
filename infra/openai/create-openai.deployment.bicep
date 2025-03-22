@description('Specifies the name of the existing Azure OpenAI resource.')
param openaiName string
@description('Defines the name of the OpenAI model deployment.')
param openaiDeploymentName string
@description('Specifies the version of the OpenAI model to deploy.')
param openaiDeploymentVersion string
@description('Sets the capacity (number of instances) for the OpenAI model deployment.')
param openaiDeploymentCapacity int


resource openai 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: openaiName
}


resource openaiDeployment 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  parent: openai
  name: openaiDeploymentName
  sku: {
    name: 'Standard'
    capacity: openaiDeploymentCapacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: openaiDeploymentName
      version: openaiDeploymentVersion
    }
    versionUpgradeOption: 'NoAutoUpgrade'
    currentCapacity: openaiDeploymentCapacity
  }
}
