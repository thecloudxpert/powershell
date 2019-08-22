#Cloud Automation Services

$role = Read-Host -Prompt "Enter the name for the CAS Role"
$vcenter = Read-Host -Prompt "Enter the FQDN of the vCenter Server"
$sso_user = Read-Host -Prompt "Enter the SSO Admin User"
$sso_password = Read-Host -assecurestring -Prompt "Enter the SSO Admin Password"
$cas_user = Read-Host -Prompt "Enter the name of the VRA User (<domain>\<user>)"

$CAS_Privileges = @(
	# DataStore
	"Datastore.AllocateSpace", 
	"Datastore.Browse",
	# DataStore Cluster
	"StoragePod.Config",
	# Folder
	"Folder.Create",
	"Folder.Delete",
	# Global
	"Global.ManageCustomFields",
	"Global.SetCustomField",
	# Network
	"Network.Assign",
	# Permissions
	"Authorization.ModifyPermissions",
	# Resouces
	"Resource.AssignVMToPool",
	"Resource.HotMigrate",
	"Resource.ColdMigrate",
	# Content Library
	"ContentLibrary.AddLibraryItem",
	"ContentLibrary.CreateLocalLibrary",
	"ContentLibrary.CreateSubscribedLibrary",
	"ContentLibrary.DeleteLibraryItem",
	"ContentLibrary.DeleteLocalLibrary",
	"ContentLibrary.DeleteSubscribedLibrary",
	"ContentLibrary.DownloadSession",
	"ContentLibrary.EvictLibraryItem",
	"ContentLibrary.EvictSubscribedLibrary",
	"ContentLibrary.ProbeSubscription",
	"ContentLibrary.ReadStorage",
	"ContentLibrary.SyncLibraryItem",
	"ContentLibrary.SyncLibrary",
	"ContentLibrary.GetConfiguration",
	"ContentLibrary.TypeIntrospection",
	"ContentLibrary.UpdateSession",
	"ContentLibrary.UpdateLibrary",
	"ContentLibrary.UpdateLibraryItem",
	"ContentLibrary.UpdateLocalLibrary",
	"ContentLibrary.UpdateSubscribedLibrary",
	"ContentLibrary.UpdateConfiguration",
	# Tagging
	"InventoryService.Tagging.AttachTag",
	"InventoryService.Tagging.CreateCategory",
	"InventoryService.Tagging.CreateTag",
	"InventoryService.Tagging.DeleteCategory",
	"InventoryService.Tagging.DeleteTag",
	"InventoryService.Tagging.EditCategory",
	"InventoryService.Tagging.EditTag",
	"InventoryService.Tagging.ModifyUsedByForCategory",
	"InventoryService.Tagging.ModifyUsedByForTag",
	# Virtual Machine - Interact
	"VirtualMachine.Inventory.CreateFromExisting",
	"VirtualMachine.Inventory.Create",
	"VirtualMachine.Inventory.Move",
	"VirtualMachine.Inventory.Delete",
	"VirtualMachine.Interact.SetCDMedia",
	"VirtualMachine.Interact.ConsoleInteract",
	"VirtualMachine.Interact.DeviceConnection", 
	"VirtualMachine.Interact.PowerOff",
	"VirtualMachine.Interact.PowerOn",
	"VirtualMachine.Interact.Reset",
	"VirtualMachine.Interact.Suspend",
	"VirtualMachine.Interact.ToolsInstall",
	# Virtual Machine - Config
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
	# Virtual Machine - Provisioning
	"VirtualMachine.Provisioning.Customize",
	"VirtualMachine.Provisioning.CloneTemplate",
	"VirtualMachine.Provisioning.Clone",
	"VirtualMachine.Provisioning.DeployTemplate",
	"VirtualMachine.Provisioning.ReadCustSpecs",
	# Virtual Machine - State
	"VirtualMachine.State.CreateSnapshot",
	"VirtualMachine.State.RevertToSnapshot",
	"VirtualMachine.State.RemoveSnapshot"
	)

Function ConnectToVI ([string]$Name, [string]$User, [EncryptedString]$Password)
{
	
	$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password 

	Do {
		Start-Sleep -s 5
		$Con = Connect-VIServer $Name -Credential $Credential -Force -ErrorAction SilentlyContinue
	} Until ($Con.IsConnected -eq $True)
	
	Write-Host "Connected to $Name" -ForeGroundColor Magenta
}

Write-Host "Connecting to $vCenter" -ForeGroundColor Yellow
ConnectToVI $vCenter $sso_user $sso_password

Write-Host "Create New $role Role" -ForeGroundColor Yellow

New-VIRole -Name $role -Privilege (Get-VIPrivilege -id $CAS_Privileges) | Out-Null

Write-Host "Set Permissions for $cas_user using the new $role Role" -ForeGroundColor Yellow
$rootFolder = Get-Folder -NoRecursion
New-VIPermission -entity $rootFolder -Principal $cas_user -Role $role -Propagate:$true | Out-Null

Write-Host "Disconnecting from vCenter at $vCenter" -ForeGroundColor Yellow
Disconnect-VIServer $vCenter -Confirm:$false
