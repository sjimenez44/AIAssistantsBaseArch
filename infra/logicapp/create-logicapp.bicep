@description('Specifies whether the Logic App should be Enabled or Disabled')
@allowed([
  'Enabled'
  'Disabled'
])
param logicAppState string
@description('Defines the type of identity to use: No identity, System Managed Identity (SMI), or User Assigned Managed Identity (UAMI)')
@allowed([
  'No'
  'SMI'
  'UAMI'
])
param useIdentity string
@description('The name of the Logic App to be created')
param logicAppName string
@description('The JSON definition of the Logic App workflow')
param definition string
@description('The name of the User Assigned Managed Identity (only required if useIdentity is set to UAMI)')
param managedIdentityName string = ''
@description('Specifies the location where the Logic App will be deployed. Defaults to the resource group location')
param location string = resourceGroup().location
@description('A set of tags to apply to the Logic App resource')
param tags object


resource userIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  tags: tags
  identity: (useIdentity == 'No')
    ? null
    : (useIdentity == 'SMI')
        ? {
            type: 'SystemAssigned'
          }
        : {
            type: 'UserAssigned'
            userAssignedIdentities: {
              '${userIdentity.id}': {}
            }
          }
  properties: {
    definition: json(definition)
    state: logicAppState
  }
}
