[CmdletBinding()]
param (
    [parameter(Mandatory)]
    [string]$ResourceGroup,
    [parameter(Mandatory)]
    [string]$AutomationAccount,
    [parameter(Mandatory)]
    [string]$VMName,
    [parameter(Mandatory)]
    [string]$NodeConfigName,
    [parameter(Mandatory = $false)]
    [ValidateSet('ApplyAndAutocorrect', 'ApplyAndMonitor', 'ApplyOnly')]
    [string]$ConfigMode = 'ApplyOnly'
)

Register-AzureRmAutomationDscNode -ResourceGroupName $ResourceGroup `
    -AutomationAccountName $AutomationAccount `
    -AzureVMName $VMName `
    -NodeConfigurationName $NodeConfigName `
    -ConfigurationMode $ConfigMode `
    -ConfigurationModeFrequencyMins 60 `
    -RefreshFrequencyMins 30 `
    -RebootNodeIfNeeded $true `
    -ActionAfterReboot ContinueConfiguration `
    -AllowModuleOverwrite $true `
    -Verbose
