<#
.SYNOPSIS
Simple file hash checker

.DESCRIPTION
Simple filehash checker
#>

$userDownloadFolder = Get-ItemPropertyValue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\' -Name '{374DE290-123F-4565-9164-39C4925E467B}'
$icon = ""


Write-Host "simple-hash-checker started" -BackgroundColor "Green"
Write-Host "User download directory is $userDownloadFolder" 
### Watch for new files in Downloads directory
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $userDownloadFolder
$watcher.Filter = "*.*" # What if no extension?
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

### Action to  run when file download is triggered
$action = {
    $path = $Event.SourceEventArgs.Fullpath
    $changeType = $Event.SourceEventArgs.$ChangeType
    Write-Host "$changeType"
    if ($changeType.HasMoreData -eq $true) {
        return 
    }
    
    # Notification icon
    $notifyicon = New-Object System.Windows.Forms.NotifyIcon
    $notifyicon.Text = "Simple filehash checker"
    $notifyicon.Icon = $icon
    $notifyicon.Visible = $true
    $menuitem = New-Object System.Windows.Forms.MenuItem
    $menuitem.Text = "Close"
    
    $contextmenu = New-Object System.Windows.Forms.ContextMenu
    
    $notifyicon.ContextMenu = $contextmenu
    $notifyicon.contextMenu.MenuItems.AddRange($menuitem)
    
    $logline = "$(Get-Date), $changeType, $path"
    Write-Host $logline

    $md5 = Get-FileHash -path $path -Algorithm MD5
    $sha256 = Get-FileHash -path $path -Algorithm SHA256  

    ./loadDialog.ps1 -XamlPath '..\forms\notificationWindow.xaml'
    
    $xamGUI.ShowDialog() | out-null

}

### Which events will be watched
Register-ObjectEvent $watcher "Created" -Action $action



while ($true) {Start-Sleep 5}





Write-Host "simple-hash-checker exited" -BackgroundColor "Green"
