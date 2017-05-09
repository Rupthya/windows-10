# Windows 10
Installation and configuration instructions for Windows 10 Creators Update (Version 1703).

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

1. Physically disconnect the device from all networks.
2. Select the desired Language, Time and currency format, Keyboard or input method.
3. Select "Install now", enter the product key and accept the license terms.
4. Select "Custom: Install Windows only (advanced)".
5. Partition the drive(s) and manually format the "Primary" partition.
6. Wait for the installation to complete, remove the installation media and reboot.
7. Chose a username without spaces starting with a capital letter.
8. Skip network connection settings.
9. Disable every available option.

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

## User Name
Change the full user name.

```cmd
lusrmgr.msc > Users > {user}
+ Full Name: {User Name}
```

## Drivers & Windows Updates
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

## Disable Windows Defender (Optional)
Disable Windows Defender.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Windows Defender Antivirus
+ Turn off Windows Defender Antivirus: Enabled

Windows Defender Antivirus > Real-time Protection
+ Turn off real-time protection: Enabled

Windows Defender Antivirus > MAPS
+ Join Microsoft MAPS: Disabled

Windows Defender Antivirus > Network Inspection System
+ Turn on definition retirement: Disabled
+ Turn on protocol recognition: Disabled

Windows Defender Antivirus > Signature Updates
+ Allow definition updates from Microsoft Update: Disabled

Windows Defender Application Guard
+ Turn On/Off Windows Defender Application Guard (WDAG): Disabled

Windows Defender SmartScreen > Explorer
+ Configure App Install Control: Disabled
+ Configure Windows Defender SmartScreen: Disabled

Windows Defender SmartScreen > Microsoft Edge
+ Configure Windows Defender SmartScreen: Disabled
```

Disable Windows Defender notification icon.

```
Task Manager > Startup
+ Windows Defender notification icon: Disabled
```

## Error Reports
Disable error reports.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Windows Error Reporting
+ Disable Windows Error Reporting: Enabled
```

## Windows Search
Configure search.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Search
+ Allow Cortana: Disabled
+ Do not allow web search: Enabled
+ Don't search the web or display web results in Search: Enabled
+ Don't search the web or display web results in Search over metered connections: Enabled
```

## Telemetry
Disable telemetry.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Data Collection and Preview Builds
+ Allow Telemetry: Disabled
```

Delete the diagnostics services.

```cmd
sc delete DiagTrack
sc delete dmwappushservice
```

Disable the Application Experience tasks.

```
Task Scheduler > Task Scheduler Library > Microsoft > Windows > Application Experience
+ Microsoft Compatibility Appraiser: Disabled
+ ProgramDataUpdater: Disabled
```

Reboot the system.

## Network & Updates
Disable Wi-Fi Services and Hotspot 2.0 networks.

```
Settings > Network & Internet > Wi-Fi > Manage Wi-Fi settings
Wi-Fi services: Off
Hotspot 2.0 networks: Off
```

Connect to the Internet and sign in using a Microsoft account (optional, not recommended).

Install missing device drivers and pending updates.

Disable automatic Windows updates.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Windows Update
+ Configure Automatic Updates: Enabled
  Configure automatic updating: 2 - Notify for download and auto install
```

## Windows Store & Apps
Uninstall all apps except "App Installer" and "Weather" (optional).

```
Settings > Apps
```

<!--
Disable Windows Store (optional).

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components

Store
+ Turn off the Store application: Enabled
```
-->

## OneDrive
Uninstall OneDrive.

```cmd
taskkill /f /im OneDrive.exe
%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe /uninstall
rd /q /s "%USERPROFILE%\OneDrive"
rd /q /s "C:\OneDriveTemp"
```

Reboot the system.

Prevent OneDrive from being reinstalled.

```cmd
rd /q /s "%LOCALAPPDATA%\Microsoft\OneDrive"
rd /q /s "%PROGRAMDATA%\Microsoft OneDrive"
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
```

Execute the following in a user command prompt.

```cmd
rd /q /s "%USERPROFILE%\OneDrive"
```

Reboot the system.

