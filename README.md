# libhdf5-wasm

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
  * 1.10.8
  * 1.12.1
  * 1.13.0
* run `make release` to create gzipped tarballs of all versions e.g. libhdf5-1_12_1-wasm.tar.gz
# Using prebuilt artifacts
Prebuilt WASM libraries are attached to the releases of this repository.  In e.g. libhdf5-1_12_1-wasm.tar.gz you will find (among other things): 
 * `share/COPYING` license for HDF5
 * the `include` folder for building against these libraries
 * `lib/libhdf5.a`
 * `lib/libhdf5_hl.a`
 * `lib/libhdf5_cpp.a`
 * `lib/libhdf5_hl_cpp.a`
 * `CMakeLists.txt` (enables FetchContent, see below)
 
## Using CMake FetchContent
To pull in automatically for use with CMake, see example below (libraries provided are `hdf5-wasm` and `hdf5-wasm-cpp`).  This functionality is provided based on contributions from [@LTLA](https://github.com/LTLA) (thanks!)

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
  URL https://github.com/usnistgov/libhdf5-wasm/releases/download/v0.1.0/libhdf5-1_12_1-wasm.tar.gz
  URL_HASH SHA256=ea3b35122465e1d0b526788b47a3be9c90e27e19ab35e62788886a755088e253
)
FetchContent_MakeAvailable(libhdf5-wasm)

# build a project using only C headers (libhdf5.a, libhdf5_hl.a):
# add_executable(test test.cpp)
# target_link_libraries(test hdf5-wasm)

# build a project using C++ headers 
# (C headers + libhdf5_cpp.a, libhdf5_hl_cpp.a):
add_executable(test_cpp test_cpp.cpp)
target_link_libraries(test_cpp hdf5-wasm-cpp)

# Optional flags to set when building your project
set_target_properties(test_cpp PROPERTIES
    LINK_FLAGS "--bind -s ALLOW_MEMORY_GROWTH=1 -s USE_ZLIB=1 -s FORCE_FILESYSTEM=1 -s 'EXPORTED_RUNTIME_METHODS=[\"FS\"]'"
)
```
