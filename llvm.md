## LLVM
Get the LLVM source code.

```sh
ver=5.0.0
for i in llvm cfe clang-tools-extra libcxx libcxxabi compiler-rt libunwind lldb lld; do
  wget http://releases.llvm.org/$ver/$i-$ver.src.tar.xz
done
mkdir -p llvm/tools/clang/tools/extra llvm/projects/{libcxx,libcxxabi,compiler-rt,libunwind,lldb,lld}
tar xf llvm-$ver.src.tar.xz -C llvm --strip-components 1
tar xf cfe-$ver.src.tar.xz -C llvm/tools/clang --strip-components 1
tar xf clang-tools-extra-$ver.src.tar.xz -C llvm/tools/clang/tools/extra --strip-components 1
tar xf libcxx-$ver.src.tar.xz -C llvm/projects/libcxx --strip-components 1
tar xf libcxxabi-$ver.src.tar.xz -C llvm/projects/libcxxabi --strip-components 1
tar xf compiler-rt-$ver.src.tar.xz -C llvm/projects/compiler-rt --strip-components 1
tar xf libunwind-$ver.src.tar.xz -C llvm/projects/libunwind --strip-components 1
tar xf lldb-$ver.src.tar.xz -C llvm/projects/lldb --strip-components 1
tar xf lld-$ver.src.tar.xz -C llvm/projects/lld --strip-components 1
```

<!--
```sh
src=tags/RELEASE_500/final
svn co https://llvm.org/svn/llvm-project/llvm/$src llvm
svn co https://llvm.org/svn/llvm-project/cfe/$src llvm/tools/clang
svn co https://llvm.org/svn/llvm-project/clang-tools-extra/$src llvm/tools/clang/tools/extra
svn co https://llvm.org/svn/llvm-project/libcxx/$src llvm/projects/libcxx
svn co https://llvm.org/svn/llvm-project/libcxxabi/$src llvm/projects/libcxxabi
svn co https://llvm.org/svn/llvm-project/compiler-rt/$src llvm/projects/compiler-rt
svn co https://llvm.org/svn/llvm-project/libunwind/$src llvm/projects/libunwind
svn co https://llvm.org/svn/llvm-project/lldb/$src llvm/projects/lldb
svn co https://llvm.org/svn/llvm-project/lld/$src llvm/projects/lld
```
-->

Build LLVM (change static to shared if the executables don't have to be portable).

```sh
mkdir llvm/build && cd llvm/build
cmake -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="/opt/llvm" \
  -DLLVM_TARGETS_TO_BUILD="AArch64;ARM;X86" \
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
cmake --build .
cmake --build . --target install
```

### Binaryen
Install Binaryen.

```sh
cd /opt
git clone https://github.com/WebAssembly/binaryen
cd binaryen
cmake -GNinja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release .
cmake --build .
```

### Emscripten
Install and configure emscripten.

```sh
cd /opt
git clone -b incoming https://github.com/kripken/emscripten emsdk
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

<!--
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
-->
