# Windows 10
Download the latest [Windows 10](https://www.microsoft.com/en-us/software-download/windows10ISO) version and create a USB stick.

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

## Installation
1. Physically disconnect the device from all networks.
2. Select the desired Language, Time and currency format, Keyboard or input method.
3. Select "Install now", enter the product key and accept the license terms.
4. Select "Custom: Install Windows only (advanced)".
5. Partition the drive(s) and manually format the "Primary" partition.
6. Select "Customise" on the first boot and disable *everything*.
8. Chose a username without spaces starting with a capital letter.
9. Skip the "Meet Cortana" setup.

## Hostname
Change your hostname and NetBIOS name.

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

## Drivers & Windows Updates
Disable automatic driver app installation.

```
Control Panel > System > Advanced system settings > Hardware > Device Installation Settings
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

Connect to the Internet and sign in using a Microsoft account (optional).

Install missing device drivers and pending updates.

## Microsoft Software
Configure [Windows Command Line](https://en.wikipedia.org/wiki/Cmd.exe).

```cmd
reg add "HKEY_CURRENT_USER\Console" /v "WindowSize" /t REG_DWORD /d 0x280078 /f
reg add "HKEY_CURRENT_USER\Console" /v "FaceName" /t REG_SZ /d "Consolas" /f
reg add "HKEY_CURRENT_USER\Console" /v "FontSize" /t REG_DWORD /d 0x100000 /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable00" /t REG_DWORD /d 0x001e1e1e /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable04" /t REG_DWORD /d 0x00ff615a /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable02" /t REG_DWORD /d 0x00b1e969 /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable06" /t REG_DWORD /d 0x00ebd99c /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable01" /t REG_DWORD /d 0x005da9f6 /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable05" /t REG_DWORD /d 0x00e86aff /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable03" /t REG_DWORD /d 0x0082fff7 /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable07" /t REG_DWORD /d 0x00dcdcdc /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable08" /t REG_DWORD /d 0x00787878 /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable12" /t REG_DWORD /d 0x00f58c80 /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable10" /t REG_DWORD /d 0x00ddf88f /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable14" /t REG_DWORD /d 0x00eee5b2 /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable09" /t REG_DWORD /d 0x00a5c7ff /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable13" /t REG_DWORD /d 0x00ddaaff /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable11" /t REG_DWORD /d 0x00b7fff9 /f
reg add "HKEY_CURRENT_USER\Console" /v "ColorTable15" /t REG_DWORD /d 0x00ffffff /f
```

Configure [Microsoft Edge](https://en.wikipedia.org/wiki/Microsoft_Edge) after visiting <https://www.google.com/ncr>.

```
Settings
Open Microsoft Edge with: A specific page or pages
  about:blank
Open Microsoft Edge with: Previous pages
Open new tabs withj: A blank page
[View advanced settings]
  Ask me what to do with each download: Off
  Have Cortana assist me in Microsoft Edge: Off
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
  "editor.fontFamily": "DejaVu Sans Mono, Consolas, Courier New, monospace",
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
  "window.openFilesInNewWindow": false,
  "files.eol": "\n",
  "files.trimTrailingWhitespace": true
}
```

Uninstall unwanted applications in `Settings > System > Apps & features`.

Uninstall unwanted optional features in `Settings > System > Apps & features > Manage optional features`.

## Automatic Windows Updates
Disable automatic Windows updates.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components > Windows Update
+ Configure Automatic Updates: Enabled
  Configure automatic updating: 2 - Notify for download and notify for install
```

## Keymap
If you need to be able to input German characters on a U.S. keyboard, you can use a custom [keymap](keymap.zip).

## Windows Defender
Disable the Windows Defender cloud-based protection, sample submission and notifications.

```
Settings > Update & security > Windows Defender
Cloud-based Protection: Off
Automatic sample submission: Off
Enhanced notifications: Off
```

