@description('The ID of the Azure subscription where the resources are deployed.')
param subscriptionId string = subscription().subscriptionId
@description('The deployment location of the workbook.')
param location string = resourceGroup().location
@description('The name of the resource group containing the Log Analytics Workspace.')
param resourceGroupLAW string
@description('The name of the Log Analytics Workspace used for monitoring.')
param logAnalyticsName string
@description('The name of the resource group containing the API Management instance.')
param resourceGroupAPIM string
@description('The name of the API Management instance.')
param apiManagementName string
@description('The version of the workbook.')
param workbookVersion string
@description('The display name of the workbook.')
param workbookDisplayName string
@description('A brief description of the workbook.')
param workbookDescription string
@description('The JSON content of the workbook.')
param workbookJson string = '{"version":"Notebook/1.0","items":[{"type":9,"content":{"version":"KqlParameterItem/1.0","parameters":[{"id":"40bdaa68-9f3c-4b6a-9d8a-7d3885f2ee64","version":"KqlParameterItem/1.0","name":"SubscriptionName","type":1,"isHiddenWhenLocked":true,"timeContext":{"durationMs":86400000}}],"style":"pills","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces"},"name":"parameters - 3"},{"type":3,"content":{"version":"KqlItem/1.0","query":"{\\"version\\":\\"ARMEndpoint/1.0\\",\\"data\\":null,\\"headers\\":[],\\"method\\":\\"GET\\",\\"path\\":\\"/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupAPIM}/providers/Microsoft.ApiManagement/service/${apiManagementName}/subscriptions?api-version=2022-08-01\\",\\"urlParams\\":[],\\"batchDisabled\\":false,\\"transformers\\":[{\\"type\\":\\"jsonpath\\",\\"settings\\":{\\"tablePath\\":\\"$.value\\",\\"columns\\":[{\\"path\\":\\"$.name\\",\\"columnid\\":\\"Name\\",\\"columnType\\":\\"string\\"},{\\"path\\":\\"$.properties.createdDate\\",\\"columnid\\":\\"CreatedDate\\",\\"columnType\\":\\"datetime\\"},{\\"path\\":\\"$.properties.state\\",\\"columnid\\":\\"State\\",\\"columnType\\":\\"string\\"},{\\"path\\":\\"$.properties.stateComment\\",\\"columnid\\":\\"StateComment\\",\\"columnType\\":\\"string\\"},{\\"path\\":\\"$.properties.scope\\",\\"columnid\\":\\"Scope\\"}]}}]}","size":0,"exportedParameters":[{"fieldName":"Name","parameterName":"SubscriptionName","parameterType":5}],"queryType":12,"gridSettings":{"sortBy":[{"itemKey":"CreatedDate","sortOrder":1}]},"sortBy":[{"itemKey":"CreatedDate","sortOrder":1}]},"name":"query - 0"},{"type":11,"content":{"version":"LinkItem/1.0","style":"tabs","tabStyle":"smaller","links":[{"id":"03c2ffff-88a7-4b92-aa71-d0837da1a80a","linkTarget":"ArmAction","linkLabel":"Suspend Subscription","style":"link","linkIsContextBlade":true,"armActionContext":{"path":"/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupAPIM}/providers/Microsoft.ApiManagement/service/${apiManagementName}/subscriptions/{SubscriptionName}?api-version=2022-08-01","headers":[{"key":"Content-Type","value":"application/json"}],"params":[],"body":"{\\r\\n  \\"properties\\": {\\r\\n    \\"state\\": \\"suspended\\",\\r\\n    \\"stateComment\\": \\"Payment required\\"\\r\\n  }\\r\\n}","httpMethod":"PATCH","title":"Suspend subscription","description":"Esta accion va a suspender la suscripcion {SubscriptionName}"}},{"id":"2bea358a-75e5-45c1-88cf-44fc4dacd1b7","linkTarget":"ArmAction","linkLabel":"Active Subscription","style":"link","linkIsContextBlade":true,"armActionContext":{"path":"/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupAPIM}/providers/Microsoft.ApiManagement/service/${apiManagementName}/subscriptions/{SubscriptionName}?api-version=2022-08-01","headers":[],"params":[{"key":"Content-Type","value":"application/json"}],"body":"{\\r\\n  \\"properties\\": {\\r\\n    \\"state\\": \\"active\\"\\r\\n  }\\r\\n}","httpMethod":"PATCH","title":"Active subscription","description":"Esta accion va a activar la suscripcion {SubscriptionName}"}}]},"name":"links - 2","styleSettings":{"showBorder":true}},{"type":3,"content":{"version":"KqlItem/1.0","query":"AppMetrics\\r\\n| where Name in (\\"Completion Tokens\\", \\"Prompt Tokens\\", \\"Total Tokens\\")\\r\\n| extend SubscriptionID = tostring(Properties[\\"Subscription ID\\"])\\r\\n| where SubscriptionID == \'{SubscriptionName}\'\\r\\n| summarize CompletionTokens = sumif(Sum, Name == \\"Completion Tokens\\"),\\r\\n            PromptTokens = sumif(Sum, Name == \\"Prompt Tokens\\"),\\r\\n            TotalTokens = sumif(Sum, Name == \\"Total Tokens\\")\\r\\n        by bin(TimeGenerated, 1d), SubscriptionID\\r\\n","size":0,"noDataMessage":"API not consumed","noDataMessageStyle":2,"timeContext":{"durationMs":86400000},"queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","crossComponentResources":["/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupLAW}/providers/Microsoft.OperationalInsights/workspaces/${logAnalyticsName}"]},"name":"query - 1"}],"isLocked":false,"fallbackResourceIds":["Azure Monitor"]}'


resource workbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: 'wb-${guid(resourceGroup().id, 'Microsoft.Insights/workbooks', workbookDisplayName)}'
  location: location
  kind: 'shared'
  properties: {
    category: 'workbook'
    version: workbookVersion
    displayName: workbookDisplayName
    description: workbookDescription
    serializedData: workbookJson
    sourceId: 'Azure Monitor'
  }
}


@description('The ID of the workbook.')
output workbookId string = workbook.id
@description('The URL of the workbook.')
output workbookUrl string = '${environment().portal}/#view/AppInsightsExtension/UsageNotebookBlade/ComponentId/Azure%20Monitor/ConfigurationId/${uriComponent(workbook.id)}/Type/${workbook.properties.category}/WorkbookTemplateName/${uriComponent(workbook.properties.displayName)}'
