
Param($Title = "Sjekk integritet på nedlastet fil", 
$Message = "Verifiser integriteten til nedlastet fil ved å velge hash type og lime inn hash fra nettstedet du lastet den ned fra",
$Filename = "Ny nedlastet fil",
$ActionHandlerScript = "$PSScriptRoot\handleActions.ps1"  
)
$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'

Function Show-NotificationToast{

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position=0)]
        [String]
        $Title,
        [Parameter(Mandatory, Position=1)]
        [string]
        $Message,
        [Parameter(Mandatory, Position=2)]
        [String]
        $Filename,
        [Parameter(Mandatory, Position=3)]
        [String]
        $ActionHandlerScript  
    )

    # Show notification when a file is downloaded
    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $null = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

    # Get xaml file and set the correct values for title, message and icon
    try{
        Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms
    } catch {
        Throw "Failed to load Windows Presentation Framework assemblies."
    }

    $ToastXmlString = @"   
<toast scenario="reminder" Launch="pwsh:">
<visual>
  <binding template="ToastGeneric">
    <text>$Title</text>
    <text>$Message</text>
    <text>$Filename</text>
    <image src="$Logo" placement="appLogoOverride" hint-crop="circle" />
  </binding>
</visual>
<actions>
    <input id="time" type="selection" defaultInput="MD5">
        <selection id="MD5" content="MD5" />
        <selection id="SHA256" content="SHA256" />
        <selection id="SHA512" content="SHA512" />
    </input>

    <input id="filehashInput" type="text" placeHolderContent="Paste the filehash here"/>
    <action
        content="verify filehash"
        arguments="pwsh:D:\Documents\simple-hash-checker\src\scripts\handleActions.ps1"
        activationType="protocol"/>

    <action activationType="system" arguments="dismiss" content=""/>
</actions>
<audio src="ms-winsoundevent:Notification.Default" />
</toast>
"@

# C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -File D:\Documents\simple-hash-checker\src\scripts\handleActions.ps1
    $ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
    $ToastXml.LoadXml(([xml]$ToastXmlString).OuterXml)
    $Toast = [Windows.UI.Notifications.ToastNotification]::new($ToastXml)
    $Toast.Tag = "Simple filehash checker"
    $Toast.ExpirationTime = [System.DateTimeOffset]::Now.AddMinutes(3)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($Toast)
    
}
  
Show-NotificationToast -Title $Title -Message $Message -Filename $Filename -ActionHandlerScript $ActionHandlerScript