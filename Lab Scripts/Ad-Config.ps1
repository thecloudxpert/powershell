# ----------------------------------------
# 	  AD CONFIGURATION
# ----------------------------------------
$LocalAdminUser = "Administrator"
$LocalAdminPwd = "VMware1!"
$servername = "cx-dc-01"
$ADdomain ="thecloudxpert.local"
$ADNBdomain = "thecloudxpert"

$DefaultPassword = ConvertTo-SecureString "VMware1!" -AsPlainText -force

$RootOU="DC=thecloudxpert,DC=local"
$GlobalOU="OU=Global,DC=thecloudxpert,DC=local"
$ServerOU="OU=Servers,$GlobalOU"
$UserOU="OU=Users,$GlobalOU"
$GroupOU="OU=Groups,$GlobalOU"

# ----------------------------------------
# 	  BEGIN AD CONFIGURATION 
# ----------------------------------------

Import-Module ActiveDirectory

Write-Host "Creating Global OU Structure..." -ForegroundColor Yellow
New-ADOrganizationalUnit "Global" -path $RootOU
Set-ADOrganizationalUnit -Identity $GlobalOU -ProtectedFromAccidentalDeletion $false

Write-Host "Creating User OU" -ForegroundColor Yellow
New-ADOrganizationalUnit "Users" -path $GlobalOU
Set-ADOrganizationalUnit -Identity $UserOU -ProtectedFromAccidentalDeletion $false
Write-Host "Creating Servers OU" -ForegroundColor Yellow
New-ADOrganizationalUnit "Servers" -path $GlobalOU
Set-ADOrganizationalUnit -Identity $ServerOU -ProtectedFromAccidentalDeletion $false
Write-Host "Creating Groups OU" -ForegroundColor Yellow
New-ADOrganizationalUnit "Groups" -path $GlobalOU
Set-ADOrganizationalUnit -Identity $GroupOU -ProtectedFromAccidentalDeletion $false

Write-Host "Creating VMware OU" -ForegroundColor Yellow
New-ADOrganizationalUnit "VMware" -path $ServerOU
Set-ADOrganizationalUnit -Identity "OU=VMware,$ServerOU" -ProtectedFromAccidentalDeletion $false
Write-Host "Creating SQL OU" -ForegroundColor Yellow
New-ADOrganizationalUnit "SQL" -path $ServerOU
Set-ADOrganizationalUnit -Identity "OU=SQL,$ServerOU" -ProtectedFromAccidentalDeletion $false
Write-Host "Creating Application OU" -ForegroundColor Yellow
New-ADOrganizationalUnit "Application" -path $ServerOU
Set-ADOrganizationalUnit -Identity "OU=Application,$ServerOU" -ProtectedFromAccidentalDeletion $false

Write-Host "Creating Service Account OU" -ForegroundColor Yellow
New-ADOrganizationalUnit "Service Accounts" -path $UserOU
Set-ADOrganizationalUnit -Identity "OU=Service Accounts,$UserOU" -ProtectedFromAccidentalDeletion $false

Write-Host "Creating Default Tenant Global Groups for vRealize Automation" -ForegroundColor Yellow

New-ADGroup -Name "GG_VRA_InfrastructureAdmins" -GroupCategory Security -GroupScope Global -Path $GroupOU -Description "Global Group for VMware vRealize Automation Infrastructure Administrators"
New-ADGroup -Name "GG_VRA_TenantAdmins" -GroupCategory Security -GroupScope Global -Path $GroupOU -Description "Global Group for VMware vRealize Automation Tenant Administrators"
New-ADGroup -Name "GG_VRA_FabricAdmins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Automation Fabric Administrators"
New-ADGroup -Name "GG_VRA_BusinessGroupMgrs" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Automation Business Group Managers"
New-ADGroup -Name "GG_VRA_ServiceArchitects" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Automation Service Architects"
New-ADGroup -Name "GG_VRA_ApprovalAdmins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Automation Approval Admins"
New-ADGroup -Name "GG_VRA_BusinessUsers" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Automation Business Users"
New-ADGroup -Name "GG_VRA_DevelopmentUsers" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Automation Business Users"

Write-Host "Creating Global Groups for vRealize - Admins" -ForegroundColor Yellow

New-ADGroup -Name "GG_SQL_Admins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for Microsoft SQL Server Admins"
New-ADGroup -Name "GG_VRO_Admins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Orchestrator Admins"
New-ADGroup -Name "GG_VCS_Admins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vCenter Admins"
New-ADGroup -Name "GG_VLI_Admins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize LogInsight Admins"
New-ADGroup -Name "GG_VROPS_Admins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Operations Admins"

