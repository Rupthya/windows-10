# VCPKG
Vcpkg installation instructions.

## Requirements
* [CMake](https://cmake.org/download/) version 3.11.3 on all platforms
* [LLVM](https://llvm.org/) and [libcxx](https://libcxx.llvm.org/) version 7.0 on Linux and FreeBSD
* [Visual Studio 2017](https://www.visualstudio.com/downloads/) version 15.7 on Windows
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
set(CMAKE_SYSTEM_NAME `uname -s` CACHE STRING "")
set(CMAKE_CROSSCOMPILING OFF CACHE STRING "")
set(CMAKE_C_COMPILER "`which clang-devel || which clang`" CACHE STRING "")
set(CMAKE_CXX_COMPILER "`which clang++-devel || which clang++`" CACHE STRING "")
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -stdlib=libc++" CACHE STRING "")
set(HAVE_STEADY_CLOCK ON CACHE STRING "")
set(HAVE_STD_REGEX ON CACHE STRING "")
EOF
cd && rm -rf ${VCPKG}/toolsrc/build.rel
```

## Ports
Install Vcpkg ports.

```sh
vcpkg install bzip2 date fmt liblzma libssh2 nlohmann-json openssl wtl zlib
vcpkg install boost-beast boost-serialization
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
find_path(JSON_INCLUDE_DIR nlohmann/json.hpp)
target_include_directories(${PROJECT_NAME} PRIVATE ${JSON_INCLUDE_DIR})

# =============================================================================

find_package(BZip2 1.0.6 REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE BZip2::BZip2)

find_package(unofficial-date CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE unofficial::date::tz unofficial::date::date)

find_package(fmt 4.1.0 CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt fmt::fmt-header-only)

find_package(LibLZMA 5.2.3 REQUIRED)
target_include_directories(${PROJECT_NAME} PRIVATE ${LIBLZMA_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${LIBLZMA_LIBRARIES})

find_package(Libssh2 1.8.0 CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE Libssh2::libssh2)

find_package(OpenSSL 1.0.2 REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE OpenSSL::SSL OpenSSL::Crypto)

find_package(ZLIB 1.2.11 REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE ZLIB::ZLIB)

# =============================================================================

find_package(Boost 1.67.0 REQUIRED COMPONENTS system)
target_link_libraries(${PROJECT_NAME} PRIVATE Boost::system)

# =============================================================================

include(res/cotire.cmake)
set_target_properties(${PROJECT_NAME} PROPERTIES COTIRE_CXX_PREFIX_HEADER_INIT "src/common.h")
set_target_properties(${PROJECT_NAME} PROPERTIES COTIRE_ADD_UNITY_BUILD OFF)
cotire(${PROJECT_NAME})

# =============================================================================

find_package(benchmark CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE benchmark::benchmark)

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

```
