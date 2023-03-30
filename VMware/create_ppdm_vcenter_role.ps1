Import-Module VMware.PowerCLI

#if cert warning: Set-PowerCLIConfiguration -Scope User -InvalidCertificateAction warn

$vCenter = Read-host -Prompt "Enter vCenter Server instance"
$vc_creds = Get-Credential -Message "Credentials for vCenter Login"

$vc = Connect-VIServer -Server $vCenter -Credential $vc_creds

$privileges = @(
'System.Anonymous',
'System.View',
'System.Read',
'Alarm.Create',
'Alarm.Edit',
'Cryptographer.AddDisk',
'Cryptographer.Access',
'Cryptographer.Encrypt',
'Cryptographer.Migrate',
'Cryptographer.RegisterVM',
'Datastore.Rename',
'Datastore.Move',
'Datastore.Delete',
'Datastore.Browse',
'Datastore.DeleteFile',
'Datastore.FileManagement',
'Datastore.AllocateSpace',
'Datastore.Config',
'Extension.Register',
'Extension.Unregister',
'Extension.Update',
'Folder.Create',
'Global.ManageCustomFields',
'Global.SetCustomField',
'Global.LogEvent',
'Global.CancelTask',
'Global.Licenses',
'Global.Settings',
'Global.DisableMethods',
'Global.EnableMethods',
'Host.Config.Storage',
'Host.Config.Patch',
'Host.Config.Image',
'Host.Config.NetService',
'vSphereDataProtection.Protection',
'vSphereDataProtection.Recovery',
'InventoryService.Tagging.AttachTag',
'InventoryService.Tagging.ObjectAttachable',
'InventoryService.Tagging.CreateTag',
'InventoryService.Tagging.CreateCategory',
'Network.Config',
'Network.Assign',
'Resource.AssignVMToPool',
'Resource.HotMigrate',
'Resource.ColdMigrate',
'Sessions.ValidateSession',
'StorageProfile.Update',
'StorageProfile.View',
'Task.Create',
'Task.Update',
'VApp.ApplicationConfig',
'VApp.Export',
'VApp.Import',
'VirtualMachine.Config.Rename',
'VirtualMachine.Config.Annotation',
'VirtualMachine.Config.AddExistingDisk',
'VirtualMachine.Config.AddNewDisk',
'VirtualMachine.Config.RemoveDisk',
'VirtualMachine.Config.RawDevice',
'VirtualMachine.Config.HostUSBDevice',
'VirtualMachine.Config.CPUCount',
'VirtualMachine.Config.Memory',
'VirtualMachine.Config.AddRemoveDevice',
'VirtualMachine.Config.EditDevice',
'VirtualMachine.Config.Settings',
'VirtualMachine.Config.Resource',
'VirtualMachine.Config.UpgradeVirtualHardware',
'VirtualMachine.Config.ResetGuestInfo',
'VirtualMachine.Config.AdvancedConfig',
'VirtualMachine.Config.DiskLease',
'VirtualMachine.Config.SwapPlacement',
'VirtualMachine.Config.DiskExtend',
'VirtualMachine.Config.ChangeTracking',
'VirtualMachine.Config.ReloadFromPath',
'VirtualMachine.Config.ManagedBy',
'VirtualMachine.GuestOperations.Query',
'VirtualMachine.GuestOperations.Modify',
'VirtualMachine.GuestOperations.Execute',
'VirtualMachine.Interact.PowerOn',
'VirtualMachine.Interact.PowerOff',
'VirtualMachine.Interact.Reset',
'VirtualMachine.Interact.ConsoleInteract',
'VirtualMachine.Interact.DeviceConnection',
'VirtualMachine.Interact.SetCDMedia',
'VirtualMachine.Interact.ToolsInstall',
'VirtualMachine.Interact.GuestControl',
'VirtualMachine.Inventory.Create',
'VirtualMachine.Inventory.Register',
'VirtualMachine.Inventory.Delete',
'VirtualMachine.Inventory.Unregister',
'VirtualMachine.Provisioning.DiskRandomAccess',
'VirtualMachine.Provisioning.DiskRandomRead',
'VirtualMachine.Provisioning.GetVmFiles',
'VirtualMachine.Provisioning.MarkAsTemplate',
'VirtualMachine.State.CreateSnapshot',
'VirtualMachine.State.RevertToSnapshot',
'VirtualMachine.State.RemoveSnapshot')

New-VIRole -Name 'PowerProtect' 
-Privilege (Get-VIPrivilege -Id $privileges)

Disconnect-viserver $vc