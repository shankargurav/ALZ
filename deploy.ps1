# Set variables  
$location = "<YourLocation>"  
$VerbosePreference = 'Continue'  
  
# Deploy Bicep modules in sequence  
$modulePaths = @(  
    "Modules\Backup\backupVault.bicep",  
    "Modules\dns\dnsServers.bicep",  
    "Modules\FW\paloAltoFirewall.bicep",  
    "Modules\LogAnalytics\logAnalyticsWorkspace.bicep",  
    "Modules\Network\hub\hubVnet.bicep",  
    "Modules\Network\networkPairing.bicep",  
    "Modules\Network\spoke\spokeVNet.bicep",  
    "Modules\Network\vnet.bicep"  
)  
  
$parameterFiles = @(  
    "Modules\Backup\backupVault.parameters.json",  
    "Modules\dns\dnsServers.parameters.bicep",  
    "Modules\FW\paloAltoFirewall.parameters.json",  
    "", # No parameter file for logAnalyticsWorkspace.bicep  
    "Modules\Network\hub\hubVnet.parameters.json",  
    "", # No parameter file for networkPairing.bicep  
    "Modules\Network\spoke\spokeVNet.parameters.json",  
    ""  # No parameter file for vnet.bicep  
)  
  
for ($i = 0; $i -lt $modulePaths.Count; $i++) {  
    $modulePath = $modulePaths[$i]  
    $parameterFile = $parameterFiles[$i]  
    $deploymentName = "deployment-$i"  
  
    Write-Verbose "Starting deployment for module: $modulePath"  
  
    try {  
        if ($parameterFile) {  
            $result = az deployment sub create `
                --location $location `
                --template-file "landingzone\WestUS\$modulePath" `
                --parameters @"landingzone\WestUS\$parameterFile" `
                --name $deploymentName `
                --verbose  
        } else {  
            $result = az deployment sub create `
                --location $location `
                --template-file "landingzone\WestUS\$modulePath" `
                --name $deploymentName `
                --verbose  
        }  
        $resultJson = $result | ConvertFrom-Json  
        Write-Verbose "Deployment succeeded for module: $modulePath"  
        Write-Verbose "Deployment outputs:`n $($resultJson.properties.outputs | ConvertTo-Json)"  
    } catch {  
        Write-Host "Error: Module deployment failed for $modulePath" -ForegroundColor Red  
        Write-Host "Deployment stopped." -ForegroundColor Red  
        break  
    }  
}  
  
# Run the PowerShell script for DNS configuration if all modules are deployed successfully  
if ($i -eq $modulePaths.Count) {  
    .\landingzone\WestUS\Modules\dns\ConfigureAzureADDNSServers.ps1  
}  
