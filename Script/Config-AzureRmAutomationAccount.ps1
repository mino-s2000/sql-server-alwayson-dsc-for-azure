# Requires run as administrator
[CmdletBinding()]
param (
    [parameter(Mandatory)]
    [string]$ParameterFilePath
)

# 0. advance preparation
# 0-1. input parameters
$Parameters = . $($ParameterFilePath)

# 0-2. check parameters
Write-Output "Check for your input parameters. (Exclude PSCredential)"
Write-Output "ResourceGroup: $($Parameters.ResourceGroup)"
Write-Output "AutomationAccount: $($Parameters.AutomationAccount)"
Write-Output "AutomationCredName: $($Parameters.AutomationCredName)"
Write-Output "DomainName: $($Parameters.DomainName)"
Write-Output "ConfigData:"
$i = 1
foreach ($node in $Parameters.ConfigData.AllNodes) {
    Write-Output "`tNode $($i):"
    Write-Output "`t`tNodeName: $($node.NodeName)"
    Write-Output "`t`tRole: $($node.Role)"
    Write-Output "`t`tFirstNode: $($node.FirstNode)"
    $i++
}
$i = 1
Write-Output "Config:"
foreach ($config in $Parameters.Config) {
    Write-Output "`tConfig $($i):"
    Write-Output "`t`tName: $($config.Name)"
    Write-Output "`t`tPath: $($config.Path)"
    Write-Output "`t`tParameters:"
    foreach ($configParamKey in $config.Parameter.Keys) {
        Write-Output "`t`t`t$($configParamKey): $($config.Parameter[$configParamKey])"
    }
    $j = 1
    Write-Output "`tNode:"
    foreach ($configNode in $config.Node) {
        Write-Output "`t`tNode $($j):"
        foreach ($nodeKey in $configNode.Keys) {
            Write-Output "`t`t`t$($nodeKey): $($configNode[$nodeKey])"
        }
        $j++
    }
    $i++
}
$read = Read-Host -Prompt "Are the parameters you entered correct ? [Y/n]"
if ($read -cne "Y") {
    Write-Output "Please re-entered parameters."
    return 1
}

# 0-3. login to azure
Write-Output "Login to azure."
Login-AzureRmAccount -Credential $Parameters.AzureCred

# 1. create ps credential
Write-Output "Create PS Credential of Automation parameter."
.\New-AutomationPSCredential.ps1 `
    -ResourceGroup $Parameters.ResourceGroup `
    -AutomationAccountName $Parameters.AutomationAccount `
    -AutomationCredName $Parameters.AutomationCredName `
    -ADAdminCred $Parameters.ADAdminCred

# 2. import dsc configuration
# 2-1. import active directory configuration
Write-Output "Import DSC configuration. Target: $($Parameters.Config[0].Name)"
.\Import-DscConfiguration.ps1 `
    -ResourceGroup $Parameters.ResourceGroup `
    -AutomationAccount $Parameters.AutomationAccount `
    -ConfigName $Parameters.Config[0].Name `
    -ConfigFilePath $Parameters.Config[0].Path

# 2-2. import sql server configuration
Write-Output "Import DSC configuration. Target: $($Parameters.Config[1].Name)"
.\Import-DscConfiguration.ps1 `
    -ResourceGroup $Parameters.ResourceGroup `
    -AutomationAccount $Parameters.AutomationAccount `
    -ConfigName $Parameters.Config[1].Name `
    -ConfigFilePath $Parameters.Config[1].Path

# 3. import dependency module
do {
    Write-Output "Please import module with Azure Portal. Target: 'xActiveDirectory', 'xFailoverCluster' and 'xSQLServer'."
    $read = Read-Host -Prompt "Are you complete import module ? [Y/n]"
} while ($read -cne "Y")

# 4. compile dsc configuration
# 3-1. compile active directory configuration
Write-Output "Compile configuration. Target: $($Parameters.Config[0].Name)"
.\Compile-DscConfiguration.ps1 `
    -ResourceGroup $Parameters.ResourceGroup `
    -AutomationAccount $Parameters.AutomationAccount `
    -ConfigName $Parameters.Config[0].Name `
    -ConfigData $Parameters.ConfigData `
    -Parameters $Parameters.Config[0].Parameter

# 3-2. compile sql server configuration
Write-Output "Compile configuration. Target: $($Parameters.Config[1].Name)"
.\Compile-DscConfiguration.ps1 `
    -ResourceGroup $Parameters.ResourceGroup `
    -AutomationAccount $Parameters.AutomationAccount `
    -ConfigName $Parameters.Config[1].Name `
    -ConfigData $Parameters.ConfigData `
    -Parameters $Parameters.Config[1].Parameter

# 4. register dsc node
foreach ($config in $Parameters.Config) {
    foreach ($node in $config.Node) {
        Write-Output "Register node for config. Target: $($node.Name)"
        .\Register-NodeForDscConfiguration.ps1 `
            -ResourceGroup $Parameters.ResourceGroup `
            -AutomationAccount $Parameters.AutomationAccount `
            -VMName $node.Name `
            -NodeConfigName $node.ConfigName
    }
}

Write-Output "Configuration Complete !"
return 0
