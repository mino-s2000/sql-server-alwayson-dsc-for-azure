# SQL Server AlwaysOn for Azure with Automation DSC
## Overview
This project is for building Azure with SQL Server AlwaysOn.

SQL Server 2016 can now be combined with Workgroup. However, as manual work increases, we are also building a Domain Controller in this project.

## Deploy to Azure
### 0. Requirement
- Azure Environment
  [Create your Azure free account today](https://azure.microsoft.com/en-us/free/)
- Terraform
  - [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)
- Azure PowerShell
  - [Install Azure PowerShell on Windows with PowerShellGet](https://docs.microsoft.com/ja-jp/powershell/azure/install-azurerm-ps?view=azurermps-6.8.1)
    > Starting with Azure PowerShell version 6.0, Azure PowerShell requires PowerShell version 5.0. To check the version of PowerShell running on your machine, run the following command:
    > ```PowerShell
    > $PSVersionTable.PSVersion
    > ```

### 1. Deploy Virtual Machines
1. Edit [Terraform/variables.tf](https://github.com/mino-s2000/sql-server-alwayson-dsc-for-azure/blob/master/Terraform/variables.tf) for your environment.
2. Run in PowerShell console.
    ```
    cd Terraform
    terraform.exe init
    ```
3. NO Errors, run next.
    ```
    terraform.exe plan
    ```
4. If you are satisfied with the content displayed, run next.
    ```
    terraform.exe apply
    ```

    Appear confirmation message, Type 'Y' and Enter.
5. Wait a minutes.
6. Please check Azure Portal when you are done.

### 2. Configuring Azure Automation and Register DSC Node
1. Edit [Script/parameters.ps1](https://github.com/mino-s2000/sql-server-alwayson-dsc-for-azure/blob/master/Script/parameters.ps1) for your environment.
2. Run in PowerShell console. Requires run as administrator.
    ```
    cd Script
    .\Config-AzureRmAutomationAccount.ps1 -ParameterFilePath "path\to\parameters.ps1"
    ```
3. Follow the message and continue with the configuration.

## License
MIT License
