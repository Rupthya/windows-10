## LLVM
Execute `bash.exe` in the command prompt.

```sh
sudo apt install apt-file git subversion build-essential ninja-build nasm nodejs npm openjdk-8-jdk-headless
sudo ln -s /usr/bin/nodejs /usr/bin/node
```

### Libraries
Install missing header files for commonly used system libraries.

```sh
sudo apt install binutils-dev zlib1g-dev libpng-dev libfreetype6-dev libssl-dev libcurl4-openssl-dev
```

### CMake
Install CMake.

```sh
wget https://cmake.org/files/v3.8/cmake-3.8.1-Linux-x86_64.tar.gz
sudo mkdir /opt/cmake
sudo tar xvzf cmake-3.8.1-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
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