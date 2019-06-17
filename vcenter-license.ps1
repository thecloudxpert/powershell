$vCenterServer = 
$User = 
$Password = 
$License = 

$EncryptedPassword = ConvertTo-SecureString -String "$Password" -AsPlainText -Force
	
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $EncryptedPassword 

Disconnect-VIServer -confirm:$false -ErrorAction SilentlyContinue
Write-Host "Connecting to $vCenterServer"
$vCenter = Connect-VIServer -Server $vCenterServer -Credential $Credential

# ----------------------------------------
# 	  VCENTER LICENSE CONFIGURATION
# ----------------------------------------

$LicenseManager = get-view ($vCenter.ExtensionData.content.LicenseManager)
$LicenseManager.AddLicense($vLicense,$null)
$LicenseAssignmentManager = get-view ($LicenseManager.licenseAssignmentManager)
$LicenseAssignmentManager.UpdateAssignedLicense($vCenter.InstanceUuid,$License,$Null)
