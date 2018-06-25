# VCPKG
Vcpkg installation instructions.

## Requirements
* [CMake](https://cmake.org/download/) version 3.12 on all platforms
* [LLVM](https://llvm.org/) and [libcxx](https://libcxx.llvm.org/) version 7.0 on Linux and FreeBSD
* [Visual Studio 2017](https://www.visualstudio.com/downloads/) version 15.7 on Windows
* [Vcpkg](https://github.com/Microsoft/vcpkg)

## Dependencies
Set the `VCPKG` and `VCPKG_DEFAULT_TRIPLET` environment variables.

| OS          | VCPKG                    | VCPKG_DEFAULT_TRIPLET |
|-------------|--------------------------|-----------------------|
| Windows     | `C:\Libraries\vcpkg`     | `x64-windows-static`  |
| Linux (WSL) | `/mnt/c/Libraries/vcpkg` | `x64-linux-clang`     |
| Linux       | `/opt/vcpkg`             | `x64-linux-clang`     |
| FreeBSD     | `/opt/vcpkg`             | `x64-freebsd-devel`   |

### Windows
Add `%VCPKG%` to the `PATH` environment variable.

```cmd
git clone https://github.com/Microsoft/vcpkg %VCPKG%
cd %VCPKG% && bootstrap-vcpkg.bat && vcpkg integrate install
cd %UserProfile% && rd /q /s "%VCPKG%/toolsrc/Release" "%VCPKG%/toolsrc/vcpkg/Release" ^
  "%VCPKG%/toolsrc/vcpkglib/Release" "%VCPKG%/toolsrc/vcpkgmetricsuploader/Release"
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
set(CMAKE_CROSSCOMPILING OFF CACHE STRING "")
set(CMAKE_SYSTEM_NAME `uname -s` CACHE STRING "")
set(CMAKE_C_COMPILER "`which clang-devel || which clang`" CACHE STRING "")
set(CMAKE_CXX_COMPILER "`which clang++-devel || which clang++`" CACHE STRING "")
set(HAVE_STEADY_CLOCK ON CACHE STRING "")
set(HAVE_STD_REGEX ON CACHE STRING "")
EOF
cd && rm -rf ${VCPKG}/toolsrc/build.rel
```

## Ports
Install Vcpkg ports.

```sh
vcpkg install bzip2 date fmt libjpeg-turbo liblzma libpng libssh2 nlohmann-json openssl wtl zlib
vcpkg install boost-asio boost-beast boost-serialization
vcpkg install benchmark gtest
```

**NOTE**: Do not execute `vcpkg` in `cmd.exe` and `bash.exe` at the same time!

## Usage
Configure CMake projects with the following options on Windows:

```sh
cmake -G "Visual Studio 15 2017 Win64" -DCMAKE_CONFIGURATION_TYPES="Debug;Release" ^
  -DCMAKE_TOOLCHAIN_FILE=%VCPKG%/scripts/buildsystems/vcpkg.cmake ^
  -DVCPKG_TARGET_TRIPLET=%VCPKG_DEFAULT_TRIPLET% ..
```

Configure CMake projects with the following options on Linux and FreeBSD:

```sh
cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_TOOLCHAIN_FILE=${VCPKG}/scripts/buildsystems/vcpkg.cmake \
  -DVCPKG_TARGET_TRIPLET=${VCPKG_DEFAULT_TRIPLET} ..
```

Add the following lines to the `CMakeLists.txt` file (adjust or remove versions):

```cmake
if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  foreach(config ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER CMAKE_CXX_FLAGS_${config} name)
    string(REPLACE "/MD" "/MT" ${name} ${${name}})
  endforeach()
endif()

# =============================================================================

find_package(BZip2 REQUIRED)
target_link_libraries(main PUBLIC BZip2::BZip2)

find_package(unofficial-date CONFIG REQUIRED)
target_link_libraries(main PUBLIC unofficial::date::tz unofficial::date::date)

find_package(fmt CONFIG REQUIRED)
target_link_libraries(main PUBLIC fmt::fmt)  # or fmt::fmt-header-only

find_package(JPEG REQUIRED)
target_link_libraries(main PUBLIC JPEG::JPEG)

find_package(LibLZMA REQUIRED)
target_include_directories(main PUBLIC ${LIBLZMA_INCLUDE_DIRS})
target_link_libraries(main PUBLIC ${LIBLZMA_LIBRARIES})

find_package(PNG REQUIRED)
target_link_libraries(main PUBLIC PNG::PNG)

find_package(Libssh2 CONFIG REQUIRED)
target_link_libraries(main PUBLIC Libssh2::libssh2)

find_path(JSON_INCLUDE_DIR nlohmann/json.hpp)
target_include_directories(main PUBLIC ${JSON_INCLUDE_DIR})

find_package(OpenSSL REQUIRED)
target_link_libraries(main PUBLIC OpenSSL::SSL OpenSSL::Crypto)

find_path(WTL_INCLUDE_DIR wtl/atlapp.h)
target_include_directories(main PUBLIC ${WTL_INCLUDE_DIR})

find_package(ZLIB REQUIRED)
target_link_libraries(main PUBLIC ZLIB::ZLIB)

# =============================================================================

find_package(Boost REQUIRED COMPONENTS system)
target_link_libraries(main PRIVATE Boost::system)

# =============================================================================

if(BUILD_BENCHMARK)
  find_package(benchmark CONFIG REQUIRED)
  file(GLOB sources src/benchmark/*.hpp src/benchmark/*.cpp)
  source_group("" FILES ${sources})
  add_executable(benchmark ${sources})
  target_link_libraries(benchmark PRIVATE benchmark::benchmark_main ${PROJECT_NAME})
  set_target_properties(benchmark PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    add_custom_target(RUN_BENCHMARK COMMAND $<TARGET_FILE:benchmark>
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    set_target_properties(RUN_BENCHMARK PROPERTIES FOLDER "build")
  endif()
endif()

if(BUILD_TESTS)
  enable_testing()
  include(GoogleTest)
  find_package(GTest REQUIRED)
  file(GLOB sources src/tests/*.hpp src/tests/*.cpp)
  source_group("" FILES ${sources})
  add_executable(tests ${sources})
  target_link_libraries(tests PRIVATE GTest::Main ${PROJECT_NAME})
  gtest_add_tests(TARGET tests WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endif()

# =============================================================================

if(WIN32 AND NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/tzdata/windowsZones.xml)
  file(DOWNLOAD "https://unicode.org/repos/cldr/trunk/common/supplemental/windowsZones.xml"
    ${CMAKE_CURRENT_SOURCE_DIR}/tzdata/windowsZones.xml)
endif()
if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/tzdata/version)
  if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/tzdata/tzdata.tar.gz)
    file(DOWNLOAD "https://data.iana.org/time-zones/releases/tzdata2018e.tar.gz"
      ${CMAKE_CURRENT_BINARY_DIR}/tzdata/tzdata.tar.gz)
  endif()
  execute_process(COMMAND ${CMAKE_COMMAND} -E tar xf tzdata.tar.gz
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/tzdata)
  foreach(name africa antarctica asia australasia backward etcetera
      europe leapseconds northamerica pacificnew southamerica systemv version)
    file(COPY ${CMAKE_CURRENT_BINARY_DIR}/tzdata/${name} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/tzdata)
  endforeach()
endif()
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/tzdata DESTINATION bin)
```
