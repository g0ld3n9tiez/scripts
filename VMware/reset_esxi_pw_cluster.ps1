$cred = Get-Credential -UserName "root" -Message "Enter new root Credentials";
$vmhost = Get-VMHost # Collect ESXi Hosts where to change the password
ForEach($vmhostItem IN $vmhost) {
    $esxcli = get-esxcli -vmhost $vmhostItem -v2; #ESXCLI 
    $arguments = $esxcli.system.account.set.CreateArgs(); # arguments for the function
    $arguments.id = $cred.UserName; # Set Username
    $arguments.password = $cred.GetNetworkCredential().Password; # Set Password
    $arguments.passwordconfirmation = $cred.GetNetworkCredential().Password; # Confirm Password
    $esxcli.system.account.set.Invoke($arguments); # Function is executed
}