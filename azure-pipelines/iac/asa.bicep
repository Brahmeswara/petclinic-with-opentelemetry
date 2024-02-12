targetScope = 'subscription'

@minLength(1)
@description('Primary location for all resources')
param resourceGroupName string 
param asaInstanceName string
param location string


// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01'  existing = {
  name: resourceGroupName 
}

module springApps 'modules/springapps/spring-app-instance.bicep' = {
  name: '${deployment().name}--asaInstanceName'
  scope: resourceGroup(rg.name)
  params: {
    location: location	
	  asaInstanceName: asaInstanceName
  }
}
