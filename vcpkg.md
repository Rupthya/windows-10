# VCPKG
<!--
Project description.

## Requirements
* [CMake](https://cmake.org/download/) version 3.10
* [LLVM](https://llvm.org/) and [libcxx](https://libcxx.llvm.org/) version 6.0.0 on Linux and FreeBSD
* [Visual Studio](https://www.visualstudio.com/downloads/) version 15.7 on Windows
* [Vcpkg](https://github.com/Microsoft/vcpkg)

## Dependencies
-->
Install Vcpkg using the following instructions. Adjust the commands as necessary or desired.

### Windows
Set the `VCPKG_DEFAULT_TRIPLET` environment variable to `x64-windows-static-md`.<br/>
Set the `VCPKG` environment variable to `C:/Libraries/vcpkg/scripts/buildsystems/vcpkg.cmake`.<br/>
Add `C:\Libraries\vcpkg\installed\%VCPKG_DEFAULT_TRIPLET%\bin` to the `PATH` environment variable.<br/>
Add `C:\Libraries\vcpkg` to the `PATH` environment variable.

```cmd
git clone https://github.com/Microsoft/vcpkg C:\Libraries\vcpkg
cd C:\Libraries\vcpkg && bootstrap-vcpkg.bat && vcpkg integrate install
@echo set(VCPKG_TARGET_ARCHITECTURE x64)> triplets\x64-windows-static-md.cmake
@echo set(VCPKG_CRT_LINKAGE dynamic)>>    triplets\x64-windows-static-md.cmake
@echo set(VCPKG_LIBRARY_LINKAGE static)>> triplets\x64-windows-static-md.cmake
```

### WSL
Set the `VCPKG_DEFAULT_TRIPLET` environment variable to `x64-linux`.<br/>
Set the `VCPKG` environment variable to `/mnt/c/Libraries/vcpkg/scripts/buildsystems/vcpkg.cmake`.<br/>
Add `/mnt/c/Libraries/vcpkg/bin` to the `PATH` environment variable.

```sh
mkdir /mnt/c/Libraries/vcpkg/bin && cd /mnt/c/Libraries/vcpkg/bin
cmake -GNinja -DCMAKE_BUILD_TYPE=Release ../toolsrc \
  -DCMAKE_C_COMPILER=`which clang-devel | which clang` \
  -DCMAKE_CXX_COMPILER=`which clang++-devel | which clang++`
cmake --build .
cat > ../triplets/x64-linux.cmake <<EOF
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME Linux)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "\${CMAKE_CURRENT_LIST_DIR}/toolchains/linux-toolchain.cmake")
EOF
mkdir ../triplets/toolchains
cat > ../triplets/toolchains/linux-toolchain.cmake <<EOF
set(CMAKE_CROSSCOMPILING FALSE)
set(CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(CMAKE_C_COMPILER `which clang-devel | which clang` CACHE STRING "")
set(CMAKE_CXX_COMPILER `which clang++-devel | which clang++` CACHE STRING "")
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -stdlib=libc++")
set(HAVE_STEADY_CLOCK ON)
set(HAVE_STD_REGEX ON)
EOF
find ../ports -type f -exec sed -i -E 's/unofficial(-|::)?//g' '{}' ';'
```

### FreeBSD
Set the `VCPKG_DEFAULT_TRIPLET` environment variable to `x64-freebsd`.<br/>
Set the `VCPKG` environment variable to `/opt/vcpkg/scripts/buildsystems/vcpkg.cmake`.<br/>
Add `/opt/vcpkg/bin` to the `PATH` environment variable.

```sh
git clone https://github.com/Microsoft/vcpkg /opt/vcpkg
mkdir /opt/vcpkg/bin && cd /opt/vcpkg/bin
cmake -GNinja -DCMAKE_BUILD_TYPE=Release ../toolsrc \
  -DCMAKE_C_COMPILER=`which clang-devel | which clang` \
  -DCMAKE_CXX_COMPILER=`which clang++-devel | which clang++`
cmake --build .
cat > ../triplets/x64-freebsd.cmake <<EOF
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME FreeBSD)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "\${CMAKE_CURRENT_LIST_DIR}/toolchains/freebsd-toolchain.cmake")
EOF
mkdir ../triplets/toolchains
cat > ../triplets/toolchains/freebsd-toolchain.cmake <<EOF
set(CMAKE_CROSSCOMPILING FALSE)
set(CMAKE_SYSTEM_NAME FreeBSD CACHE STRING "")
set(CMAKE_C_COMPILER `which clang-devel | which clang` CACHE STRING "")
set(CMAKE_CXX_COMPILER `which clang++-devel | which clang++` CACHE STRING "")
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -stdlib=libc++")
EOF
find ../ports -type f -exec sed -i '' -E 's/unofficial(-|::)?//g' '{}' ';'
```

### Ports
Install Vcpkg ports.

```sh
# Head
vcpkg install asio benchmark --head

# C++ (skip wtl on unix systems)
vcpkg install date fmt gtest jsoncpp utfcpp utfz wtl

# Compression
vcpkg install bzip2 liblzma zlib

# Networking
vcpkg install cpr curl libssh2 openssl

# Images and Fonts
vcpkg install freetype harfbuzz libjpeg-turbo libpng

# Misc
vcpkg install podofo
```

**NOTE**: Do not execute `vcpkg` in `cmd.exe` and `bash.exe` at the same time!

<!--
## Build
Execute [solution.cmd](solution.cmd) to configure the project with cmake and open it in Visual Studio.<br/>
Execute `make run`, `make test` or `make benchmark` in the project directory on Unix systems.

## Usage
```cmake
### Benchmark
find_package(benchmark REQUIRED)
target_link_libraries(main PRIVATE benchmark::benchmark)

# C++
find_package(date REQUIRED)
target_link_libraries(main PRIVATE date::tz date::date)

find_package(fmt REQUIRED)
target_link_libraries(main PRIVATE fmt::fmt fmt::fmt-header-only)

find_package(GTest)
option(BUILD_TESTING "Build tests." ${GTEST_FOUND})
if(BUILD_TESTING)
  enable_testing()
  include(GoogleTest)
  file(GLOB tests_sources tests/*.h tests/*.cpp)
  source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR}/src PREFIX src FILES ${tests_sources})
  add_executable(tests ${tests_sources})
  target_include_directories(tests PRIVATE ${CMAKE_CURRENT_BINARY_DIR} src)
  target_link_libraries(tests PRIVATE GTest::GTest GTest::Main)
  gtest_add_tests(TARGET tests WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endif()

find_package(jsoncpp REQUIRED)
target_link_libraries(main PRIVATE jsoncpp_lib_static)

# Compression
find_package(BZip2 REQUIRED)
target_link_libraries(main PRIVATE BZip2::BZip2)

find_package(LibLZMA REQUIRED)
target_include_directories(main PRIVATE ${LIBLZMA_INCLUDE_DIRS})
target_link_libraries(main PRIVATE ${LIBLZMA_LIBRARIES})

find_package(ZLIB REQUIRED)
target_link_libraries(main PRIVATE ZLIB::ZLIB)

# Networking
find_package(CURL REQUIRED)
target_link_libraries(main PRIVATE ${CURL_LIBRARIES})
target_include_directories(main PRIVATE ${CURL_INCLUDE_DIRS})

find_package(libssh2 REQUIRED)
target_link_libraries(main PRIVATE Libssh2::libssh2)

find_package(OpenSSL REQUIRED)
target_link_libraries(main PRIVATE OpenSSL::SSL OpenSSL::Crypto)

# Images and Fonts
find_package(Freetype REQUIRED)
target_link_libraries(main PRIVATE Freetype::Freetype)

find_package(JPEG REQUIRED)
target_link_libraries(main PRIVATE ${JPEG_LIBRARIES})
target_include_directories(main PRIVATE ${JPEG_INCLUDE_DIR})

find_package(PNG REQUIRED)
target_link_libraries(main PRIVATE PNG::PNG)
```
-->