Disable the Windows Defender real-time protection.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components > Windows Defender > Real-time Protection
+ Turn off real-time protection: Enabled
```

Disable the Windows Defender notification icon.

```
Task Manager > Startup
+ Windows Defender notification icon: Disabled
```

Reboot the system.

## Wi-Fi
Disable Wi-Fi Sense, Hotspot 2.0 networks and Paid Wi-Fi services.

```
Settings > Network & Internet > Wi-Fi > Manage Wi-Fi settings
Wi-Fi Sense: Off
Hotspot 2.0 networks: Off
Paid Wi-Fi services: Off
```

To prevent other users from sharing the password, the SSID must have the suffix "_output".

## Telemetry
Delete the diagnostics services.

```cmd
sc delete DiagTrack
sc delete dmwappushservice
echo. > "%programdata%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
cacls "%programdata%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /d SYSTEM
```

Disable telemetry.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components > Data Collection and Preview Builds
+ Allow Telemetry: Disabled
```

Disable hidden telemetry.

```cmd
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
```

Disable the Application Experience tasks.

```
Task Scheduler > Task Scheduler Library > Microsoft > Windows > Application Experience
+ Microsoft Compatibility Appraiser: Disabled
+ ProgramDataUpdater: Disabled
```

Reboot the system.

## OneDrive
Uninstall OneDrive.

```cmd
taskkill /f /im OneDrive.exe
%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe /uninstall
rd /q /s "%USERPROFILE%\OneDrive"
rd /q /s "C:\OneDriveTemp"
shutdown -r -t 0
```

Prevent OneDrive from being reinstalled.

```cmd
rd /q /s "%LOCALAPPDATA%\Microsoft\OneDrive"
rd /q /s "%PROGRAMDATA%\Microsoft OneDrive"
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
shutdown -r -t 0
```

Execute the following in a user command prompt.

```cmd
rd /q /s "%USERPROFILE%\OneDrive"
```

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
+ DataCollectionPublishingService: Disabled
+ Downloaded Maps Manager: Disabled
+ Geolocation Service: Disabled
+ Microsoft (R) Diagnostics Hub Standard Collector Service: Disabled
+ Superfetch: Disabled
+ Windows Biometric Service: Disabled
+ Xbox Live …: Disabled
```

## Help & Support
Disable Help & Support (F1 hotkey in Windows applications).

```cmd
taskkill /f /im HelpPane.exe
takeown /a /f C:\Windows\HelpPane.exe
icacls C:\Windows\HelpPane.exe /grant %username%:F
move C:\Windows\HelpPane.exe C:\Windows\HelpPane.exe.bak
```

## Firewall
Disable all rules in the Windows Firewall settings.

```
wf.msc
+ Inbound Rules
  + Core Networking - …
  + Delivery Optimization (…)
  + File and Printer Sharing (Echo Request …)
  + Remomte Desktop - …
  + SSH Server Proxy Service
+ Outbound Rules
  + Core Networking - …
  + File and Printer Sharing (Echo Request …)
```

Modify inbound rules for the IPv4 and IPv6 "Private, Public" domain echo requests.

To enable the WSL SSH Server, you need to create a new inbound rule for port 22.

```
Rule Properties > Scope
Remote IP address: Any IP address
```

## Notifications
Disable unwanted notifications.

```
Control Panel > System and Security > Security and Maintenance
  (Turn off all messages.)
```

## Windows Libraries
Move unwanted Windows libraries.

1. Go to `%UserProfile%\Pictures`.
2. Right click on `Camera Roll` and select `Properties`.
3. Select the `Location` tab and enter a new location e.g. `%AppData%\Camera Roll`.
4. Right click on `Saved Pictures` and select `Properties`.
5. Select the `Location` tab and enter a new location e.g. `%AppData%\Saved Pictures`.

## Settings
Use common sense in **Settings**, **Control Panel**, **Explorer Options** and **Indexing Optinos**.

## Search
Disable Cortana.

```
gpedit.msc > Computer Configuration > Administrative Templates > Windows Components > Search
+ Allow Cortana: Disabled
```

Disable Bing search results.

```cmd
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
```

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

## Windows Subsystem for Linux
Execute `bash.exe` in the command prompt.

### Setup
Create the file `~/.bashrc`.

```sh
# Path
PATH="/opt/cmake/bin:/opt/llvm/bin:/opt/java/bin:/opt/emsdk:/opt/binaryen/bin"
PATH="${PATH}:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export PATH

# Limits
ulimit -S -c 0

# History
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
shopt -s histappend

# Unicode
export UTF8=$(locale -m | grep -i utf | head -1)
export NCURSES_NO_UTF8_ACS="1"
export MM_CHARSET="UTF-8"

