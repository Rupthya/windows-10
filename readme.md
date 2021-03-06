# Windows 10
Installation and configuration instructions for Windows 10 Creators Update (Version 1803).

Set the BIOS date two days in the past before installing and correct it after time and time zone selection.

## Installation
Download the latest [Windows 10](https://www.microsoft.com/en-us/software-download/windows10) image and create a USB stick.

Create the file `\sources\ei.cfg` on the USB stick.

```ini
[EditionID]
Professional
[Channel]
Retail
[VL]
0
```

Create the file `\sources\pid.txt` on the USB stick.

```ini
[PID]
Value={windows key}
```

Keep the system disconnected from the network during the following steps.

## Hostname
Change the hostname.

```
Settings > System > About > Rename PC
```

Reboot the system.

Open a new PowerShell window with administrator privileges to change the NetBIOS name.

```cmd
$MethodDefinition = @'
[DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
public static extern bool SetComputerName(string name);
'@
$Kernel32 = Add-Type -MemberDefinition $MethodDefinition -Name 'Kernel32' -Namespace 'Win32' -PassThru
$Kernel32::SetComputerName("{hostname}");
```

Reboot the system.

## Settings
Use common sense in **Settings**, **Explorer Options** and **Indexing Optinos**.

Disable Windows 10 full screen "Updates are available" notification.

```cmd
cd /d "%windir%\System32"
takeown /F MusNotification.exe
icacls MusNotification.exe /deny Everyone:(X)
takeown /F MusNotificationUx.exe
icacls MusNotificationUx.exe /deny Everyone:(X)
```

## Apps
Disable Cortana and Consumer Apps.

```cmd
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
```

Repeat as a normal user.

Configure and hide Cortana using the search box in the taskbar, then disable her.

```cmd
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
```

Uninstall unwanted apps in PowerShell. Do not copy & paste everything.

```ps
get-appxpackage *onenote* | remove-appxpackage
get-appxpackage *3dbuilder* | remove-appxpackage
get-appxpackage *officehub* | remove-appxpackage
get-appxpackage *skypeapp* | remove-appxpackage
get-appxpackage *getstarted* | remove-appxpackage
get-appxpackage *bingnews* | remove-appxpackage
get-appxpackage *bingfinance* | remove-appxpackage
get-appxpackage *bingsports* | remove-appxpackage
get-appxpackage *windowscamera* | remove-appxpackage
get-appxpackage *windowsmaps* | remove-appxpackage
get-appxpackage *windowsphone* | remove-appxpackage
get-appxpackage *windowsalarms* | remove-appxpackage
get-appxpackage *zunemusic* | remove-appxpackage
get-appxpackage *zunevideo* | remove-appxpackage
get-appxpackage *xboxapp* | remove-appxpackage
get-appxpackage *people* | remove-appxpackage
get-appxpackage *soundrecorder* | remove-appxpackage
get-appxpackage *solitairecollection* | remove-appxpackage
get-appxpackage *Microsoft.XboxIdentityProvider* | remove-appxpackage
get-appxpackage *Microsoft.XboxSpeechToTextOverlay* | remove-appxpackage
get-appxpackage *Microsoft.Xbox* | remove-appxpackage
get-appxpackage *Microsoft.MicrosoftStickyNotes* | remove-appxpackage
get-appxpackage *Microsoft.Microsoft3DViewer* | remove-appxpackage
get-appxpackage *Microsoft.GetHelp* | remove-appxpackage
get-appxpackage *Microsoft.Messaging* | remove-appxpackage
```

List apps and remove even more manually.

```ps
get-appxpackage | select Name,PackageFullName | sort Name
```

See also: <https://github.com/stefansundin/dotfiles/blob/master/setup-windows.md>

## Group Policy
Configure group policies (skip unwanted steps).

```
gpedit.msc > Computer Configuration > Administrative Templates > Control Panel

Personalization
+ Do not display the lock screen: Enabled

gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Cloud Content
+ Turn off Microsoft consumer experiences: Enabled

Data Collection and Preview Builds
+ Allow Telemetry: Disabled
+ Do not show feedback notifications: Enabled

OneDrive
+ Save documents to OneDrive by default: Disabled
+ Prevent the usage of OneDrive for file storage: Enabled
+ Prevent the usage of OneDrive for file storage on Windows 8.1: Enabled

Search
+ Allow Cortana: Disabled
+ Allow Cortana above lock screen: Disabled
+ Do not allow web search: Enabled
+ Don't search the web or display web results in Search: Enabled

Speech
+ Allow Automatic Update of Speech Data: Disabled

Windows Defender Antivirus
+ Turn off Windows Defender Antivirus: Enabled

Windows Defender Antivirus > MAPS
+ Join Microsoft MAPS: Disabled

Windows Defender Antivirus > Network Inspection System
+ Turn on definition retirement: Disabled
+ Turn on protocol recognition: Disabled

Windows Defender Antivirus > Real-time Protection
+ Turn off real-time protection: Enabled

Windows Defender Antivirus > Signature Updates
+ Allow definition updates from Microsoft Update: Disabled

Windows Defender SmartScreen > Explorer
+ Configure Windows Defender SmartScreen: Disabled

Windows Defender SmartScreen > Microsoft Edge
+ Configure Windows Defender SmartScreen: Disabled

Windows Error Reporting
+ Disable Windows Error Reporting: Enabled

Windows Update
+ Configure Automatic Updates: Enabled
  Configure automatic updating: 2 - Notify for download and auto install
  [✓] Install updates for other Microsoft products
```

## Disk Optimizations
Verify that TRIM support is enabled. The following command should return `NTFS DisableDeleteNotify = 0`.

```cmd
fsutil behavior query disabledeletenotify
```

Disable hibernation (not recommended for mobile computers).

```cmd
powercfg -h off
```

## Services
Delete diagnostics services.

```cmd
sc delete diagtrack
sc delete dmwappushservice
```

Disable unwanted services (ignore if missing).

```
services.msc
+ Certificate Propagation: Manual -> Disabled
+ Microsoft (R) Diagnostics Hub Standard Collector Service: Manual -> Disabled
+ Microsoft Office Click-to-Run Service: Automatic -> Disabled
+ Superfetch: Automatic -> Disabled
+ Windows Biometric Service: Manual -> Disabled
+ Windows Mobile-2003-based device connectivity: Log on as "Local System account"
+ Xbox Accessory Management Service: Manual -> Disabled
+ Xbox Live …: Manual -> Disabled
```

## Tasks
Disable Application Experience tasks.

```
Task Scheduler > Task Scheduler Library > Microsoft > Windows > Application Experience
+ Microsoft Compatibility Appraiser: Disabled
+ ProgramDataUpdater: Disabled
```

## Drivers & Updates
Disable automatic driver application installation.

```
Control Panel > "System" > Advanced system settings > Hardware > Device Installation Settings
(·) No (your device might not work as expected)
```

## User Name
Change the full user name.

```cmd
lusrmgr.msc > Users > {user}
+ Full Name: {User Name}
```

Reboot the system.

## Updates
Connect to the Internet and install Windows updates.

Reboot the system.

## Startup
Disable automatically started applications.

```
Task Manager > Startup
+ Microsoft OneDrive: Disabled
+ Windows Defender notification icon: Disabled
```

## Notifications
Disable unwanted notifications.

```
Control Panel > System and Security > Security and Maintenance
  [Turn off all messages about …]
```

## Windows Libraries
Move unwanted Windows libraries.

1. Right click on `%UserProfile%\Pictures\Camera Roll` and select `Properties`.<br/>
   Select the `Location` tab and set it to `%AppData%\Camera Roll`.
2. Right click on `%UserProfile%\Pictures\Saved Pictures` and select `Properties`.<br/>
   Select the `Location` tab and set it to `%AppData%\Saved Pictures`.
3. Right click on `%UserProfile%\Videos\Captures` and select `Properties`.<br/>
   Select the `Location` tab and set it to `%AppData%\Captures`.

Hide unwanted "This PC" links.

```cmd
rem 3D Objects
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f

rem Desktop
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f

rem Documents
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f

rem Downloads
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f

rem Music
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f

rem Pictures
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f

rem Videos
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
```

Remove "Edit with Paint 3D" on right click.

```cmd
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\3D Edit" /f
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\3D Edit" /f
```

Hide unwanted "Explorer" links.

```cmd
rem OneDrive
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
```

## Firewall
Disable all rules in Windows Firewall keeping the following entries.

```
wf.msc
+ Inbound Rules
  + Connect
  + Core Networking - …
  + Delivery Optimization (…)
  + Hyper-V …
  + Network Discovery (…)
  + Remote Desktop - …
+ Outbound Rules
  + Connect
  + Core Networking - …
  + Hyper-V …
  + Network Discovery (…)
```

Enable inbound rules for "Remomte Desktop - …" if necessary.

Enable inbound rules for "File and Printer Sharing (Echo Request …)". Modify "Private,Public"
rules for inbound and outbound IPv4 and IPv6 Echo Requests and select "Any IP address" under
"Remote IP address" in the "Scope" tab.

To enable the WSL SSH Server, you need to replace the "SSH Server Proxy Service" inbound rule
with a new inbound rule for port 22.

## Keymap
Use this [keymap](keymap.zip) to input German characters on a U.S. keyboard.

## Microsoft Software
Uninstall unwanted applications in `Settings > Apps`.<br/>
Uninstall unwanted optional features in `Settings > Apps > Manage optional features`.

Configure [Microsoft Edge](https://en.wikipedia.org/wiki/Microsoft_Edge) after visiting <https://www.google.com/ncr>.

```
Settings
Open Microsoft Edge with: A specific page or pages
  about:blank
Open Microsoft Edge with: Previous pages
Open new tabs with: A blank page
[View advanced settings]
  Show the home button: Off
  Use Adobe Flas Player: Off
  Open sites in apps: Off
  Ask me what to do with each download: Off
  [Change search engine]
    Select: Google Search (discovered)
    [Set as default]
  Show search and site suggestions as I type: Off
  Let sites save protected media licenses on my device: Off
  Use page prediction to speed up browsing, …: Off
```

Configure [Internet Explorer](https://en.wikipedia.org/wiki/Internet_Explorer).

```
Internet options > General
Home page: about:blank
Startup: Start with tabs from the last session
```

Configure the Photos app.

```
Photos > Settings
Linked duplicates: Off
People: Off
Mouse wheel: Zoom in and out
```

Configure [Outlook 2016](https://products.office.com/en/outlook).

```cmd
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Setup" /v "DisableOffice365SimplifiedAccountCreation" /t REG_DWORD /d 1 /f
```

## Windows Features
Enable or disable Windows features.

```
Control Panel > Programs > Turn Windows features on or off
[■] .NET Framework 3.5 (includes .NET 2.0 and 3.0)
[✓] Windows Subsystem for Linux
```

Reboot the system.

Install a WSL distro from <https://aka.ms/wslstore>.

## Fonts
Install useful fonts.

* [DejaVu & DejaVu LGC](https://sourceforge.net/projects/dejavu/files/dejavu)
* [DejaVu Sans Mono from Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
* [Iconsolata](http://www.levien.com/type/myfonts/inconsolata.html)
* [IPA](http://ipafont.ipa.go.jp)

## Third Party
Install third party software.

* [7-Zip](http://www.7-zip.org)
* [ConEmu](https://conemu.github.io)
* [Affinity Photo](https://affinity.serif.com/photo)
* [Affinity Designer](https://affinity.serif.com/designer)
* [Sketchbook Pro](http://www.autodesk.com/products/sketchbook-pro/overview)
* [Sublime Text 3](https://www.sublimetext.com/)
* [gVim](http://www.vim.org)
* [Python 3](https://www.python.org/)
* [CMake](https://cmake.org)
* [NASM](http://www.nasm.us)
* [HxD](https://mh-nexus.de/en/hxd)
* [CFF Explorer](http://www.ntcore.com/exsuite.php)
* [Resource Hacker](http://www.angusj.com/resourcehacker)
* [Sysinternals Suite](https://technet.microsoft.com/en-us/sysinternals/bb842062.aspx)

Configure Sublime Text 3 after installing the [Visual Studio Dark](https://packagecontrol.io/packages/Visual%20Studio%20Dark) theme.

```json
{
  "color_scheme": "Packages/Visual Studio Dark/Visual Studio Dark.tmTheme",
  "close_windows_when_empty": true,
  "ensure_newline_at_eof_on_save": true,
  "font_face": "DejaVu LGC Sans Mono",
  "font_size": 9,
  "hot_exit": false,
  "ignored_packages": [ "Markdown", "Vintage" ],
  "open_files_in_new_window": false,
  "rulers": [ 120 ],
  "show_definitions": false,
  "tab_size": 2,
  "theme": "Default.sublime-theme",
  "translate_tabs_to_spaces": true,
  "caret_extra_bottom": 1,
  "caret_extra_top": 1,
  "caret_extra_width": 1
}
```

Configure [Sublime Text 3 MarkdownEditing GFM Settings](https://packagecontrol.io/packages/MarkdownEditing) (optional).

```json
{
  "color_scheme": "Packages/Visual Studio Dark/Visual Studio Dark.tmTheme",
  "trim_trailing_white_space_on_save": true,
  "draw_centered": false,
  "line_numbers": true,
  "word_wrap": false,
  "rulers": [ 120 ],
  "tab_size": 2
}
```

## Server
Install software for Windows Server administration.

<!--
Possible future replacement for the SSMS link:
https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms
-->

* [SQL Server Management Studio](https://msdn.microsoft.com/en-us/library/mt238290.aspx)
* [Remote Server Administration Tools for Windows 10](https://www.microsoft.com/en-us/download/details.aspx?id=45520)

Configure the WinRM client.

```cmd
Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex {InterfaceIndex} -NetworkCategory Private
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
```

*See comments in this readme file for Windows Server configuration.*

<!--
Configure the WinRM server.

```ps
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
```

Configure the WinRM server to accept HTTPS connections.

```ps
winrm enumerate winrm/config/listener
New-SelfSignedCertificate -DnsName "{DomainName}" -CertStoreLocation Cert:\LocalMachine\My
cmd /C 'winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="{DomainName}"; CertificateThumbprint="{Thumbprint}"}'
netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986
```

Connect over HTTP.

```ps
Enter-PSSession -ComputerName host.domain -Port 5985 -Credential administrator@domain
```

Connect over HTTPS.

```ps
$soptions = New-PSSessionOption -SkipCACheck
Enter-PSSession -ComputerName host.domain -Port 5986 -Credential administrator@domain -SessionOption $soptions -UseSSL
```
-->

## Control Panel
Add Control Panel shortcuts to the Windows start menu (use icons from `C:\Windows\System32\shell32.dll`).

[Control Panel Command Line Commands](https://www.lifewire.com/command-line-commands-for-control-panel-applets-2626060)

## Anti-Virus
Suggested third party anti-virus exclusion lists.

```
Excluded Processes

%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\Common7\IDE\PerfWatson2.exe
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\Common7\IDE\VcxprojReader.exe
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.12.25827\bin\HostX86\x64\CL.exe
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\VC\Tools\MSVC\14.12.25827\bin\HostX86\x64\link.exe

Excluded Directories

%ProgramFiles(x86)%\Microsoft Visual Studio\
%ProgramFiles(x86)%\Windows Kits\
%UserProfile%\AppData\Local\lxss\
C:\Workspace\
```

## Windows Subsystem for Linux
<!--
Install [WSLtty](https://github.com/mintty/wsltty) for better terminal support.<br/>
Install [VcXsrv](https://github.com/ArcticaProject/vcxsrv/releases) for Xorg application support.
-->
Configure [sudo(8)](http://manpages.ubuntu.com/manpages/xenial/man8/sudo.8.html) with `sudo EDITOR=vim visudo`.

```sh
# Locale settings.
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"

# Profile settings.
Defaults env_keep += "MM_CHARSET EDITOR PAGER CLICOLOR LSCOLORS TMUX SESSION"

# User privilege specification.
root  ALL=(ALL) ALL
%sudo ALL=(ALL) NOPASSWD: ALL

# See sudoers(5) for more information on "#include" directives:
#includedir /etc/sudoers.d
```

Fix timezone information.

```sh
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo Europe/Berlin | sudo tee /etc/timezone
```

Add the following line to `/etc/mdadm/mdadm.conf` (fixes some `apt` warnings).

```sh
# definitions of existing MD arrays
ARRAY <ignore> devices=/dev/sda
```

Modify the following lines in `/etc/pam.d/login` (disables message of the day).

```sh
#session    optional    pam_motd.so motd=/run/motd.dynamic
#session    optional    pam_motd.so noupdate
```

Create `/etc/wsl.conf`.

```sh
[automount]
enabled=true
options=metadata,uid=1000,gid=1000,umask=022
```

Install packages.

```sh
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
sudo apt autoremove
sudo apt install apt-file p7zip p7zip-rar zip unzip tree htop pngcrush sysstat
sudo apt-file update
```

Take ownership of `/opt`.

```sh
USER=`id -un` GROUP=`id -gn` sudo chown $USER:$GROUP /opt
```

Install development packages.

```sh
sudo apt install build-essential binutils-dev gdb libedit-dev nasm python python-pip git subversion swig
```

Install CMake.

```sh
rm -rf /opt/cmake; mkdir /opt/cmake
wget https://cmake.org/files/v3.12/cmake-3.12.1-Linux-x86_64.tar.gz
tar xvf cmake-3.12.1-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
find /opt/cmake -type d -exec chmod 0755 '{}' ';'
```

Install Ninja.
```sh
git clone -b release https://github.com/ninja-build/ninja
cd ninja && ./configure.py --bootstrap && cp ninja /opt/cmake/bin/
```

Install NodeJS.

```sh
rm -rf /opt/node; mkdir /opt/node
wget https://nodejs.org/dist/v10.9.0/node-v10.9.0-linux-x64.tar.xz
tar xvf node-v10.9.0-linux-x64.tar.xz -C /opt/node --strip-components 1
find /opt/node -type d -exec chmod 0755 '{}' ';'
```

Consider using the [llvm](llvm.md) and [vcpkg](vcpkg.md) guides.

## Start Menu
![Start Menu](layout.png)