## Microsoft Software
Configure [Microsoft Edge](https://en.wikipedia.org/wiki/Microsoft_Edge) after visiting <https://www.google.com/ncr>.

```
Settings
Open Microsoft Edge with: A specific page or pages
  about:blank
Open Microsoft Edge with: Previous pages
Open new tabs with: A blank page
[View advanced settings]
  Open sites in apps: Off
  Ask me what to do with each download: Off
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
  "editor.fontFamily": "DejaVu Sans Mono, Consolas, monospace",
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
  "explorer.openEditors.visible": 0,
  "window.openFilesInNewWindow": "off",
  "files.trimTrailingWhitespace": true,
  "files.hotExit": "off",
  "files.eol": "\n"
}
```

Uninstall unwanted applications in `Settings > Apps`.<br/>
Uninstall unwanted optional features in `Settings > Apps > Manage optional features`.

## Keymap
If you need to be able to input German characters on a U.S. keyboard, you can use a custom [keymap](keymap.zip).

## Photos
Disable automatic photo enhancements and linked duplicates.

```
Photos > Settings
Automatically enhance my photos: Off
Linked duplicates: Off
```

## Services
Disable unwanted services. Skip entries when required.

```
services.msc
+ Certificate Propagation: Disabled
+ Geolocation Service: Disabled
+ Microsoft (R) Diagnostics Hub Standard Collector Service: Disabled
+ Superfetch: Disabled
+ Windows Biometric Service: Disabled
+ Xbox Live …: Disabled
```

## Notifications (Optional)
Disable notifications and Action Center.

```
gpedit.msc > User Configuration > Administrative Templates > Start Menu and Taskbar
+ Remove Notifications and Action Center: Enabled
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
  + Remomte Desktop - …
  + SSH Server Proxy Service
+ Outbound Rules
  + Connect
  + Core Networking - …
  + Hyper-V …
```

Enable inbound rules for "File and Printer Sharing (Echo Request …)". Modify "Private,Public"
rules for inbound and outbound IPv4 and IPv6 Echo Requests and select "Any IP address" under
"Remote IP address" in the "Scope" tab.

To enable the WSL SSH Server, you need to replace the "SSH Server Proxy Service" inbound rule
with a new inbound rule for port 22.

## Notifications
Disable unwanted notifications.

```
Control Panel > System and Security > Security and Maintenance
  [Turn off all messages about …]
```

## Windows Libraries
Move unwanted Windows libraries.

1. Go to `%UserProfile%\Pictures`.
2. Right click on `Camera Roll` and select `Properties`.
3. Select the `Location` tab and enter a new location e.g. `%AppData%\Camera Roll`.
4. Right click on `Saved Pictures` and select `Properties`.
5. Select the `Location` tab and enter a new location e.g. `%AppData%\Saved Pictures`.

Repeat the process for `%UserProfile%\Videos\Captures`.

## Settings
Use common sense in **Settings**, **Control Panel**, **Explorer Options** and **Indexing Optinos**.

## Windows Features
Enable or disable Windows features.

```
Control Panel > Programs > Turn Windows features on or off
[ ] Media Features
[ ] SMB 1.0/CIFS File Sharing Support
[✓] Windows Subsystem for Linux
[ ] XPS Services
[ ] XPS Viewer
```

## Disk Cleanup
Delete Windows Update backups and other unwanted files by performing a Disk Cleanup.

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

Disable hibernation (for stationary computers).

```cmd
powercfg -h off
```

# Development
Install software useful for Windows and Unix development.

## Visual Studio 2017
Install [Visual Studio Community 2017](https://www.visualstudio.com/vs/visual-studio-2017-rc).

```
Individual Components
+ Code tools
  [✓] Git for Windows
  [✓] GitHub extension for Visual Studio
  [✓] Static analysis tools
  [✓] Text Template Transformation
+ Compilers, build tools, and runtimes
  [✓] VC++ 2017 v141 toolset (x86,x64)
  [✓] Visual C++ tools for CMake
+ Debugging and testing
  [✓] C++ profiling tools
  [✓] JavaScript diagnostics
  [✓] Just-In-Time debugger
  [✓] Profiling tools
  [✓] Testing tools core features
+ Development activities
  [✓] JavaScript and TypeScript language support
  [✓] Node.js support
  [✓] Visual Studio C++ core features
+ Games and Graphics
  [✓] Graphics debugger and GPU profilier for DirectX
  [✓] Image and 3D model editors
+ SDKs, libraries, and frameworks
  [✓] TypeScript 2.1 SDK
  [✓] Visual C++ ATL support
  [✓] Windows SDK (10.0.15063.0) for Desktop C++ x86 and x64
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
* [Git Large File Storage](https://git-lfs.github.com)
* [TightVNC Viewer](http://www.tightvnc.com)
* [Affinity Photo](https://affinity.serif.com/photo)
* [Affinity Designer](https://affinity.serif.com/designer)
* [Sketchbook Pro](http://www.autodesk.com/products/sketchbook-pro/overview)
* [Blender](https://www.blender.org)
* [gVim](http://www.vim.org)

Initialize Git Large File Storage.

```cmd
git lfs install
```

## Optional
Install optional software.

* [Skype](https://www.skype.com/en)
* [ConEmu](https://conemu.github.io)
* [WSLtty](https://github.com/mintty/wsltty)
* [SQL Server Management Studio](https://msdn.microsoft.com/en-us/library/mt238290.aspx)
* [Remote Server Administration Tools for Windows 10](https://www.microsoft.com/en-us/download/details.aspx?id=45520)
* [Google Drive](https://www.google.com/drive/download)

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

## Environment
Add entries to the `Path` environment variable.

```
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Web\External
C:\Program Files\NASM\2.12.02
C:\Program Files\7-Zip
```

Set the `NODE_PATH` environment variable.

```
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Web\External\node_modules
```

## Start Menu
![Start Menu](layout.png)

## Windows Subsystem for Linux
Execute `bash.exe` in the command prompt. Verify version with `lsb_release -a`.

### Setup
Restore configuration files.

* [~/.ssh/](configs/.ssh/)
* [~/.vim/](configs/.vim/)
* [~/.bashrc](configs/.bashrc)
* [~/.gitconfig](configs/.gitconfig)
* [~/.minttyrc](configs/.minttyrc)
* [~/.profile](configs/.profile)
* [~/.tmux.conf](configs/.tmux.conf)

Move `.vim` to `%USERPROFILE%\vimfiles` and create a symlink to `~/.vim`.<br/>
Move `.gitconfig` to `%USERPROFILE%\.gitconfig` and create a symlink to `~/.gitconfig`.<br/>
Repplace `{name}`, `{email}` and `{username}` in `.gitconfig`.

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
sudo apt install p7zip-full zip unzip tree htop
```

### SSH Server
Modify the following lines in `/etc/ssh/sshd_config` replacing `{username}` with your WSL username.

```sh
HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key
AllowUsers {username}
```

Create a new RSA key.

```sh
sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
```

Start the server.

```sh
sudo service ssh start
sudo service ssh status
```

## Unix Development
Execute `bash.exe` in the command prompt.

```sh
sudo apt install apt-file git subversion build-essential ninja-build nasm nodejs npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
wget https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh
sudo bash script.deb.sh
sudo apt install git-lfs
sudo apt-file update
sudo git lfs install
```

### CMake
Install CMake.

```sh
wget https://cmake.org/files/v3.8/cmake-3.8.0-Linux-x86_64.tar.gz
sudo mkdir /opt/cmake
sudo tar xvzf cmake-3.8.0-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
```

### Java
Install Java.

```sh
wget --no-check-certificate --no-cookies - --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
sudo mkdir /opt/java
sudo tar xvzf jdk-8u121-linux-x64.tar.gz -C /opt/java --strip-components 1
```

### Android
Install Android tools.

```sh
sudo apt install android-tools-adb
```

Install Android NDK.

```sh
wget https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip
sudo unzip android-ndk-r14b-linux-x86_64.zip -d /opt/android
sudo /opt/android/android-ndk-r14b/build/tools/make_standalone_toolchain.py \
  --api 21 --stl libc++ --arch arm --install-dir /opt/android/arm
sudo /opt/android/android-ndk-r14b/build/tools/make_standalone_toolchain.py \
  --api 21 --stl libc++ --arch arm64 --install-dir /opt/android/arm64
```

### LLVM
Install LLVM.

```sh
src=tags/RELEASE_400/final
svn co http://llvm.org/svn/llvm-project/llvm/$src llvm
svn co http://llvm.org/svn/llvm-project/cfe/$src llvm/tools/clang
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/$src llvm/tools/clang/tools/extra
svn co http://llvm.org/svn/llvm-project/libcxx/$src llvm/projects/libcxx
svn co http://llvm.org/svn/llvm-project/libcxxabi/$src llvm/projects/libcxxabi
svn co http://llvm.org/svn/llvm-project/compiler-rt/$src llvm/projects/compiler-rt

mkdir llvm/build && cd llvm/build
cmake -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="/opt/llvm" \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="WebAssembly" \
  -DLLVM_INCLUDE_EXAMPLES=OFF \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_ENABLE_WARNINGS=OFF \
  -DLLVM_ENABLE_PEDANTIC=OFF \
  -DCLANG_DEFAULT_CXX_STDLIB="libc++" \
  -DCLANG_INCLUDE_TESTS=OFF \
  -DLIBCXX_ENABLE_FILESYSTEM=ON \
  -DLIBCXX_ENABLE_SHARED=OFF \
  -DLIBCXX_ENABLE_STATIC=ON \
  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
  -DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXXABI_ENABLE_SHARED=OFF \
  -DLIBCXXABI_ENABLE_STATIC=ON \
  ..
time cmake --build .
sudo cmake --build . --target install
```

<!--
ESX Xeon E5-2609: 00:30:00
WSL Core i7-2600: 00:45:00
WSL Core i7-5500:
-->

### Binaryen
Install Binaryen.

```sh
cd /opt
sudo git clone https://github.com/WebAssembly/binaryen
cd binaryen
sudo cmake -GNinja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release .
sudo cmake --build .
```

### Emscripten
Install and configure emscripten.

```sh
cd /opt
sudo git clone -b incoming https://github.com/kripken/emscripten emsdk
em++
```

Verify `~/.emscripten`.

```py
import os
EMSCRIPTEN_ROOT = os.path.expanduser(os.getenv('EMSCRIPTEN') or '/opt/emsdk') # directory
LLVM_ROOT = os.path.expanduser(os.getenv('LLVM') or '/opt/llvm/bin') # directory
BINARYEN_ROOT = os.path.expanduser(os.getenv('BINARYEN') or '/opt/binaryen') # directory
NODE_JS = os.path.expanduser(os.getenv('NODE') or '/usr/bin/nodejs') # executable
JAVA = 'java'
TEMP_DIR = '/tmp'
COMPILER_ENGINE = NODE_JS
JS_ENGINES = [NODE_JS]
```