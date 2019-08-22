#Automation

$role = "vRealize Automation User"
$vcenter = Read-Host -Prompt "Enter the FQDN of the vCenter Server"
$sso_user = Read-Host -Prompt "Enter the SSO Admin User"
$sso_password = Read-Host -assecurestring -Prompt "Enter the SSO Admin Password"
$vra_user = Read-Host -Prompt "Enter the name of the VRA User (<domain>\<user>)"

$vRA_Privileges = @(
	"Datastore.AllocateSpace", 
	"Datastore.Browse",
	"StoragePod.Config",
	"Folder.Create",
	"Folder.Delete",
	"Global.ManageCustomFields",
	"Global.SetCustomField",
	"Network.Assign",
	"Authorization.ModifyPermissions",
	"Resource.AssignVMToPool",
	"Resource.HotMigrate",
	"Resource.ColdMigrate",
	"VirtualMachine.Inventory.CreateFromExisting",
	"VirtualMachine.Inventory.Create",
	"VirtualMachine.Inventory.Delete",
	"VirtualMachine.Inventory.Move",
	"VirtualMachine.Interact.SetCDMedia",
	"VirtualMachine.Interact.PowerOn",
	"VirtualMachine.Interact.PowerOff",
	"VirtualMachine.Interact.ConsoleInteract",
	"VirtualMachine.Interact.Suspend",
	"VirtualMachine.Interact.Reset",
	"VirtualMachine.Interact.PowerOn",
	"VirtualMachine.Interact.ToolsInstall",
	"VirtualMachine.Interact.DeviceConnection", 
	"VirtualMachine.Config.AddExistingDisk",
	"VirtualMachine.Config.AddNewDisk",
	"VirtualMachine.Config.AddRemoveDevice",
	"VirtualMachine.Config.RemoveDisk",
	"VirtualMachine.Config.AdvancedConfig",
	"VirtualMachine.Config.CPUCount",
	"VirtualMachine.Config.Resource",
	"VirtualMachine.Config.DiskExtend",
	"VirtualMachine.Config.ChangeTracking",
	"VirtualMachine.Config.Memory",
	"VirtualMachine.Config.EditDevice",
	"VirtualMachine.Config.Rename",
	"VirtualMachine.Config.Annotation",
	"VirtualMachine.Config.Settings",
	"VirtualMachine.Config.SwapPlacement",
	"VirtualMachine.Provisioning.Customize",
	"VirtualMachine.Provisioning.CloneTemplate",
	"VirtualMachine.Provisioning.Clone",
	"VirtualMachine.Provisioning.DeployTemplate",
	"VirtualMachine.Provisioning.ReadCustSpecs",
	"VirtualMachine.State.CreateSnapshot",
	"VirtualMachine.State.RevertToSnapshot",
	"VirtualMachine.State.RemoveSnapshot"
	)

Function ConnectToVI ([string]$Name, [string]$User, [string]$Password)
{
	
	$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password 

	Do {
		Start-Sleep -s 5
		$Con = Connect-VIServer $Name -Credential $Credential -SaveCredentials -Force -ErrorAction SilentlyContinue
	} Until ($Con.IsConnected -eq $True)
	
	Write-Host "Connected to $Name" -ForeGroundColor Magenta
}

Write-Host "Connecting to $vCenter" -ForeGroundColor Yellow
ConnectToVI $vCenter $sso_user $sso_password

Write-Host "Create New $role Role" -ForeGroundColor Yellow

New-VIRole -Name $role -Privilege (Get-VIPrivilege -id $vRA_Privileges) | Out-Null

Write-Host "Set Permissions for $vRA_User using the new $Role Role" -ForeGroundColor Yellow
$rootFolder = Get-Folder -NoRecursion
New-VIPermission -entity $rootFolder -Principal $vra_user -Role $role -Propagate:$true | Out-Null

Write-Host "Disconnecting from vCenter at $vCenter" -ForeGroundColor Yellow
Disconnect-VIServer $vCenter -Confirm:$false
