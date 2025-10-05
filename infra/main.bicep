param location string = resourceGroup().location
param namePrefix string = 'todo'

var swaName = '${namePrefix}-app'
var storageAccountName = toLower('${namePrefix}${uniqueString(resourceGroup().id)}')
var tableName = 'todos'

resource swa 'Microsoft.Web/staticSites@2024-11-01' = {
  name: swaName
  location: location
  properties: {
    buildProperties: {
      appLocation: '/'
      apiLocation: 'api'
      outputLocation: 'build'
    }
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

output staticWebAppHostname string = swa.properties.defaultHostname
output storageTableEndpoint string = sa.properties.primaryEndpoints.table
