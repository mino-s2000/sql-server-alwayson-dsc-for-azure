[CmdletBinding()]
param (
    [parameter(Mandatory)]
    [string]$ResourceGroup,
    [parameter(Mandatory)]
    [string]$AutomationAccountName,
    [parameter(Mandatory)]
    [string]$AutomationCredName,
    [parameter(Mandatory = $false)]
    [pscredential]$ADAdminCred
)

Remove-AzureRmAutomationCredential -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccountName -Name $AutomationCredName -ErrorAction SilentlyContinue
New-AzureRmAutomationCredential -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccountName -Name $AutomationCredName -Value $ADAdminCred
