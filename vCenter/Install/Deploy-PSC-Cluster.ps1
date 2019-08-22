# Deploy PSC ClLuster using vCSA-Deploy
# Convert JSON file to PowerShell object 
$ConfigLocation = "<location of custom JSON template files>"
$Installer = "<ISO>\vcsa-cli-installer\win32\vcsa-deploy.exe"
$UpdatedConfig = "<location>"
$domain = "<ad domain>"
$vCenterServer="<server>"
$vCenter_user = "<vCenter User>"
$vCenter_password = "<vCenter User password>"
$sso_domain= "<vCenter SSO domain>"
$sso_password="<password>"
$sso_site = "<sso site>"
$dnsserver = "<ip address>"
$ip_gateway = "<ip address>"
$datastore="<datastore>"
$psc_password="<PSC Root Password>"
$psc_primary="<primary server name>"
$psc_primary_ip="<ipaddress>"
$psc_secondary="<secondary server name>"
$psc_secondary_ip="<ip address>"
$vmFolder="<folder>/<folder>"
$cluster="<VM Cluster>"
$portgroup="<VM vDS or vSS portgroup>"
$vm_datacenter="<VMware Data Center>"
$ntp_server="<NTP Server IP address - comma separated>"

Function DeployVCSA ([string] $machine, [string] $ip_address, [string] $vCenter, [string] $role, [string] $primary ) {
	
	Write-Host "Configuring $machine" -ForegroundColor Yellow
	
	If (-Not (Test-Path $UpdatedConfig )) {New-Item -path $UpdatedConfig -ItemType Directory}
	
	$configfile = "$UpdatedConfig\$machine.json"
	
	Switch ($role) 
	{
		"primary" { $file = "$ConfigLocation\PSC_on_VC.json"; $install_type="infrastructure";}
		"replica" { $file = "$ConfigLocation\PSC_replication_on_VC.json"; $install_type="infrastructure";}
		
		Default {break}
	}

	Write-Host "Using $file as install template " -ForegroundColor Yellow
	$json = (Get-Content -Raw $file) | ConvertFrom-Json
		
	# vCenter Information
	$json."target.vcsa".vc.hostname = "$vCenter.$domain"
	$json."target.vcsa".vc.username = "$vCenter_user"
	$json."target.vcsa".vc.password = "$vCenter_password"
	$json."target.vcsa".vc.datacenter = "$vm_datacenter"
	$json."target.vcsa".vc.datastore = "$datastore"
	$json."target.vcsa".vc.target = "$cluster"
	$json."target.vcsa".vc."vm.folder" = "$vmfolder"
	
	# vCSA system information
	$json."target.vcsa".os.password = "$psc_password"
	$json."target.vcsa".os."ssh.enable" = $true
	
	if ([string]::IsNullOrEmpty($ntp_server))	
	{
		$json."target.vcsa".os."time.tools-sync" = $true
	} else {
		$json."target.vcsa".os."time.tools-sync" = $false
		$json."target.vcsa".os."ntp.servers"="$ntp_server"
	}
	
	# VCSA SSO information
	$json."target.vcsa".sso.password = "$sso_password"
	$json."target.vcsa".sso."site-name" = "$sso_site"
	$json."target.vcsa".sso."domain-name" = "$sso_domain"
	
	#VCSA Appliance Information
	$json."target.vcsa".appliance."deployment.option" = "$install_type"
	$json."target.vcsa".appliance."deployment.network" = "$portgroup"
	$json."target.vcsa".appliance.name = "$machine"
	$json."target.vcsa".appliance."thin.disk.mode" = $false
	
	# Networking
	$json."target.vcsa".network.hostname = "$machine.$domain"
	$json."target.vcsa".network.mode = "static"
	$json."target.vcsa".network.ip = "$ip_address"
	$json."target.vcsa".network."ip.family" = "ipv4"
	$json."target.vcsa".network.prefix = "24"
	$json."target.vcsa".network.gateway = "$ip_gateway"
	$json."target.vcsa".network."dns.servers"="$dnsserver"
	
	if ($role -eq "replica") {
		$json."target.vcsa".sso."first-instance" = $false
		$json."target.vcsa".sso."replication-partner-hostname" = "$primary.$domain"
	}
	
	$json | ConvertTo-Json | Set-Content -Path $configfile
	
	Write-host "Deploying $machine" -ForegroundColor Yellow
	
	Invoke-Expression "$installer $configfile --accept-eula --no-esx-ssl-verify"
	
	If (Test-Path $configfile) {Remove-Item -path $configfile}
}

#DeployVCSA <APPLIANCE NAME> <APPLIANCE IP> <TARGET VCENTER> <INSTALL TYPE> <REPLICA PARTNER - IF SECONDARY>

DeployVCSA $psc_primary $psc_primary_ip $vCenterServer "primary"
DeployVCSA $psc_secondary $psc_secondary_ip $vCenterServer "replica" $psc_primary