# Localization
export LANG="en_US.${UTF8}"
export LC_MESSAGES="en_US.${UTF8}"
export LC_CTYPE="en_US.${UTF8}"
export LC_COLLATE="C"
export LC_ALL=

# Applications
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
export EDITOR=$(which nvim vim vi 2>/dev/null | head -1)
export PAGER="less"

# Colors
LC_COLORS=
LS_COLORS="${LS_COLORS}di=1;34:"
LS_COLORS="${LS_COLORS}ln=35;40:"
LS_COLORS="${LS_COLORS}so=32;40:"
LS_COLORS="${LS_COLORS}pi=33;40:"
LS_COLORS="${LS_COLORS}ex=31;40:"
LS_COLORS="${LS_COLORS}bd=34;46:"
LS_COLORS="${LS_COLORS}cd=34;43:"
LS_COLORS="${LS_COLORS}su=0;41:"
LS_COLORS="${LS_COLORS}sg=0;46:"
LS_COLORS="${LS_COLORS}tw=0;42:"
LS_COLORS="${LS_COLORS}ow=1;34"
export LS_COLORS

# Aliases
alias ..="cd .."

alias ls="ls -F --color=auto --group-directories-first"
alias lsa="ls -a"

alias ll="ls -lh --time-style long-iso"
alias lla="ll -a"

alias vim="${EDITOR} -p"
alias grep="grep --color=auto"
alias sudo="sudo "

alias tm="tmux -2"
alias ta="tm attach -t"
alias ts="tm new-session -s"
alias tl="tm list-sessions"

# Settings
export HISTFILE="${HOME}/.history"

PS1=
if [ -n "${TMUX}" ]; then
  id="$(echo $TMUX | awk -F, '{print $3 + 1}')"
  session="$(tmux ls | head -${id} | tail -1 | cut -d: -f1)"
  PS1="${PS1}\[\e[90m\][\[\e[0m\]${session}\[\e[90m\]]\[\e[0m\] "
fi
if [ $(id -u) -ne 0 ]; then
  PS1="${PS1}\[\e[32m\]\u\[\e[0m\]"
else
  PS1="${PS1}\[\e[31m\]\u\[\e[0m\]"
fi
PS1="${PS1}@\[\e[32m\]\h\[\e[0m\]"
PS1="${PS1} \[\e[34m\]\w\[\e[0m\] "
export PS1

set -o emacs
```

Create the file `~/.profile`.

```sh
source ~/.bashrc
```

Create the file `~/.tmux.conf`.

```tmux
set-option -g terminal-overrides "xnerm*:smcup@:rmcup@"
set-option -g bell-on-alert off
set-option -g base-index 1
set-option -g default-terminal "screen-256color"
set-option -g status off
set-option -g escape-time 0
```

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
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get autoremove
sudo apt-get install p7zip-full zip unzip tree htop
```

On WSL 14.04 you need to fix a small compatibility issue for the SSH server to work properly.

```sh
sudo dpkg-divert --local --rename --add /sbin/initctl
sudo ln -s /bin/true /sbin/initctl
```

### SSH Server
Modify the following lines in `/etc/ssh/sshd_config` replacing `{username}` with your WSL username.

```sh
HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key
UsePrivilegeSeparation no
AllowUsers {username}
```

Create a new RSA key.

```sh
sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
```

On WSL 14.04 you need to disable the Windows **SSH Server Proxy** service.

```
services.msc
+ SSH Server Proxy: Disabled
```

Start the server.

```sh
sudo service ssh start
sudo service ssh status
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
+ Compilers, build tools, and runtimes
  [✓] VC++ 2017 v141 toolset (x86,x64)
  [✓] Visual C++ compilers and libraries for ARM
  [✓] Visual C++ runtime for UWP
  [✓] Visual C++ tools for CMake
  [✓] Windows Universal CRT SDK
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
  [✓] Java SE Development Kit
  [✓] TypeScript 2.1 SDK
  [✓] Windows SDK (latest)
  [✓] Windows Universal C Runtime
```

## Unix Development
Execute `bash.exe` in the command prompt.

```sh
sudo apt-get install git subversion build-essential nasm nodejs npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
```

### CMake
Install CMake.

```sh
wget https://cmake.org/files/v3.7/cmake-3.7.1-Linux-x86_64.tar.gz
sudo mkdir /opt/cmake
sudo tar xvzf cmake-3.7.1-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
```

