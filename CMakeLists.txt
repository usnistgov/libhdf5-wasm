cmake_minimum_required(VERSION 3.10)
include(FetchContent)

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sUSE_ZLIB=1 -sFORCE_FILESYSTEM=1" CACHE INTERNAL "")
set(HDF5_VERSION "1_12_2" CACHE STRING "HDF5 version to build")

set(SRC_HASH_1_12_2 1ca14cadff7bc4b61826eee591da1a330f44c107db66c9510ee95df3b2bc5f78)
set(SRC_HASH_1_14_1 1f710f3846d9c3ef9a4c57ef252ee0570f0af4e028fd6ccc360a48b7b16c347d)
set(SRC_HASH_1_10_10 563940efec30ec027108bc425f45488ce98d356798bdf743441e574c2d52dd54)

FetchContent_Declare(
  hdf5
  URL https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-${HDF5_VERSION}.tar.gz
  URL_HASH SHA256=${SRC_HASH_${HDF5_VERSION}}
)
FetchContent_Populate(hdf5)

# set the project name
project(libhdf5-wasm-build)

option(BUILD_SHARED_LIBS "Build shared libs" ON)
option(HDF5_BUILD_EXAMPLES "Build Examples" OFF)
option(HDF5_BUILD_TOOLS "Build Tools" OFF)
option(HDF5_BUILD_UTILS "Build Utils" OFF)
option(BUILD_TESTING "Build Tests" OFF)
option(HDF5_BUILD_CPP_LIB "Build CPP libraries" ON)
option(HDF5_ENABLE_Z_LIB_SUPPORT "Enable ZLIB" ON)

set(CMAKE_INSTALL_PREFIX hdf5)
set(H5_HAVE_GETPWUID OFF)
set(H5_HAVE_SIGNAL OFF)

add_subdirectory(${hdf5_SOURCE_DIR})