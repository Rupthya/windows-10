# VCPKG
Vcpkg installation instructions.

## Requirements
* [CMake](https://cmake.org/download/) version 3.11.2 on all platforms
* [LLVM](https://llvm.org/) and [libcxx](https://libcxx.llvm.org/) version 7.0 on Linux and FreeBSD
* [Visual Studio](https://www.visualstudio.com/downloads/) version 15.7 on Windows
* [Vcpkg](https://github.com/Microsoft/vcpkg)

## Dependencies
Set the `VCPKG` and `VCPKG_DEFAULT_TRIPLET` environment variables.

| OS          | VCPKG                    | VCPKG_DEFAULT_TRIPLET   |
|-------------|--------------------------|-------------------------|
| Windows     | `C:\Libraries\vcpkg`     | `x64-windows-static-md` |
| Linux (WSL) | `/mnt/c/Libraries/vcpkg` | `x64-linux-clang`       |
| Linux       | `/opt/vcpkg`             | `x64-linux-clang`       |
| FreeBSD     | `/opt/vcpkg`             | `x64-freebsd-devel`     |

### Windows
Add `%VCPKG%` to the `PATH` environment variable.

```cmd
git clone https://github.com/Microsoft/vcpkg %VCPKG%
cd %VCPKG% && bootstrap-vcpkg.bat && vcpkg integrate install
@echo set(VCPKG_TARGET_ARCHITECTURE x64)> %VCPKG%\triplets\%VCPKG_DEFAULT_TRIPLET%.cmake
@echo set(VCPKG_CRT_LINKAGE dynamic)>>    %VCPKG%\triplets\%VCPKG_DEFAULT_TRIPLET%.cmake
@echo set(VCPKG_LIBRARY_LINKAGE static)>> %VCPKG%\triplets\%VCPKG_DEFAULT_TRIPLET%.cmake
```

### Linux & FreeBSD
Add `${VCPKG}` to the `PATH` environment variable.

```sh
git clone https://github.com/Microsoft/vcpkg ${VCPKG}
rm -rf ${VCPKG}/toolsrc/build.rel; mkdir ${VCPKG}/toolsrc/build.rel && cd ${VCPKG}/toolsrc/build.rel
cmake -GNinja -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_C_COMPILER=`which clang-devel || which clang` \
  -DCMAKE_CXX_COMPILER=`which clang++-devel || which clang++` \
  -DCMAKE_CXX_FLAGS="-stdlib=libc++" ..
cmake --build . && cp vcpkg ${VCPKG}/
cat > ${VCPKG}/triplets/${VCPKG_DEFAULT_TRIPLET}.cmake <<EOF
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME `uname -s`)
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "\${CMAKE_CURRENT_LIST_DIR}/toolchains/${VCPKG_DEFAULT_TRIPLET}.cmake")
EOF
mkdir ${VCPKG}/triplets/toolchains
cat > ${VCPKG}/triplets/toolchains/${VCPKG_DEFAULT_TRIPLET}.cmake <<EOF
set(CMAKE_CROSSCOMPILING FALSE)
set(CMAKE_SYSTEM_NAME `uname -s` CACHE STRING "")
set(CMAKE_C_COMPILER `which clang-devel || which clang` CACHE STRING "")
set(CMAKE_CXX_COMPILER `which clang++-devel || which clang++` CACHE STRING "")
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -stdlib=libc++")
set(HAVE_STEADY_CLOCK ON)
set(HAVE_STD_REGEX ON)
EOF
```

Optional: Fix unofficial namespace names.

```sh
test `uname -s` = "FreeBSD" && \
  find ${VCPKG}/ports -type f -exec sed -i '' -E 's/unofficial(-|::)?//g' '{}' ';' || \
  find ${VCPKG}/ports -type f -exec sed -i    -E 's/unofficial(-|::)?//g' '{}' ';'
```

## Ports
Install Vcpkg ports.

```sh
vcpkg install benchmark bzip2 date fmt liblzma libssh2 gtest openssl wtl zlib
```

**NOTE**: Do not execute `vcpkg` in `cmd.exe` and `bash.exe` at the same time!

## Usage
Configure CMake projects with the following options on Windows:

```sh
-DCMAKE_TOOLCHAIN_FILE:PATH=%VCPKG%/scripts/buildsystems/vcpkg.cmake
-DVCPKG_TARGET_TRIPLET:PATH=%VCPKG_DEFAULT_TRIPLET%
```

Configure CMake projects with the following options on Linux and FreeBSD:

```sh
-DCMAKE_TOOLCHAIN_FILE:PATH=${VCPKG}/scripts/buildsystems/vcpkg.cmake
-DVCPKG_TARGET_TRIPLET:PATH=${VCPKG_DEFAULT_TRIPLET}
```

<!--
find_package(benchmark REQUIRED)
target_link_libraries(main PRIVATE benchmark::benchmark)

find_package(BZip2 REQUIRED)
target_link_libraries(main PRIVATE BZip2::BZip2)

find_package(date REQUIRED)
target_link_libraries(main PRIVATE date::tz date::date)

find_package(fmt REQUIRED)
target_link_libraries(main PRIVATE fmt::fmt fmt::fmt-header-only)

find_package(LibLZMA REQUIRED)
target_include_directories(main PRIVATE ${LIBLZMA_INCLUDE_DIRS})
target_link_libraries(main PRIVATE ${LIBLZMA_LIBRARIES})

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

find_package(OpenSSL REQUIRED)
target_link_libraries(main PRIVATE OpenSSL::SSL OpenSSL::Crypto)

find_package(libssh2 REQUIRED)
target_link_libraries(main PRIVATE Libssh2::libssh2)

find_package(ZLIB REQUIRED)
target_link_libraries(main PRIVATE ZLIB::ZLIB)
-->
