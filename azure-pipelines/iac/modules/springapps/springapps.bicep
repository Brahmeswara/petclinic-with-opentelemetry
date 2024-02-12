param asaInstanceName string
param appName string
param location string = resourceGroup().location
//param tags object = {}


param artifactRelativePath string
param cpu string 
param memory string   
param runtime string 
param jvmOptions string 



resource asaInstance 'Microsoft.AppPlatform/Spring@2022-12-01'  existing = {
  name: asaInstanceName
}

resource springApp 'Microsoft.AppPlatform/Spring/apps@2022-12-01' = {
  name: appName
  location: location
  parent: asaInstance
  properties: {
    public: true
  }
}


resource springAppDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2022-12-01' = {
  name: 'default'
  parent: springApp
  properties: {
    deploymentSettings: {
      resourceRequests: {
        cpu: cpu
        memory: memory
      }
    }
    source: {
      type: 'Jar'
      jvmOptions: jvmOptions
      runtimeVersion: runtime
      relativePath: artifactRelativePath
    }
  }
}


