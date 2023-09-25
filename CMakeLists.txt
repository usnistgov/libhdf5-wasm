cmake_minimum_required(VERSION 3.24)
include(FetchContent)

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sFORCE_FILESYSTEM=1" CACHE INTERNAL "")
set(HDF5_VERSION "1_12_2" CACHE STRING "HDF5 version to build")

set(SRC_HASH_1_12_2 1ca14cadff7bc4b61826eee591da1a330f44c107db66c9510ee95df3b2bc5f78)
set(SRC_HASH_1_14_2 83eaee3f9d1790bb4b29368bf1a648ece763097a4122c80a81076e8fb1e890e6)
set(SRC_HASH_1_10_10 563940efec30ec027108bc425f45488ce98d356798bdf743441e574c2d52dd54)

FetchContent_Declare(
  hdf5
  URL https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-${HDF5_VERSION}.tar.gz
  URL_HASH SHA256=${SRC_HASH_${HDF5_VERSION}}
)
FetchContent_Populate(hdf5)

FetchContent_Declare(
  zlib
  # URL http://www.zlib.net/zlib-1.3.tar.gz
  URL http://zlib.net/fossils/zlib-1.3.tar.gz
  URL_HASH  SHA256=ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e
  OVERRIDE_FIND_PACKAGE
)
FetchContent_Populate(zlib)

# add global included path because zlib not set up to be subproject
include_directories(${zlib_SOURCE_DIR})
add_subdirectory(${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})

set(ZLIB_INCLUDE_DIR ${zlib_SOURCE_DIR})
set(ZLIB_LIBRARY ${zlib_BINARY_DIR}/libz.a)

FetchContent_Declare(
  libaec
  GIT_REPOSITORY https://gitlab.dkrz.de/k202009/libaec
  GIT_TAG v1.0.6
  OVERRIDE_FIND_PACKAGE
)
set(libaec_USE_STATIC_LIBS ON)
FetchContent_MakeAvailable(libaec)

set (USE_LIBAEC ON CACHE BOOL "Use libaec szip replacement" FORCE)
set(SZIP_INCLUDE_DIR ${libaec_SOURCE_DIR}/include)
set(SZIP_LIBRARY ${libaec_BINARY_DIR}/src/libsz.a)
set(SZIP_DIR ${libaec_BINARY_DIR}/src)

# set the project name
project(libhdf5-wasm-build)

option(BUILD_SHARED_LIBS "Build shared libs" OFF)
option(HDF5_BUILD_EXAMPLES "Build Examples" OFF)
option(HDF5_BUILD_TOOLS "Build Tools" OFF)
option(HDF5_BUILD_UTILS "Build Utils" OFF)
option(HDF5_BUILD_CPP_LIB "Build CPP libraries" ON)
option(HDF5_ENABLE_Z_LIB_SUPPORT "Enable ZLIB" ON)
option(HDF5_ENABLE_SZIP_SUPPORT "Enable SZIP" ON)
option(SZIP_USE_EXTERNAL "needs to be off" OFF)

# option(HDF5_ALLOW_EXTERNAL_SUPPORT "use TGZ" "TGZ")
# option(SZIP_GIT_URL "where to get szip" "https://gitlab.dkrz.de/k202009/libaec")

set (BUILD_TESTING OFF CACHE BOOL "Do not build tests by default" FORCE)
set(H5_HAVE_GETPWUID OFF)
set(H5_HAVE_SIGNAL OFF)

set(CMAKE_BUILD_TYPE RELEASE)
set(CMAKE_INSTALL_PREFIX hdf5)

add_subdirectory(${hdf5_SOURCE_DIR} ${hdf5_BINARY_DIR})