## BriefCatch
## Files Required:  BCMSSetupLM.msi, license-6858.key, lwp.cer
##
$Product = "BriefCatch"
$NewVersion = "2.5.22.0"
$CurrentFileToCheck = "C:\Program Files (x86)\BriefCatch\BriefCatch\BCMSWordAddIn.dll"
$InstallerProcess = "$env:systemroot\system32\msiexec.exe"
$InstallerFile = "C:\Windows\PBL\Installers\Custom\BCMSSetupLM.msi"
$InstallerLog = "C:\Windows\PBL\Logs\BriefCatch.log"
$Arguments = "/i `"$InstallerFile`" /norestart /qn /lv `"$InstallerLog`" LICENSESOURCE=`"C:\Windows\PBL\Installers\Custom\license-6858.key`""
$ExitFile = "C:\Program Files\BriefCatch\DoNotInstall.txt"
$ExitFile2 = "C:\Program Files (x86)\BriefCatch\DoNotInstall.txt"
If (Test-Path $ExitFile -PathType Leaf -ErrorAction SilentlyContinue)
   {$ExitFileExists = 1}
Else {If (Test-Path $ExitFile2 -PathType Leaf -ErrorAction SilentlyContinue)
         {$ExitFileExists = 1}
      Else {$ExitFileExists = 0}}
##
## Check Version of existing install
If (Test-Path $CurrentFileToCheck -PathType Leaf -ErrorAction SilentlyContinue)
   {$CurrentVersion = (Get-Item $CurrentFileToCheck).VersionInfo.FileVersion}
Else {$CurrentVersion = "00 - Not Installed"}
$InstallersLogFile = "C:\Windows\PBL\Logs\_CustomInstallersLog.txt"
##
##
##
## Write to Installers Log
Write-Output "----------------------------------------------" | Out-File -FilePath $InstallersLogFile -Append
Write-Output "$Product" | Out-File -FilePath $InstallersLogFile -Append
Write-Output "   Latest Version:        $NewVersion" | Out-File -FilePath $InstallersLogFile -Append
Write-Output "   Version at boot time:  $CurrentVersion" | Out-File -FilePath $InstallersLogFile -Append
##
##
##
## Exit if Exit File exists
If ($ExitFileExists -eq 1)
   {Write-Output "   Exit File Exists - Not Installing $Product" | Out-File -FilePath $InstallersLogFile -Append
	Exit}
##
## Exit if "NewVersion" is already installed
If ($CurrentVersion.PadLeft(15,'0') -eq $NewVersion.PadLeft(15,'0'))
   {Write-Output "   Already Installed" | Out-File -FilePath $InstallersLogFile -Append
	Exit}
##
## Exit if newer version is already installed
If ($CurrentVersion.PadLeft(15,'0') -gt $NewVersion.PadLeft(15,'0'))
   {Write-Output "   Newer Version Already Installed" | Out-File -FilePath $InstallersLogFile -Append
	Exit}
##
## Exit if Installer file is missing
If (-not(Test-Path $InstallerFile -PathType Leaf -ErrorAction SilentlyContinue))
   {Write-Output "   Installer File Not Found" | Out-File -FilePath $InstallersLogFile -Append
    Exit}
##
##
##
## Install
Start-Process -FilePath "$InstallerProcess" -ArgumentList $Arguments -Wait -NoNewWindow
If (Test-Path $CurrentFileToCheck -PathType Leaf -ErrorAction SilentlyContinue)
   {$CurrentVersion = (Get-Item $CurrentFileToCheck).VersionInfo.FileVersion}
Else {$CurrentVersion = "00 - Not Installed"}
Write-Output "   Version now installed: $CurrentVersion" | Out-File -FilePath $InstallersLogFile -Append