Write-Host "Creating Global Groups for vRealize - Users" -ForegroundColor Yellow
New-ADGroup -Name "GG_VROPS_Users" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Operations Users"
New-ADGroup -Name "GG_VCS_Users" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vCenter Users"
New-ADGroup -Name "GG_VLI_Users" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize LogInsight Users"

Write-Host "Creating Global Groups for vRealize - ReadOnly" -ForegroundColor Yellow
New-ADGroup -Name "GG_VROPS_ReadOnly" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Operations ReadOnly Access"
New-ADGroup -Name "GG_VCS_ReadOnly" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vCenter ReadOnly Access"
New-ADGroup -Name "GG_VLI_ReadOnly" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for VMware vRealize Log Insight ReadOnly Access"


Write-Host "Creating vRealise Service Accounts" -ForegroundColor Yellow

New-ADUser -Name "SVC_VRA_01" -AccountPassword $DefaultPassword -DisplayName "SRV_VRA_IAAS_01" -Path "OU=Service Accounts,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
New-ADUser -Name "SVC_VRA_SQL_01" -AccountPassword $DefaultPassword -DisplayName "SRV_VRA_SQL_01" -Path "OU=Service Accounts,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
New-ADUser -Name "SVC_VRO_SQL_01" -AccountPassword $DefaultPassword -DisplayName "SRV_VRO_SQL_01" -Path "OU=Service Accounts,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
New-ADUser -Name "SVC_SQL_01" -AccountPassword $DefaultPassword -DisplayName "SRV_SQL_01" -Path "OU=Service Accounts,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru

Write-Host "Creating vRealize Automation Users"
New-ADUser -Name "Tenant.Admin" -AccountPassword $DefaultPassword -DisplayName "Tenant.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_TenantAdmins" "Tenant.Admin"
New-ADUser -Name "Infra.Admin" -AccountPassword $DefaultPassword -DisplayName "Infra.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_InfrastructureAdmins" "Infra.Admin"
New-ADUser -Name "Fabric.Admin" -AccountPassword $DefaultPassword -DisplayName "Fabric.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_FabricAdmins" "Fabric.Admin"
New-ADUser -Name "Approval.Admin" -AccountPassword $DefaultPassword -DisplayName "Approval.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_ApprovalAdmins" "Approval.Admin"
New-ADUser -Name "Business.Manager" -AccountPassword $DefaultPassword -DisplayName "Business.Manager" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_BusinessGroupMgrs" "Business.Manager"
New-ADUser -Name "Service.Architect" -AccountPassword $DefaultPassword -DisplayName "Service.Architect" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_ServiceArchitects" "Service.Architect"

Write-Host "Creating Administration Accounts" -ForegroundColor Yellow

New-ADUser -Name "CA.Admin" -AccountPassword $DefaultPassword -DisplayName "CA.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "Enterprise Admins" "CA.Admin"
Add-ADGroupMember -Identity "Domain Admins" "CA.Admin"

New-ADUser -Name "vCenter.Admin" -AccountPassword $DefaultPassword -DisplayName "vCenter.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "Enterprise Admins" "vCenter.Admin"
Add-ADGroupMember -Identity "Domain Admins" "vCenter.Admin"

New-ADUser -Name "SQL.Admin" -AccountPassword $DefaultPassword -DisplayName "SQL.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_SQL_Admins" "SQL.Admin"

New-ADUser -Name "vRO.Admin" -AccountPassword $DefaultPassword -DisplayName "vRO.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRO_Admins" "VRO.Admin"

New-ADUser -Name "vRops.Admin" -AccountPassword $DefaultPassword -DisplayName "vRops.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VROPS_Admins" "vRops.Admin"

Write-Host "Creating User Accounts" -ForegroundColor Yellow
New-ADUser -Name "vRops.User" -AccountPassword $DefaultPassword -DisplayName "vRops.User" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VROPS_Users" "vRops.User"

New-ADUser -Name "vRops.ReadOnly" -AccountPassword $DefaultPassword -DisplayName "vRops.ReadOnly" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VROPS_ReadOnly" "vRops.ReadOnly"

New-ADUser -Name "vLI.ReadOnly" -AccountPassword $DefaultPassword -DisplayName "vLI.ReadOnly" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VLI_ReadOnly" "vLI.ReadOnly"

New-ADUser -Name "vCenter.ReadOnly" -AccountPassword $DefaultPassword -DisplayName "vCenter.ReadOnly" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VCS_ReadOnly" "vCenter.ReadOnly"

New-ADUser -Name "VMware.ReadOnly" -AccountPassword $DefaultPassword -DisplayName "VMware.ReadOnly" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VROPS_ReadOnly" "VMware.ReadOnly"
Add-ADGroupMember -Identity "GG_VCS_ReadOnly" "VMware.ReadOnly"
Add-ADGroupMember -Identity "GG_VLI_ReadOnly" "VMware.ReadOnly"

