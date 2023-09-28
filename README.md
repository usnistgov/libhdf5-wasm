# libhdf5-wasm
A precompiled static hdf5 library in webassembly (Emscripten)

Support for GZIP and SZIP compression (through libz and libsz) are included.

## Building
### Prerequisites
 * Emscripten
 * CMake >= 3.10
 * make

### Build
* clone this repository
* activate emscripten (`emcc` and `emcmake`)
* alter `CMakeLists.txt` with whatever flags and options you want
* run `make all` to build all supported versions of hdf5, currently:
  * 1.10.10
  * 1.12.2
  * 1.14.2
* this will create gzipped tarballs of all chosen versions e.g. HDF5-1.12.2-Emscripten.tar.gz
# Using prebuilt artifacts
Prebuilt CMake TGZ packages are attached to the releases of this repository.  In e.g. HDF5-1.12.1-Emscripten.tar.gz you will find a directory structure like this: `HDF5-1.12.2-Emscripten/HDF_Group/HDF5/1.12.2/` in which are: 
 * `share/COPYING` license for HDF5
 * the `include` folder for building against these libraries
 * `lib/libhdf5.a`
 * `lib/libhdf5_hl.a`
 * `lib/libhdf5_cpp.a`
 * `lib/libhdf5_hl_cpp.a`
 * `cmake/hdf5-config.txt` (enables FetchContent, see below)

## Tools: 
You'll also find in the same directory as `lib` and `include` above, some tools that use the webassembly library,
e.g. 
 * `bin/h5dump`
 * `bin/h5repack`

These require that you have nodejs >= 16 installed and on your path (they use `#!/usr/bin/env -S node` shebang to invoke nodejs).  _They do not depend on any installed HDF5 libraries, and are statically linked_

## Using CMake FetchContent
To pull in automatically for use with CMake, see example below. This functionality is provided based on contributions from [@LTLA](https://github.com/LTLA) (thanks!)

### Defined CMake IMPORTED targets:
 - hdf5-static
 - hdf5_hl-static
 - hdf5_cpp-static
 - hdf5_hl_cpp-static

```cmake
# CMakeLists.txt:
cmake_minimum_required(VERSION 3.10)
include(FetchContent)

project(libhdf5-test
    VERSION 1.0.0
    DESCRIPTION "test the availability of libhdf5"
    LANGUAGES CXX C
)

FetchContent_Declare(
  libhdf5-wasm
  URL https://github.com/usnistgov/libhdf5-wasm/releases/download/v0.4.0_3.1.43/HDF5-1.12.2-Emscripten.tar.gz
  # URL_HASH SHA256=7089f9bf29dc3759d7aa77848cfa12d546eabd152d40dd00a90aace99c056600
)
FetchContent_MakeAvailable(libhdf5-wasm)
set(HDF5_DIR ${libhdf5-wasm_SOURCE_DIR}/HDF_Group/HDF5/1.12.2/cmake)
find_package(HDF5 REQUIRED CONFIG)

# build a project using only C headers (libhdf5.a, libhdf5_hl.a):
# add_executable(test test.cpp)
# target_link_libraries(test hdf5-static hdf5_hl-static)

# build a project using C++ headers 
# (C headers + libhdf5_cpp.a, libhdf5_hl_cpp.a):
add_executable(test_cpp test_cpp.cpp)
target_link_libraries(test_cpp hdf5_hl_cpp-static hdf5_cpp-static)

# Optional flags to set when building your project
set_target_properties(test_cpp PROPERTIES
    LINK_FLAGS "--bind -s ALLOW_MEMORY_GROWTH=1 -s USE_ZLIB=1 -s FORCE_FILESYSTEM=1 -s 'EXPORTED_RUNTIME_METHODS=[\"FS\"]'"
)
```
