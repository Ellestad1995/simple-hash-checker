<#
.SYNOPSIS
Presents the notification window

.DESCRIPTION

#>
./loadDialog.ps1 -XamlPath '..\forms\notificationWindow.xaml'

$xamGUI.ShowDialog() | out-null