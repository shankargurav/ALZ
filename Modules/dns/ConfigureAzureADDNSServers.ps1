# Set your Azure AD DS domain name here  
$AzureADDS_DomainName = "sncorp.smith-nephew.com"  
  
# Install DNS Server role  
Install-WindowsFeature -Name DNS -IncludeManagementTools  
  
# Get Azure AD Domain Services DNS servers  
$AzureADDS_Forest = Get-AzureADDomainService -DomainName $AzureADDS_DomainName  
$dnsServers = @($AzureADDS_Forest.LdapsSettings.ExternalAccessIpAddress, $AzureADDS_Forest.LdapsSettings.ExternalAccessIpAddress)  
  
# Configure DNS forwarders  
$dnsServer = Get-WmiObject -Namespace 'root\MicrosoftDNS' -Class 'MicrosoftDNS_Server' -ComputerName 'localhost'  
$dnsServer.Forwarders = $dnsServers  
$dnsServer.Put()  
  
# Restart DNS Server service  
Restart-Service -Name DNS  
