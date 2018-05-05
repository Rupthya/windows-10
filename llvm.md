## LLVM
Install LLVM.

```sh
apt install build-essential binutils-dev ninja-build nasm git subversion libedit-dev
git clone https://github.com/qis/llvm && cd llvm
make SVN=trunk REV={2018-05-03} PREFIX=/opt/llvm SHARED=OFF STATIC=ON JOBS=4
```

Configure shared libraries in case llvm was installed with the `SHARED=ON` option.

```sh
cat > /etc/ld.so.conf.d/llvm.conf <<EOF
/opt/llvm/lib
/opt/llvm/lib/clang/7.0.0/lib/linux
EOF
ldconfig
```

<!--
### Android
Install Android NDK.

```sh
wget https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip
sudo unzip android-ndk-r16b-linux-x86_64.zip -d /opt/android
```

Create standalone toolchains.

```sh
sudo /opt/android/android-ndk-r16b/build/tools/make_standalone_toolchain.py \
  --api 21 --stl libc++ --arch arm --install-dir /opt/android/arm
sudo /opt/android/android-ndk-r16b/build/tools/make_standalone_toolchain.py \
  --api 21 --stl libc++ --arch arm64 --install-dir /opt/android/arm64
```
-->
