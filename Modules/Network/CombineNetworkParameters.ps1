$files = @(      
    ".\hub\hubVnet.parameters.json",  
    ".\nsg\nsg.parameters.json",  
    ".\routetable\routetable.parameters.json",  
    ".\spoke\spokeVNet.parameters.json"  
)  
  
$combinedJson = @{  
    "$schema"        = "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#";  
    "contentVersion" = "1.0.0.0";  
    "parameters"     = @{  
        "location"                = @{  
            "value" = "westus";  
        };  
        "targetResourceGroupName" = @{  
            "value" = "rg-bicep-deployment";  
        };  
    }  
}  
  
foreach ($file in $files) {  
    $jsonContent = Get-Content $file | ConvertFrom-Json  
  
    # Replace values in hubVnet.parameters.json  
    if ($file -eq ".\hub\hubVnet.parameters.json") {  
        $jsonContent.parameters.hubVirtualNetwork.value.subscriptionId = "ac06df3d-5456-4fab-a981-4788c0db7744"  
        $jsonContent.parameters.hubVirtualNetwork.value.resourceGroup = "rg-bicep-deployment"  
    }  
    
  
    # Replace values in spokeVNet.parameters.json  
    if ($file -eq ".\spoke\spokeVNet.parameters.json") {  
        foreach ($spokeVNet in $jsonContent.parameters.spokeVirtualNetworks.value) {  
            $spokeVNet.subscriptionId = "ac06df3d-5456-4fab-a981-4788c0db7744"  
            $spokeVNet.resourceGroup = "rg-bicep-deployment"  
        }  
    } 
      
    foreach ($key in $jsonContent.parameters.PSObject.Properties.Name) {  
        if (-not $combinedJson.parameters.ContainsKey($key)) {  
            $combinedJson.parameters[$key] = $jsonContent.parameters.$key  
        }  
    }  
}   
  
$combinedJson | ConvertTo-Json -Depth 10 | Set-Content ".\combined.parameters.json"  
Write-Host "Combined JSON parameters saved to .\combined.parameters.json"  
