# Windows 10
Installation and configuration instructions for Windows 10 Creators Update (Version 1703).

Set the BIOS date two days in the past before installing and correct it after time and time zone selection.

## Installation
Download the latest [Windows 10](https://www.microsoft.com/en-us/software-download/windows10ISO) image and create a USB stick.

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

## Cortana
Configure Cortana using the search box in the taskbar.

## Group Policy
Configure group policies (skip unwanted steps).

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Data Collection and Preview Builds
+ Allow Telemetry: Disabled

OneDrive
+ Prevent the usage of OneDrive for file storage: Enabled

Search
+ Do not allow web search: Enabled

Store
+ Turn off the Store application: Enabled

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

Windows Defender Application Guard
+ Turn On/Off Windows Defender Application Guard (WDAG): Disabled

Windows Defender SmartScreen > Explorer
+ Configure App Install Control: Disabled
+ Configure Windows Defender SmartScreen: Disabled

Windows Defender SmartScreen > Microsoft Edge
+ Configure Windows Defender SmartScreen: Disabled

Windows Error Reporting
+ Disable Windows Error Reporting: Enabled

Windows Update
+ Configure Automatic Updates: Enabled
  Configure automatic updating: 2 - Notify for download and auto install
```

## Disk Optimizations
Verify that TRIM support is enabled. The following command should return `NTFS DisableDeleteNotify = 0`.

```cmd
fsutil behavior query disabledeletenotify
```

Disable disk defragmentation.

```
dfrgui > Change Settings
[ ] Run no a schedule (recommended)
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

Disable unwanted services.

```
services.msc
+ Certificate Propagation: Manual -> Disabled
+ Geolocation Service: Manual -> Disabled
+ Microsoft (R) Diagnostics Hub Standard Collector Service: Manual -> Disabled
+ Superfetch: Automatic -> Disabled
+ Windows Biometric Service: Manual -> Disabled
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
Disable automatic driver app installation.

```
Control Panel > "System" > Advanced system settings > Hardware > Device Installation Settings
(·) No (your device might not work as expected)
```

Configure Windows Update options and sources.

```
Settings > Update & security > Advanced options
[✓] Give me updates for other Microsoft products when I update Windows.
[✓] Use my sign in info to automatically finish setting up my device after an update.
    <Chose how updates are delivered>
      Updates from more than one place: Off
```

Reboot the system.

Connect to the Internet.

Wait until the CPU/Network activity stops and there are no more entries under `Device Manager > Other devices`.

Reboot the system.

Install Windows updates.

Reboot the system.

## User Name
Change the full user name.

```cmd
lusrmgr.msc > Users > {user}
+ Full Name: {User Name}
```

<!--

https://www.lifewire.com/command-line-commands-for-control-panel-applets-2626060

-->

## Settings
Use common sense in **Settings**, **Explorer Options** and **Indexing Optinos**.

Uninstall unwanted apps except "App Installer" and "OneDrive".

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

1. Right click on `%UserProfile%\Pictures\Camera Roll` and select `Properties`.
2. Select the `Location` tab and enter a new location e.g. `%AppData%\Camera Roll`.
3. Right click on `%UserProfile%\Pictures\Saved Pictures` and select `Properties`.
4. Select the `Location` tab and enter a new location e.g. `%AppData%\Saved Pictures`.
5. Right click on `%UserProfile%\Videos\Captures` and select `Properties`.
6. Select the `Location` tab and enter a new location e.g. `%AppData%\Captures`.

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
Configure [Microsoft Edge](https://en.wikipedia.org/wiki/Microsoft_Edge) after visiting <https://www.google.com/ncr>.

```
Settings
Open Microsoft Edge with: A specific page or pages
  about:blank
Open Microsoft Edge with: Previous pages
Open new tabs with: A blank page
[View advanced settings]
  Use Adobe Flas Player: Off
  Open sites in apps: Off
  Ask me what to do with each download: Off
  Have Cortana assist me in Microsoft Edge: Off
  Show search and site suggestions as I type: Off
  Let sites save protected media licenses on my device: Off
  Use page prediction to speed up browsing, …: Off
  [Change search engine]
    Select: Google Search (discovered)
    [Set as default]
```

Configure [Internet Explorer](https://en.wikipedia.org/wiki/Internet_Explorer).

```
Internet options > General
Home page: about:blank
Startup: Start with tabs from the last session
```

Configure [Visual Studio Code](https://code.visualstudio.com) (optional).

```json
{
  "editor.fontFamily": "DejaVu LGC Sans Mono, Consolas, monospace",
  "editor.fontSize": 12,
  "editor.tabSize": 2,
  "editor.detectIndentation": false,
  "editor.roundedSelection": false,
  "editor.quickSuggestions": false,
  "editor.cursorBlinking": "phase",
  "editor.renderWhitespace": "none",
  "editor.renderControlCharacters": true,
  "editor.renderLineHighlight": "none",
  "editor.codeLens": false,
  "editor.folding": false,
  "editor.minimap.enabled": true,
  "editor.minimap.renderCharacters": true,
  "explorer.openEditors.visible": 0,
  "window.openFilesInNewWindow": "off",
  "files.trimTrailingWhitespace": true,
  "files.hotExit": "off",
  "files.eol": "\n"
}
```

Uninstall unwanted applications in `Settings > Apps`.<br/>
Uninstall unwanted optional features in `Settings > Apps > Manage optional features`.

Configure the Photos app (recommended).

```
Photos > Settings
Automatically enhance my photos: Off
Linked duplicates: Off
```

## Windows Features
Enable or disable Windows features.

```
Control Panel > Programs > Turn Windows features on or off
[■] .NET Framework 3.5 (includes .NET 2.0 and 3.0)
[ ] Media Features
[ ] SMB 1.0/CIFS File Sharing Support
[✓] Windows Subsystem for Linux
[ ] XPS Services
[ ] XPS Viewer
```

## Fonts
Install fonts.

* [DejaVu & DejaVu LGC](https://sourceforge.net/projects/dejavu/files/dejavu)
* [DejaVu Sans Mono from Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
* [Iconsolata](http://www.levien.com/type/myfonts/inconsolata.html)
* [IPA](http://ipafont.ipa.go.jp)

## Third Party
Install third party software.

* [7-Zip](http://www.7-zip.org)
* [NASM](http://www.nasm.us)
* [HxD](https://mh-nexus.de/en/hxd)
* [CFF Explorer](http://www.ntcore.com/exsuite.php)
* [Resource Hacker](http://www.angusj.com/resourcehacker)
* [Sysinternals Suite](https://technet.microsoft.com/en-us/sysinternals/bb842062.aspx)
* [TightVNC Viewer](http://www.tightvnc.com)
* [Affinity Photo](https://affinity.serif.com/photo)
* [Affinity Designer](https://affinity.serif.com/designer)
* [Sketchbook Pro](http://www.autodesk.com/products/sketchbook-pro/overview)
* [Blender](https://www.blender.org)
* [gVim](http://www.vim.org)

## Optional
Install optional software.

* [Skype](https://www.skype.com/en)
* [ConEmu](https://conemu.github.io)
* [WSLtty](https://github.com/mintty/wsltty)
* [SQL Server Management Studio](https://msdn.microsoft.com/en-us/library/mt238290.aspx)
* [Remote Server Administration Tools for Windows 10](https://www.microsoft.com/en-us/download/details.aspx?id=45520)
* [Google Drive](https://www.google.com/drive/download)

Configure WinRM client.

```cmd
Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex {Idx} -NetworkCategory Private
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
```

## Control Panel
Add Control Panel shortcuts to the Windows start menu. Use icons from `C:\Windows\System32\shell32.dll`.

### Network Connections
Create a shortcut to `control.exe ncpa.cpl` and save it as<br/>
`%AppData%\Microsoft\Windows\Start Menu\Programs\Network Connections`.

<!--
Configure WinRM server.

```ps
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
```

Configure WinRM server to accept HTTPS connections.

```ps
winrm enumerate winrm/config/listener
New-SelfSignedCertificate -DnsName "{DomainName}" -CertStoreLocation Cert:\LocalMachine\My
cmd /C 'winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="{DomainName}"; CertificateThumbprint="{Thumbprint}"}'
netsh advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" dir=in action=allow protocol=TCP localport=5986
```

Connect over HTTP.

```ps
Enter-PSSession -ComputerName dc.la.xdsnet.de -Port 5985 -Credential administrator@la.xdsnet.de
```

Connect over HTTPS.

```ps
$soptions = New-PSSessionOption -SkipCACheck
Enter-PSSession -ComputerName dc.la.xdsnet.de -Port 5986 -Credential administrator@la.xdsnet.de -SessionOption $soptions -UseSSL
```
-->

## Configuration Files
Restore configuration files.

* [C:\Users\{User}\vimfiles](configs/.vim/)
* [C:\Users\{User}\.gitconfig](configs/.gitconfig)

## Windows Subsystem for Linux
Execute `bash.exe` in the command prompt. Verify version with `lsb_release -a`.

Change **sudo** settings by executing `sudo EDITOR=vim visudo`.

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

Install packages.

```sh
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
sudo apt autoremove
sudo apt install p7zip-full p7zip-rar zip unzip tree htop shautils
```

Install optional packages.

```sh
sudo apt install imagemagick pdftk
```

Install [neovim](https://neovim.io).

```sh
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt upgrade
sudo apt install neovim
```

Modify the following lines in `/etc/pam.d/login`.

```sh
#session    optional    pam_motd.so motd=/run/motd.dynamic
#session    optional    pam_motd.so noupdate
```

Modify the following lines in `/etc/ssh/sshd_config` (replace `{username}` with your WSL username).

```sh
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key
UsePrivilegeSeparation yes
AllowUsers {username}
GSSAPIAuthentication no
UseDNS no
```

Create a new RSA key.

```sh
sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
sudo chmod 600 /etc/ssh/ssh_host_rsa_key
```

Start the server.

```sh
sudo service ssh start
sudo service ssh status
```

Restore configuration files.

* [~/.ssh/](configs/.ssh/)
* [~/.bashrc](configs/.bashrc)
* [~/.profile](configs/.profile)
* [~/.tmux.conf](configs/.tmux.conf)
* [~/.gitconfig](configs/.gitconfig)

Repplace `{name}`, `{email}` and `{username}` in `.gitconfig`.

Create symlinks to Windows configuration files.

```sh
ln -s /mnt/c/Users/{User}/.gitconfig .gitconfig
ln -s /mnt/c/Users/{User}/.ssh .ssh

mkdir -p .config; chmod 755 .config
ln -s /mnt/c/Users/{User}/vimfiles .config/nvim
ln -s .config/nvim .vim

mkdir -p .ssh; chmod 700 .ssh
cp /mnt/c/Users/{User}/.ssh/config .ssh/config
cp /mnt/c/Users/{User}/.ssh/id_rsa .ssh/id_rsa
cp /mnt/c/Users/{User}/.ssh/id_rsa.pub .ssh/id_rsa.pub
ln -s /mnt/c/Users/{User}/.ssh/known_hosts .ssh/known_hosts
chmod 600 .ssh/*
```

<!--
### SSH Proxy
Forward `localhost:8089` to `core:3389` over `gate`.

```sh
ssh gate -L 8089:core:3389 -N
```
-->

## Disk Cleanup
Delete Windows Update backups and other unwanted files by performing a Disk Cleanup.

<!--
### Skype
Disable ads after installing Skype.

```
Control Panel
+ Internet Options
  + Security
    Restricted sites
    + [Sites]
      Add this website to the zone: https://apps.skype.com
      [Add]
```

Edit `%APPDATA%\Skype\<username>\config.xml`
- Set the `<AdvertPlaceholder>` XML element to `0`.
- Set the file to read-only.
-->

## Start Menu
![Start Menu](layout.png)