# Write-Host "Creating SCOM AD Objects - Service Accounts" -ForegroundColor Yellow
# New-ADUser -Name "SRV_SCOM_SQL_01" -AccountPassword $DefaultPassword -DisplayName "SRV_SCOM_SQL_01" -Path "OU=Service Accounts,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
# New-ADUser -Name "SRV_SCOM_APP_01" -AccountPassword $DefaultPassword -DisplayName "SRV_SCOM_APP_01" -Path "OU=Service Accounts,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru

# Write-Host "Creating SCOM AD Objects - Global Groups" -ForegroundColor Yellow
# New-ADGroup -Name "GG_SCOM_Admins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for Microsoft SCOM Administration Access"
# New-ADGroup -Name "GG_SCOM_Users" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for Microsoft SCOM User Access"
# New-ADGroup -Name "GG_SCOM_ReadOnly" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$RootOU" -Description "Global Group for Microsoft SCOM ReadOnly Access"

# Write-Host "Creating SCOM AD Objects - User Accounts" -ForegroundColor Yellow
# New-ADUser -Name "SCOM.Admin" -AccountPassword $DefaultPassword -DisplayName "SCOM.Admin" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
# Add-ADGroupMember -Identity "GG_SCOM_Admins" "SCOM.Admin"
# New-ADUser -Name "SCOM.Reader" -AccountPassword $DefaultPassword -DisplayName "SCOM.Reader" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru
# New-ADUser -Name "SCOM.Writer" -AccountPassword $DefaultPassword -DisplayName "SCOM.Writer" -Path "OU=Users,$RootOU" -PasswordNeverExpires $true -Enabled $true -PassThru

$n=0

Do
    {
	$n++
	New-ADUser -Name "Bus.User0$n" -AccountPassword $DefaultPassword -DisplayName "Bus.User0$n" -Path $UserOU -PasswordNeverExpires $true -Enabled $true -PassThru
	Add-ADGroupMember -Identity "GG_VRA_BusinessUsers" "Bus.User0$n"
	
    } until ($n -eq 5)


$n=0

Do
    {
	$n++
	New-ADUser -Name "Dev.User0$n" -AccountPassword $DefaultPassword -DisplayName "Dev.User0$n" -Path $UserOU -PasswordNeverExpires $true -Enabled $true -PassThru
	Add-ADGroupMember -Identity "GG_VRA_BusinessUsers" "Dev.User0$n"
	
    } until ($n -eq 5)

# ----------------------------------------
# 	  BEGIN AD TENANT CONFIGURATION 
# ----------------------------------------

