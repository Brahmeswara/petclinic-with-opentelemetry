//targetScope = 'subscription'

param asaInstanceName string 
param location string = resourceGroup().location
param tags object = {}
//param resourceGroupName string 

// Organize resources in a resource group
// resource rg 'Microsoft.Resources/resourceGroups@2021-04-01'  existing = {
//  name: resourceGroupName 
//}

resource asaInstance 'Microsoft.AppPlatform/Spring@2022-12-01' = {
  name: asaInstanceName
  location: location
  tags: tags
  sku: {
      name: 'S0'
      tier: 'Standard'
  }
}
