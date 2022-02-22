cmake_minimum_required(VERSION 3.10)
include(FetchContent)

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sUSE_ZLIB=1" CACHE INTERNAL "")

FetchContent_Declare(
  hdf5
  URL https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_12_1.tar.gz
  URL_HASH SHA256=e6dde173c2d243551922d23a0387a79961205b018502e6a742acb30b61bc2d5f
#   SOURCE_DIR libhdf5
)
FetchContent_Populate(hdf5)

# set the project name
project(hdf5-wasm)

option(BUILD_SHARED_LIBS "Build shared libs" OFF)
option(HDF5_BUILD_EXAMPLES "Build Examples" OFF)
option(HDF5_BUILD_TOOLS "Build Tools" OFF)
option(HDF5_BUILD_UTILS "Build Utils" OFF)
option(BUILD_TESTING "Build Tests" OFF)
option(HDF5_BUILD_CPP_LIB "Build CPP libraries" ON)
option(HDF5_ENABLE_Z_LIB_SUPPORT "Enable ZLIB" ON)

set(LIBHDF5_PATH ${CMAKE_CURRENT_SOURCE_DIR}/libhdf5)
set(CMAKE_INSTALL_PREFIX ${LIBHDF5_PATH})
set(H5_HAVE_GETPWUID OFF)
set(H5_HAVE_SIGNAL OFF)

add_subdirectory(${hdf5_SOURCE_DIR})

add_library(hdf5-wasm INTERFACE)
target_include_directories(hdf5-wasm INTERFACE include)
target_link_options(hdf5-wasm INTERFACE ${LIBHDF5_PATH}/lib/libhdf5.a ${LIBHDF5_PATH}/lib/libhdf5_hl.a)

add_library(hdf5-wasm-cpp INTERFACE)
target_include_directories(hdf5-wasm-cpp INTERFACE include)
target_link_libraries(hdf5-wasm-cpp INTERFACE hdf5-wasm)
target_link_options(hdf5-wasm-cpp INTERFACE ${LIBHDF5_PATH}/lib/libhdf5_cpp.a ${LIBHDF5_PATH}/lib/libhdf5_hl_cpp.a)