ForEach ($Tenant in $Tenants) {

$TenantOU = "OU=$Tenant,OU=Tenants,$RootOU"
$TenantGroupOU = "OU=Groups,$TenantOU"
$TenantUserOU = "OU=Users,$TenantOU"

Write-Host "Creating $Tenant OU" -ForegroundColor Yellow

New-ADOrganizationalUnit $Tenant -path "OU=Tenants,$RootOU"
Set-ADOrganizationalUnit -Identity $TenantOU -ProtectedFromAccidentalDeletion $false

Write-Host "Creating Default OUs within $Tenant" -ForegroundColor Yellow

New-ADOrganizationalUnit "Groups" -path $TenantOU
Set-ADOrganizationalUnit -Identity $TenantGroupOU -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit "Users" -path $TenantOU
Set-ADOrganizationalUnit -Identity $TenantUserOU -ProtectedFromAccidentalDeletion $false

Write-Host "Creating AD Global Groups within $Tenant"  -ForegroundColor Yellow

New-ADGroup -Name "GG_VRA_${Tenant}_TenantAdmins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Automation Tenant Administrators"
New-ADGroup -Name "GG_VRA_${Tenant}_InfrastructureAdmins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Automation Infrastructure Admins"
New-ADGroup -Name "GG_VRA_${Tenant}_FabricAdmins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Fabric Administrators"
New-ADGroup -Name "GG_VRA_${Tenant}_ServiceArchitects" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Automation Service Architects"
New-ADGroup -Name "GG_VRA_${Tenant}_BusinessGroupMgrs" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Automation Business Group Managers"
New-ADGroup -Name "GG_VRA_${Tenant}_ApprovalAdmins" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Automation Approval Administrators"
New-ADGroup -Name "GG_VRA_${Tenant}_SupportUsers" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Automation Support Users"
New-ADGroup -Name "GG_VRA_${Tenant}_BusinessUsers" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Automation Users"
New-ADGroup -Name "GG_VRA_${Tenant}_Approvers" -GroupCategory Security -GroupScope Global -Path "OU=Groups,$TenantOU" -Description "Global Group for $Tenant - VMware vRealize Automation Approvers"



Write-Host "Adding GG_VRA_TenantAdmins Group to GG_VRA_${Tenant}_TenantAdmins"  -ForegroundColor Green
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_TenantAdmins" "GG_VRA_TenantAdmins"
Write-Host "Adding GG_VRA_ApprovalAdmins Group to GG_VRA_${Tenant}_ApprovalAdmins"  -ForegroundColor Green
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_ApprovalAdmins" "GG_VRA_ApprovalAdmins"
Write-Host "Adding GG_VRA_ServiceArchitects Group to GG_VRA_${Tenant}_ServiceArchitects"  -ForegroundColor Green
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_ServiceArchitects" "GG_VRA_ServiceArchitects"
Write-Host "Adding GG_VRA_BusinessGroupMgrs Group to GG_VRA_${Tenant}_BusinessGroupMgrs"  -ForegroundColor Green
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_BusinessGroupMgrs" "GG_VRA_BusinessGroupMgrs"
Write-Host "Adding GG_VRA_InfrastructureAdmins Group to GG_VRA_${Tenant}_InfrastructureAdmins"  -ForegroundColor Green
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_InfrastructureAdmins" "GG_VRA_InfrastructureAdmins"

Add-ADGroupMember -Identity "GG_VRA_${Tenant}_TenantAdmins" "Tenant.Admin"
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_InfrastructureAdmins" "Infra.Admin"
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_ApprovalAdmins" "Approval.Admin"
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_BusinessGroupMgrs" "Business.Manager"
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_ServiceArchitects" "Service.Architect"



New-ADUser -Name "${Tenant}.TenantAdmin" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.TenantAdmin" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_TenantAdmins" "${Tenant}.TenantAdmin"
New-ADUser -Name "${Tenant}.InfraAdmin" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.InfraAdmin" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_InfrastructureAdmins" "${Tenant}.InfraAdmin"
New-ADUser -Name "${Tenant}.FabricAdmin" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.FabricAdmin" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_FabricAdmins" "${Tenant}.FabricAdmin"
New-ADUser -Name "${Tenant}.Approval" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.Approval" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_ApprovalAdmins" "${Tenant}.Approval"
New-ADUser -Name "${Tenant}.BGManager" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.BGManager" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_BusinessGroupMgrs" "${Tenant}.BGManager"
New-ADUser -Name "${Tenant}.Architect" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.Architect" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_ServiceArchitects" "${Tenant}.Architect"
New-ADUser -Name "${Tenant}.Approver" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.Approver" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_Approvers" "${Tenant}.Approver"
New-ADUser -Name "${Tenant}.SupportUser" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.SupportUser" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
Add-ADGroupMember -Identity "GG_VRA_${Tenant}_SupportUsers" "${Tenant}.SupportUser"

$n=0

Do
    {
	$n++
	New-ADUser -Name "${Tenant}.User0$n" -AccountPassword $DefaultPassword -DisplayName "${Tenant}.User0$n" -Path $TenantUserOU -PasswordNeverExpires $true -Enabled $true -PassThru
	Add-ADGroupMember -Identity "GG_VRA_${Tenant}_BusinessUsers" "${Tenant}.User0$n"
	
    } until ($n -eq 5)

}

# ----------------------------------------
# 	  END AD TENANT CONFIGURATION 
# ----------------------------------------

$temp = Get-AdUser "Administrator"
If ($temp) {
	
	Write-Host "Renaming Administrator Account."  -ForegroundColor Yellow
	
	Get-Aduser "Administrator" | Set-ADUser -samAccountName "Domain.Admin" -DisplayName "Domain.Admin"
	
	Rename-ADObject "CN=Administrator,CN=Users,DC=thecloudxpert,DC=local" -NewName "Domain.Admin"
	
	Add-ADGroupMember -Identity "GG_SQL_Admins" "Domain.Admin"
	Add-ADGroupMember -Identity "GG_VRO_Admins" "Domain.Admin"
	
	Write-Host "Creating New dummy Administrator Account."  -ForegroundColor Yellow
	
	New-ADUser -Name "Administrator" -AccountPassword $DefaultPassword -DisplayName "Administrator" -Path "CN=Users,DC=thecloudxpert,DC=local" -PasswordNeverExpires $true -Enabled $false -PassThru
	
	} else {
	
	Write-Host "Administrator Account has already been renamed."  -ForegroundColor Yellow
	
}


# ----------------------------------------
# 	  END AD CONFIGURATION 
# ----------------------------------------