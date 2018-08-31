$AzureCred = Get-Credential -Message 'Credential for login to Azure.'
$ResourceGroup = 'DSCTestRG'
$AutomationAccount = 'DSCTestAutomation'
$AutomationCredName = 'ADDomainAdminCred'
$DomainName = 'example.com'
$ADAdminCred = Get-Credential -Message 'Credential for AD Domain Admin.'
$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'FirstDC'
            Role = 'DomainController'
            FirstNode = $true
        },
        @{
            NodeName = 'AdditionalDC'
            Role = 'DomainController'
            FirstNode = $false
        },
        @{
            NodeName = 'FirstSQLNode'
            Role = 'SQLServer'
            FirstNode = $true
        },
        @{
            NodeName = 'AdditionalSQLNode'
            Role = 'SQLServer'
            FirstNode = $false
        }
    )
}
$ADConfigName = 'ActiveDirectoryDomainServiceConfig'
$ADConfigFilePath = "path\to\$($ADConfigName).ps1"
$SQLConfigName = 'SqlServerAlwaysOnConfig'
$SQLConfigFilePath = "path\to\$($SQLConfigName).ps1"
$SQLClusterName = 'sqlcluster'
$SQLClusterSegmentCIDR = '10.0.1.0/24'
$SQLQuorumAzureStorageAccountName = 'dscsqlwitness'
$SQLQuorumAzureStorageAccountKey = '<please type your storage account key>'
$Node = @(
    @{
        Name = 'DC01'
        Role = 'DomainController'
        ConfigName = "$($ADConfigName).$($ConfigData.AllNodes.Where{$_.Role -eq 'DomainController'}.Where{$_.FirstNode -eq $true}.NodeName)"
    },
    @{
        Name = 'DC02'
        Role = 'DomainController'
        ConfigName = "$($ADConfigName).$($ConfigData.AllNodes.Where{$_.Role -eq 'DomainController'}.Where{$_.FirstNode -eq $false}.NodeName)"
    },
    @{
        Name = 'SQL01'
        Role = 'SQLServer'
        ConfigName = "$($SQLConfigName).$($ConfigData.AllNodes.Where{$_.Role -eq 'SQLServer'}.Where{$_.FirstNode -eq $true}.NodeName)"
    },
    @{
        Name = 'DC02'
        Role = 'SQLServer'
        ConfigName = "$($SQLConfigName).$($ConfigData.AllNodes.Where{$_.Role -eq 'SQLServer'}.Where{$_.FirstNode -eq $false}.NodeName)"
    }
)

return @{
    AzureCred = $AzureCred
    ResourceGroup = $ResourceGroup
    AutomationAccount = $AutomationAccount
    AutomationCredName = $AutomationCredName
    DomainName = $DomainName
    ADAdminCred = $ADAdminCred
    ConfigData = $ConfigData
    Config = @(
        @{
            Name = $ADConfigName
            Path = $ADConfigFilePath
            Parameter = @{
                DomainName = $DomainName
                ADAdminCredName = $AutomationCredName
            }
            Node = $Node.Where{$_.Role -eq 'DomainController'}
        },
        @{
            Name = $SQLConfigName
            Path = $SQLConfigFilePath
            Parameter = @{
                ClusterName = $SQLClusterName
                ClusterSegmentCIDR = $SQLClusterSegmentCIDR
                AzureStorageAccountName = $SQLQuorumAzureStorageAccountName
                AzureStorageAccountKey = $SQLQuorumAzureStorageAccountKey
            }
            Node = $Node.Where{$_.Role -eq 'SQLServer'}
        }
    )
}
