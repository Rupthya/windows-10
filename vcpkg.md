# VCPKG
Project description.

## Requirements
* [CMake](https://cmake.org/download/) version 3.10
* [LLVM](https://llvm.org/) and [libcxx](https://libcxx.llvm.org/) version 6.0.0 on Linux and FreeBSD
* [Visual Studio](https://www.visualstudio.com/downloads/) version 15.7 on Windows
* [Vcpkg](https://github.com/Microsoft/vcpkg)

## Dependencies
Install Vcpkg using the following instructions. Adjust the commands as necessary or desired.

### Windows
Set the `VCPKG_DEFAULT_TRIPLET` environment variable to `x64-windows-static-md`.<br/>
Set the `VCPKG` environment variable to `C:/Libraries/vcpkg/scripts/buildsystems/vcpkg.cmake`.<br/>
Add `C:\Libraries\vcpkg\installed\%VCPKG_DEFAULT_TRIPLET%\bin` to the `PATH` environment variable.<br/>
Add `C:\Libraries\vcpkg` to the `PATH` environment variable.

```cmd
git clone https://github.com/Microsoft/vcpkg C:\Libraries\vcpkg
```

Create a new triplet in `C:\Libraries\vcpkg\triplets\x64-windows-static-md.cmake`.

```cmake
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
```

```cmd
cd C:\Libraries\vcpkg && bootstrap-vcpkg.bat && vcpkg integrate install
```

### Linux
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
sed -i -E 's/unofficial(-|::)?//g' ../ports/date/{CMakeLists.txt,portfile.cmake}
sed -i 's/1\.3\.0/1.4.0/' ../ports/benchmark/{CONTROL,portfile.cmake}
sed -i 's/SHA512 2.*/SHA512 4bb5119fe6c0558e5a8b39486169ffcbf24e877ec7f28636dfab1692936b77334f76d28bda2cdada18e5070579da7a5bf0617bfbb6a09848f0b071df8e694d76/' \
  ../ports/benchmark/portfile.cmake
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
sed -i '' -E 's/unofficial(-|::)?//g' ../ports/date/{CMakeLists.txt,portfile.cmake}
sed -i '' 's/1\.3\.0/1.4.0/' ../ports/benchmark/{CONTROL,portfile.cmake}
sed -i '' 's/SHA512 2.*/SHA512 4bb5119fe6c0558e5a8b39486169ffcbf24e877ec7f28636dfab1692936b77334f76d28bda2cdada18e5070579da7a5bf0617bfbb6a09848f0b071df8e694d76/' \
  ../ports/benchmark/portfile.cmake
```

### Ports
Install Vcpkg ports.

```
vcpkg install asio benchmark bzip2 curl date fmt freetype gtest libjpeg-turbo libpng libssh libssh2 openssl zlib
```

**NOTE**: Do not execute `vcpkg` in `cmd.exe` and `bash.exe` at the same time!<br/>
**NOTE**: Make sure [perl](http://strawberryperl.com) is available before installing the OpenSSL port.

## Build
Execute [solution.cmd](solution.cmd) to configure the project with cmake and open it in Visual Studio.<br/>
Execute `make run`, `make test` or `make benchmark` in the project directory on Unix systems.

<!--
## Usage
```cmake
find_package(benchmark REQUIRED)
target_link_libraries(main PRIVATE benchmark::benchmark)

find_package(BZip2 REQUIRED)
target_link_libraries(main PRIVATE BZip2::BZip2)

find_package(CURL REQUIRED)
target_link_libraries(main PRIVATE ${CURL_LIBRARIES})
target_include_directories(main PRIVATE ${CURL_INCLUDE_DIRS})

find_package(date REQUIRED)
target_link_libraries(main PRIVATE date::tz date::date)

find_package(fmt REQUIRED)
target_link_libraries(main PRIVATE fmt::fmt fmt::fmt-header-only)

find_package(Freetype REQUIRED)
target_link_libraries(main PRIVATE Freetype::Freetype)

find_package(JPEG REQUIRED)
target_link_libraries(main PRIVATE ${JPEG_LIBRARIES})
target_include_directories(main PRIVATE ${JPEG_INCLUDE_DIR})

find_package(libssh2 REQUIRED)
target_link_libraries(main PRIVATE Libssh2::libssh2)

find_package(OpenSSL REQUIRED)
target_link_libraries(main PRIVATE OpenSSL::SSL OpenSSL::Crypto)

find_package(PNG REQUIRED)
target_link_libraries(main PRIVATE PNG::PNG)

find_package(ZLIB REQUIRED)
target_link_libraries(main PRIVATE ZLIB::ZLIB)
```

```cmake
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

## cmake/FindLibSSH.cmake
```cmake
find_path(LIBSSH_INCLUDE_DIR libssh.h PATH_SUFFIXES libssh)
find_library(LIBSSH_LIBRARY NAMES ssh libssh)

if(LIBSSH_INCLUDE_DIR)
  file(STRINGS "${LIBSSH_INCLUDE_DIR}/libssh.h" libssh_version_str REGEX
    "^#define[\t ]+LIBSSH_VERSION_(MAJOR|MINOR|MICRO)[\t ]+.*")

  string(REGEX REPLACE "^.*LIBSSH_VERSION_MAJOR[\t ]+([0-9]+).*$" "\\1" LIBSSH_VERSION_MAJOR "${libssh_version_str}")
  string(REGEX REPLACE "^.*LIBSSH_VERSION_MINOR[\t ]+([0-9]+).*$" "\\1" LIBSSH_VERSION_MINOR "${libssh_version_str}")
  string(REGEX REPLACE "^.*LIBSSH_VERSION_MICRO[\t ]+([0-9]+).*$" "\\1" LIBSSH_VERSION_PATCH "${libssh_version_str}")

  string(REGEX REPLACE "^0(.+)" "\\1" LIBSSH_VERSION_MAJOR "${LIBSSH_VERSION_MAJOR}")
  string(REGEX REPLACE "^0(.+)" "\\1" LIBSSH_VERSION_MINOR "${LIBSSH_VERSION_MINOR}")
  string(REGEX REPLACE "^0(.+)" "\\1" LIBSSH_VERSION_PATCH "${LIBSSH_VERSION_PATCH}")

  set(LIBSSH_VERSION "${LIBSSH_VERSION_MAJOR}.${LIBSSH_VERSION_MINOR}.${LIBSSH_VERSION_PATCH}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibSSH DEFAULT_MSG LIBSSH_INCLUDE_DIR LIBSSH_LIBRARY)

mark_as_advanced(
  LIBSSH_INCLUDE_DIR
  LIBSSH_LIBRARY
  LIBSSH_VERSION_MAJOR
  LIBSSH_VERSION_MINOR
  LIBSSH_VERSION_PATCH
  LIBSSH_VERSION)

if(LIBSSH_FOUND)
  find_package(ZLIB REQUIRED)
  find_package(OpenSSL REQUIRED)
  add_library(LibSSH::LibSSH UNKNOWN IMPORTED)
  set_target_properties(LibSSH::LibSSH PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${LIBSSH_INCLUDE_DIR}"
    IMPORTED_LOCATION "${LIBSSH_LIBRARY}"
    IMPORTED_LINK_INTERFACE_LIBRARIES "ZLIB::ZLIB;OpenSSL::SSL;OpenSSL::Crypto"
    IMPORTED_LINK_INTERFACE_LANGUAGES "C")
endif()
```

```cmake
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
find_package(LibSSH REQUIRED)
target_link_libraries(${PROJECT_NAME} PUBLIC LibSSH::LibSSH)
```

## cmake/FindLibSSH2.cmake
```cmake
find_path(LIBSSH2_INCLUDE_DIR libssh2.h)
find_library(LIBSSH2_LIBRARY NAMES ssh2 libssh2)

if(LIBSSH2_INCLUDE_DIR)
  file(STRINGS "${LIBSSH2_INCLUDE_DIR}/libssh2.h" libssh2_version_str REGEX
    "^#define[\t ]+LIBSSH2_VERSION_NUM[\t ]+0x[0-9][0-9][0-9][0-9][0-9][0-9].*")

  string(REGEX REPLACE "^.*LIBSSH2_VERSION_NUM[\t ]+0x([0-9][0-9]).*$" "\\1"
    LIBSSH2_VERSION_MAJOR "${libssh2_version_str}")
  string(REGEX REPLACE "^.*LIBSSH2_VERSION_NUM[\t ]+0x[0-9][0-9]([0-9][0-9]).*$" "\\1"
    LIBSSH2_VERSION_MINOR  "${libssh2_version_str}")
  string(REGEX REPLACE "^.*LIBSSH2_VERSION_NUM[\t ]+0x[0-9][0-9][0-9][0-9]([0-9][0-9]).*$" "\\1"
    LIBSSH2_VERSION_PATCH "${libssh2_version_str}")

  string(REGEX REPLACE "^0(.+)" "\\1" LIBSSH2_VERSION_MAJOR "${LIBSSH2_VERSION_MAJOR}")
  string(REGEX REPLACE "^0(.+)" "\\1" LIBSSH2_VERSION_MINOR "${LIBSSH2_VERSION_MINOR}")
  string(REGEX REPLACE "^0(.+)" "\\1" LIBSSH2_VERSION_PATCH "${LIBSSH2_VERSION_PATCH}")

  set(LIBSSH2_VERSION "${LIBSSH2_VERSION_MAJOR}.${LIBSSH2_VERSION_MINOR}.${LIBSSH2_VERSION_PATCH}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibSSH2 DEFAULT_MSG LIBSSH2_INCLUDE_DIR LIBSSH2_LIBRARY)

mark_as_advanced(
  LIBSSH2_INCLUDE_DIR
  LIBSSH2_LIBRARY
  LIBSSH2_VERSION_MAJOR
  LIBSSH2_VERSION_MINOR
  LIBSSH2_VERSION_PATCH
  LIBSSH2_VERSION)

if(LIBSSH2_FOUND)
  find_package(ZLIB REQUIRED)
  find_package(OpenSSL REQUIRED)
  add_library(LibSSH2::LibSSH2 UNKNOWN IMPORTED)
  set_target_properties(LibSSH2::LibSSH2 PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${LIBSSH2_INCLUDE_DIR}"
    IMPORTED_LOCATION "${LIBSSH2_LIBRARY}"
    IMPORTED_LINK_INTERFACE_LIBRARIES "ZLIB::ZLIB;OpenSSL::SSL;OpenSSL::Crypto"
    IMPORTED_LINK_INTERFACE_LANGUAGES "C")
endif()
```

```cmake
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
find_package(LibSSH2 REQUIRED)
target_link_libraries(${PROJECT_NAME} PUBLIC LibSSH2::LibSSH2)
```
-->
