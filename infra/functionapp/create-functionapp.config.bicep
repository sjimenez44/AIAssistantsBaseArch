@description('The name of the Function App.')
param functionAppName string
@description('The runtime stack and version for the Function App. Defaults to Python 3.11.')
param frameworkVersion string = 'Python|3.11'
@description('The source control method used for deployment. Allowed values: None, Github, Tfs, VSO, VSTSRM. Defaults to None.')
@allowed([
  'None'
  'Github'
  'Tfs'
  'VSO'
  'VSTSRM'
])
param scmType string = 'None'


resource functionApp 'Microsoft.Web/sites@2024-04-01' existing = {
  name: functionAppName
}


resource functionAppConfig 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: functionApp
  name: 'web'
  properties: {
    numberOfWorkers: 1
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: frameworkVersion
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    http20Enabled: false
    publicNetworkAccess: 'Enabled'
    vnetRouteAllEnabled: false
    ipSecurityRestrictionsDefaultAction: 'Deny'
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmType: scmType
    scmIpSecurityRestrictionsDefaultAction: 'Deny'
    scmIpSecurityRestrictionsUseMain: false
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    loadBalancing: 'LeastRequests'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 200
    functionsRuntimeScaleMonitoringEnabled: false
  }
}
