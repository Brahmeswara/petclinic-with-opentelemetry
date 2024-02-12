targetScope = 'subscription'

@minLength(1)
@description('Primary location for all resources')
param location string 
param resourceGroupName string 
param asaInstanceName string
param appName string
param artifactRelativePath string
param cpu string = '1'
param memory string   = '2Gi'
param runtime string = 'Java_17'
param jvmOptions string = '-Xms1024m -Xmx2048m'


// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01'  existing = {
  name: resourceGroupName 
}

module springApps 'modules/springapps/springapps.bicep' = {
  name: '${deployment().name}--appName'
  scope: resourceGroup(rg.name)
  params: {
    location: location
	appName: appName
	asaInstanceName: asaInstanceName
	artifactRelativePath: artifactRelativePath
  cpu : cpu 
  memory : memory
  runtime : runtime
  jvmOptions : jvmOptions
  }
}
