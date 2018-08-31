[CmdletBinding()]
param (
    [parameter(Mandatory)]
    [string]$ResourceGroup,
    [parameter(Mandatory)]
    [string]$AutomationAccount,
    [parameter(Mandatory)]
    [string]$ConfigName,
    [parameter(Mandatory)]
    [hashtable]$ConfigData,
    [parameter(Mandatory)]
    [hashtable]$Parameters
)

$compilationJob = Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -ConfigurationName $ConfigName -ConfigurationData $ConfigData -Parameters $Parameters
while ($compilationJob.EndTime -eq $null -and $compilationJob.Exception -eq $null) {
    $compilationJob = $compilationJob | Get-AzureRmAutomationDscCompilationJob
    Start-Sleep -Seconds 3
}
$compilationJob | Get-AzureRmAutomationDscCompilationJobOutput -Stream Any
