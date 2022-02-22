# libhdf5-wasm
Build artifacts for libhdf5 (wasm) using Emscripten

in libhdf5-wasm.tar file attached to releases, you can find the `include` folder as well as
 * `lib/libhdf5.a`
 * `lib/libhdf5_hl.a`
 * `lib/libhdf5_cpp.a`
 * `lib/libhdf5_hl_cpp.a`
 
To pull in automatically for use with CMake, see e.g.
```cmake
cmake_minimum_required(VERSION 3.10)
include(FetchContent)

project(libhdf5-test
    VERSION 1.0.0
    DESCRIPTION "test the availability of libhdf5"
    LANGUAGES CXX C
)

FetchContent_Declare(
  libhdf5-wasm
  URL https://github.com/bmaranville/libhdf5-wasm/releases/download/v0.1.0/libhdf5-wasm.tar
  URL_HASH SHA256=9d3c5b1cb00a4f85858870631d444318c0ab0457d930e8f852c14a010b5016a9
)
FetchContent_MakeAvailable(libhdf5-wasm)

add_executable(test test.cpp)

target_link_libraries(test hdf5-wasm-cpp)

set_target_properties(test PROPERTIES
    LINK_FLAGS "--bind -s ALLOW_MEMORY_GROWTH=1 -s USE_ZLIB=1 -s FORCE_FILESYSTEM=1 -s 'EXPORTED_RUNTIME_METHODS=[\"FS\"]'"
)
```
