@description('The name of the User Assigned Managed Identity.')
param managedIdentityName string
@description('The location where the Managed Identity will be deployed. Defaults to the resource group location.')
param location string = resourceGroup().location
@description('Additional tags to be applied to the Managed Identity.')
param tags object



resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
  tags: tags
}
