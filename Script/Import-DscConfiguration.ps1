[CmdletBinding()]
param (
    [parameter(Mandatory)]
    [string]$ResourceGroup,
    [parameter(Mandatory)]
    [string]$AutomationAccount,
    [parameter(Mandatory)]
    [string]$ConfigName,
    [parameter(Mandatory)]
    [string]$ConfigFilePath
)

Remove-AzureRmAutomationDscConfiguration -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -Name $ConfigName -Force -ErrorAction SilentlyContinue
Import-AzureRmAutomationDscConfiguration -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -SourcePath $ConfigFilePath -Published