### Java
Install Java.

```sh
wget --no-check-certificate --no-cookies - --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jre-8u111-linux-x64.tar.gz
sudo mkdir /opt/java
sudo tar xvzf jre-8u111-linux-x64.tar.gz -C /opt/java --strip-components 1
```

### Android
Install Android tools.

```sh
sudo apt-get install android-tools-adb
```

Install Android NDK.

```sh
wget https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip
sudo unzip android-ndk-r13b-linux-x86_64.zip -d /opt/android
sudo /opt/android/android-ndk-r13b/build/tools/make_standalone_toolchain.py --arch arm --install-dir /opt/android/arm
sudo /opt/android/android-ndk-r13b/build/tools/make_standalone_toolchain.py --arch arm64 --install-dir /opt/android/arm64
```

## Fonts
Install fonts.

* [DejaVu & DejaVu LGC](https://sourceforge.net/projects/dejavu/files/dejavu)
* [DejaVu Sans Mono from Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
* [Iconsolata](http://www.levien.com/type/myfonts/inconsolata.html)
* [IPA](http://ipafont.ipa.go.jp)

Change the default Command Line font.

```cmd
reg add "HKEY_CURRENT_USER\Console" /v "FaceName" /t REG_SZ /d "DejaVuSansMono NF" /f
reg add "HKEY_CURRENT_USER\Console" /v "FontSize" /t REG_DWORD /d 0xE0000 /f
```

## Third Party
Install third party software.

* [7-Zip](http://www.7-zip.org)
* [NASM](http://www.nasm.us)
* [HxD](https://mh-nexus.de/en/hxd)
* [CFF Explorer](http://www.ntcore.com/exsuite.php)
* [Resource Hacker](http://www.angusj.com/resourcehacker)
* [Sysinternals Suite](https://technet.microsoft.com/en-us/sysinternals/bb842062.aspx) (Process Explorer, Process Monitor, AccessEnum)
* [TightVNC Viewer](http://www.tightvnc.com)
* [Affinity Photo](https://affinity.serif.com/photo)
* [Affinity Designer](https://affinity.serif.com/designer)
* [Sketchbook Pro](http://www.autodesk.com/products/sketchbook-pro/overview)
* [Blender](https://www.blender.org)
* [gVim](http://www.vim.org)

## Environment
Add the following entries to the `Path` environment variable (adjust as needed).

```
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Web\External
C:\Program Files (x86)\Java\jdk1.8.0_92\bin
C:\Program Files\7-Zip
C:\Program Files\Git\cmd
C:\Program Files\NASM\2.12.02
```

Set the `NODE_PATH` environment variable to the following value (adjust as needed).

```
C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Web\External\node_modules
```

## Start Menu
![Start Menu](layout.png)

<!--
### LLVM Sources
Download the LLVM sources.

```sh
# Assign the revision to a variable.
# svn info http://llvm.org/svn/llvm-project/llvm/trunk | grep Revision
REVISION=284483
svn co -r${REVISION} http://llvm.org/svn/llvm-project/llvm/trunk llvm
svn co -r${REVISION} http://llvm.org/svn/llvm-project/cfe/trunk llvm/tools/clang
svn co -r${REVISION} http://llvm.org/svn/llvm-project/clang-tools-extra/trunk llvm/tools/clang/tools/extra
svn co -r${REVISION} http://llvm.org/svn/llvm-project/libcxx/trunk llvm/projects/libcxx
svn co -r${REVISION} http://llvm.org/svn/llvm-project/libcxxabi/trunk llvm/projects/libcxxabi
svn co -r${REVISION} http://llvm.org/svn/llvm-project/compiler-rt/trunk llvm/projects/compiler-rt
```

Patch the linux tool chain if you don't want to specify `-lc++abi -lc++experimental` when using libcxx.

```diff
--- tools/clang/lib/Driver/ToolChains.h.orig	2016-10-19 11:22:49.794908400 +0200
+++ tools/clang/lib/Driver/ToolChains.h	2016-10-19 11:23:33.514771400 +0200
@@ -830,6 +830,8 @@ public:
   void AddClangCXXStdlibIncludeArgs(
       const llvm::opt::ArgList &DriverArgs,
       llvm::opt::ArgStringList &CC1Args) const override;
+  void AddCXXStdlibLibArgs(const llvm::opt::ArgList &Args,
+                           llvm::opt::ArgStringList &CmdArgs) const override;
   void AddCudaIncludeArgs(const llvm::opt::ArgList &DriverArgs,
                           llvm::opt::ArgStringList &CC1Args) const override;
   void AddIAMCUIncludeArgs(const llvm::opt::ArgList &DriverArgs,
--- tools/clang/lib/Driver/ToolChains.cpp.orig	2016-10-19 11:22:41.196953300 +0200
+++ tools/clang/lib/Driver/ToolChains.cpp	2016-10-19 13:15:07.480687400 +0200
@@ -4700,6 +4700,15 @@ void Linux::AddClangCXXStdlibIncludeArgs
   }
 }

+void Linux::AddCXXStdlibLibArgs(const ArgList &Args,
+                                ArgStringList &CmdArgs) const {
+  if (GetCXXStdlibType(Args) == ToolChain::CST_Libcxx) {
+    CmdArgs.push_back("-lc++");
+    CmdArgs.push_back("-lc++abi");
+    CmdArgs.push_back("-lc++experimental");
+  }
+}
+
 void Linux::AddCudaIncludeArgs(const ArgList &DriverArgs,
                                ArgStringList &CC1Args) const {
   if (!DriverArgs.hasArg(options::OPT_nobuiltininc)) {
```

### LLVM Stage 1
Install LLVM in stage 1 mode (compiled with GCC 6).

```sh
cd && mkdir -p llvm/build && cd llvm/build && rm -rf *
CC=gcc-6 CXX=g++-6 \
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/llvm \
  -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_TESTS=OFF \
  -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="WebAssembly" \
  -DLIBCXX_ENABLE_SHARED=OFF -DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON -DLIBCXX_ENABLE_FILESYSTEM=ON \
  -DLIBCXX_CXX_ABI=libcxxabi -DLIBCXX_CXX_ABI_INCLUDE_PATHS="../projects/libcxxabi/include" \
  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON -DLIBCXXABI_ENABLE_SHARED=OFF -DLIBCXXABI_ENABLE_STATIC=ON \
  -DCLANG_DEFAULT_CXX_STDLIB="libc++" ..
cmake --build .
sudo cmake --build . --target install
```

### LLVM Stage 2
Install LLVM in stage 2 mode (compiled with LLVM Stage 1).

```sh
cd && mkdir -p llvm/build && cd llvm/build && rm -rf *
CC=clang CXX=clang++ \
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/llvm \
  -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_TESTS=OFF \
  -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="WebAssembly" \
  -DLIBCXX_ENABLE_SHARED=OFF -DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON -DLIBCXX_ENABLE_FILESYSTEM=ON \
  -DLIBCXX_CXX_ABI=libcxxabi -DLIBCXX_CXX_ABI_INCLUDE_PATHS="../projects/libcxxabi/include" \
  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON -DLIBCXXABI_ENABLE_SHARED=OFF -DLIBCXXABI_ENABLE_STATIC=ON \
  -DCLANG_DEFAULT_CXX_STDLIB="libc++" ..
cmake --build .
sudo mv /opt/llvm /opt/llvm-stage1
sudo cmake --build . --target install
```

### Binaryen
Install Binaryen.

```sh
cd /opt
sudo git clone https://github.com/WebAssembly/binaryen
cd binaryen
sudo cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ .
sudo cmake --build .
```

### Emscripten
Install and configure emscripten.

```sh
cd /opt
sudo git clone -b incoming https://github.com/kripken/emscripten emsdk
em++
```

Modify `~/.emscripten`.

```py
import os
TEMP_DIR = '/tmp'
EMSCRIPTEN_ROOT = os.path.expanduser(os.getenv('EMSCRIPTEN') or '/opt/emsdk') # directory
LLVM_ROOT = os.path.expanduser(os.getenv('LLVM') or '/opt/llvm/bin') # directory
BINARYEN_ROOT = os.path.expanduser(os.getenv('BINARYEN') or '/opt/binaryen') # directory
NODE_JS = os.path.expanduser(os.getenv('NODE') or '/usr/bin/nodejs') # executable
JAVA = 'java'
COMPILER_ENGINE = NODE_JS
JS_ENGINES = [NODE_JS]
```
-->

<!--
## Skype
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
