<#
Script to install Cylance security on machines
Created: 8/24/18
Rev: 8/27/18
Jonathan Harris
GropuCCI LLC
#>

Set-StrictMode -Version Latest
#Checks to see if the path is there. If not it creates the folder to put the cylance installer.
$user = $env:Username 
#$path = "C:\Users\$user\temp\cylanceinstall"
$path = "C:\temp\cylanceinstall"
If (!(Test-Path $path)) {
    New-Item -ItemType Directory -Force -Path $path
}

$installer = "$path\cylance.msi"

#This commented out for now. This sets the edit permissions for the path to install download cylance there. 
<#$acl = Get-Acl -Path $path
$inherit = [System.Security.AccessControl.InheritanceFlags]"ObjectInherit",[System.Security.AccessControl.InheritanceFlags]"ContainerInherit"
$propagation = [System.Security.AccessControl.PropagationFlags]"None"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, "Modify",$inherit, $propagation, "Allow")
$acl.SetAccessRule($rule)
$acl | Set-Acl -Path $path#>

#For internal testing, but checking the download time for cylance.msi
$downloadTime = Measure-Command -Expression {
    $web = Invoke-WebRequest -Uri "https://gcc.syncedtool.com/1/files/share/407927/ClyanceSilent.msi/e3a5a98f139718" -OutFile $installer

}

$seconds = $downloadTime.TotalSeconds
$seconds = [Math]::Round($seconds, 1)
"This took $seconds`s to download."

$arguments = @(
    "/I"
    $installer
    "/qn"
    "/L*V"
    "$path\cylance.log"
)
Start-Process "msiexec.exe" -ArgumentList $arguments -Wait -NoNewWindow

Remove-Item $path -Force -Recurse
exit
