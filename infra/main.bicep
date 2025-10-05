param location string = resourceGroup().location
param namePrefix string = 'todo'

var swaName = '${namePrefix}-app'
var storageAccountName = toLower('${namePrefix}${uniqueString(resourceGroup().id)}')
var tableName = 'todos'

resource swa 'Microsoft.Web/staticSites@2024-11-01' = {
  name: swaName
  location: location
  sku: {
    name: 'Free'
  }
  properties: {
    buildProperties: {
      appLocation: '/'
      apiLocation: 'api'
      outputLocation: 'build'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource sa 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}

resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2025-01-01' = {
  name: 'default'
  parent: sa
}

resource todosTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2025-01-01' = {
  name: tableName
  parent: tableService
}

// Grant SWA managed identity access to Storage Table
resource tableDataContributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: '0a9a7e1f-b8c7-4b8c-9c06-4a2a58f18b1d' // Storage Table Data Contributor
}

resource tableAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sa.id, 'tabledata', swa.id, tableDataContributorRole.id)
  scope: sa
  properties: {
    principalId: swa.identity.principalId
    roleDefinitionId: tableDataContributorRole.id
    principalType: 'ServicePrincipal'
  }
}

output staticWebAppHostname string = swa.properties.defaultHostname
output storageTableEndpoint string = sa.properties.primaryEndpoints.table
output swaPrincipalId string = swa.identity.principalId
