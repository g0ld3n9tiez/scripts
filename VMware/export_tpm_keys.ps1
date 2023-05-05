Import-Module VMware.PowerCLI
# Change vCenter
Connect-VIServer vcenter

$VMHosts = get-vmhost | Sort-Object

foreach ($VMHost in $VMHosts) {
    $esxcli = Get-EsxCli -VMHost $VMHost
    try {
        $key = $esxcli.system.settings.encryption.recovery.list()
        Write-Host "$VMHost;$($key.RecoveryID);$($key.Key)"
    }

    catch {
        
    }
}