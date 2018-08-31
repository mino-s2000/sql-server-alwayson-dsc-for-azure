Configuration ActiveDirectoryDomainServiceConfig {
    param(
        [Parameter(Mandatory)]
        [string]$DomainName,
        [Parameter(Mandatory)]
        [string]$ADAdminCredName
    )

    Import-DscResource -ModuleName xActiveDirectory
    $ADAdminCred = Get-AutomationPSCredential -Name $ADAdminCredName

    Node $AllNodes.Where{$_.Role -eq 'DomainController'}.NodeName {
        WindowsFeature AddActiveDirectoryFeature {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
            IncludeAllSubFeature = $true
        }

        WindowsFeature AddRSAT {
            Ensure = 'Present'
            Name = 'RSAT-AD-PowerShell'
            IncludeAllSubFeature = $true
            DependsOn = '[WindowsFeature]AddActiveDirectoryFeature'
        }
    }

    Node $AllNodes.Where{$_.Role -eq 'DomainController'}.Where{$_.FirstNode -eq $true}.NodeName {
        WaitForAll AllNode {
            ResourceName = '[WindowsFeature]AddRSAT'
            NodeName = $AllNodes.Where{$_.Role -eq 'DomainController'}.NodeName
            RetryIntervalSec = 30
            RetryCount = 30
        }

        xADDomain NewForest {
            DomainName = $DomainName
            DomainAdministratorCredential = $ADAdminCred
            SafemodeAdministratorPassword = $ADAdminCred
            ForestMode = 'WinThreshold'
            DependsOn = '[WaitForAll]AllNode'
        }
    }

    Node $AllNodes.Where{$_.Role -eq 'DomainController'}.Where{$_.FirstNode -eq $false}.NodeName {
        WaitForAll FirstNode {
            ResourceName = '[xADDomain]NewForest'
            NodeName = $AllNodes.Where{$_.Role -eq 'DomainController'}.Where{$_.FirstNode -eq $true}.NodeName
            RetryIntervalSec = 60
            RetryCount = 60
        }

        xADDomainController AddDomainController {
            DomainName = $DomainName
            DomainAdministratorCredential = $ADAdminCred
            SafemodeAdministratorPassword = $ADAdminCred
            DependsOn = '[WaitForAll]FirstNode'
        }
    }
}
