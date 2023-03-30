Import-Module VMware.PowerCLI

#Define Variables
$Role = "ReadOnly"
$RO_User_Creds = Get-Credential -Message "Credentials for the ReadOnly User"
$vCenter = Read-host -Prompt "Enter vCenter Server instance"
$vc_creds = Get-Credential -Message "Credentials for vCenter Login"

$vc = Connect-VIServer -Server $vCenter -Credential $vc_creds

#Define Cluster
$ClusterName = Read-Host -Prompt "Enter Cluster Name"
$hosts =  Get-Cluster $ClusterName -Server $vc | Get-VMHost -Server $vc

#Get Login Credentials for root
$esx_cred = Get-Credential -UserName root -Message "Password for root on ESXi in Cluster $ClusterName"

#Exit Lockdown Mode, Loop through ESXi to create RO-User 
($hosts | Get-View).ExitLockdownMode()

foreach ($vmhost in $hosts) {
	write-host "Connecting to $($vmhost.Name)..." -foregroundcolor "yellow"
    $esxi = Connect-VIServer -Server $vmhost.Name -Credential $esx_cred -NotDefault

    write-host "Creating User $($RO_User_Creds.GetNetworkCredential().Username) on: $($vmhost.Name)" -foregroundcolor "yellow"
    New-VMHostAccount -Server $esxi -Id ($RO_User_Creds.GetNetworkCredential().Username) -Password ($RO_User_Creds.GetNetworkCredential().Password) -Description "ReadOnly User for PRTG"

    Start-Sleep -Seconds 5

	write-host "Assigning $Role permissions to $($RO_User_Creds.GetNetworkCredential().Username)" -foregroundcolor "yellow"
    New-VIPermission -Server $esxi -Entity $vmhost.Name -Principal ($RO_User_Creds.GetNetworkCredential().Username) -Role $Role

    Disconnect-VIServer -confirm:$false -Server $esxi

    #Define Exception User
    $ExceptionUser=@(($RO_User_Creds.GetNetworkCredential().Username))

    #Create User Exception for Lockdown Mode
    #Lockdown Normal Mode
    write-host "Assigning $($RO_User_Creds.GetNetworkCredential().Username) as a Lockdown Mode Exception User" -foregroundcolor "yellow"
    $HostAccessManager = Get-View $vmhost.ExtensionData.ConfigManager.HostAccessManager -Server $vc
    $HostAccessManager.UpdateLockdownExceptions($ExceptionUser) 
    
    #Lockdown Strict Mode
    #$HostAccessManager = Get-View $vmHost.ExtensionData.ConfigManager.HostAccessManager
    #$HostAccessManager.ChangeLockdownMode("lockdownStrict")
    #$HostAccessManager.UpdateViewData()
	
}

#Enter Lockdown Mode again
($hosts | Get-View).EnterLockdownMode()
Disconnect-VIServer -Server $vc -confirm:$false