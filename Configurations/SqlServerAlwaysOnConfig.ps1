Configuration SqlServerAlwaysOnConfig {
    param (
        [Parameter(Mandatory)]
        [string]$ADAdminCredName,
        [Parameter(Mandatory)]
        [string]$ClusterName,
        [Parameter(Mandatory)]
        [string]$ClusterSegmentCIDR,
        [Parameter(Mandatory)]
        [string]$AzureStorageAccountName,
        [Parameter(Mandatory)]
        [string]$AzureStorageAccountKey
    )

    Import-DscResource -ModuleName xFailOverCluster
    $ADAdminCred = Get-AutomationPSCredential -Name $ADAdminCredName

    Node $AllNodes.Where{$_.Role -eq 'SQLServer'}.NodeName {
        WindowsFeature AddFailoverClusterFeature {
            Ensure = 'Present'
            Name = 'Failover-Clustering'
            IncludeAllSubFeature = $true
        }

        WindowsFeature AddRemoteServerAdministrationToolsClusteringPowerShellFeature {
            Ensure = 'Present'
            Name = 'RSAT-Clustering-PowerShell'
            IncludeAllSubFeature = $true
            DependsOn = '[WindowsFeature]AddFailoverClusterFeature'
        }

        WindowsFeature AddRemoteServerAdministrationToolsClusteringCmdInterfaceFeature {
            Ensure = 'Present'
            Name = 'RSAT-Clustering-CmdInterface'
            IncludeAllSubFeature = $true
            DependsOn = '[WindowsFeature]AddRemoteServerAdministrationToolsClusteringPowerShellFeature'
        }
    }

    Node $AllNodes.Where{$_.Role -eq 'SQLServer'}.Where{$_.FirstNode -eq $true}.NodeName {
        WaitForAll AllNode {
            ResourceName = '[WindowsFeature]AddRemoteServerAdministrationToolsClusteringCmdInterfaceFeature'
            NodeName = $AllNodes.Where{$_.Role -eq 'SQLServer'}.NodeName
            RetryIntervalSec = 30
            RetryCount = 30
        }

        xCluster CreateCluster {
            Name = $ClusterName
            StaticIPAddress = $ClusterSegmentCIDR
            DomainAdministratorCredential = $ADAdminCred
            DependsOn = '[WaitForAll]AllNode'
        }

        xClusterQuorum SetQuorumToNodeAndCloudMajority {
            IsSingleInstance = 'Yes'
            Type = 'NodeAndCloudMajority'
            Resource = $AzureStorageAccountName
            StorageAccountAccessKey = $AzureStorageAccountKey
            DependsOn = '[xCluster]CreateCluster'
        }
    }

    Node $AllNodes.Where{$_.Role -eq 'SQLServer'}.Where{$_.FirstNode -eq $false}.NodeName {
        WaitForAll AllNode {
            ResourceName = '[xClusterQuorum]SetQuorumToNodeAndCloudMajority'
            NodeName = $AllNodes.Where{$_.Role -eq 'SQLServer'}.Where{$_.FirstNode -eq $true}.NodeName
            RetryIntervalSec = 60
            RetryCount = 60
        }

        xCluster CreateCluster {
            Name = $ClusterName
            StaticIPAddress = $ClusterSegmentCIDR
            DomainAdministratorCredential = $ADAdminCred
            DependsOn = '[WaitForAll]AllNode'
        }
    }
}
