
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\150\Service\NavAdminTool.ps1'
Invoke-NAVCodeunit -ServerInstance BCTW -CompanyName 'e2etest' -CodeunitId 50005 -Tenant dealer1 -MethodName PrintReport -Argument 1044884