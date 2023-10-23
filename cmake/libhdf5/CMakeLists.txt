cmake_minimum_required(VERSION 3.24)
include(FetchContent)

# get grandparent path
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR PARENT_PATH base_path)
cmake_path(GET base_path PARENT_PATH base_path)

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sFORCE_FILESYSTEM=1 -sSINGLE_FILE=1 --extern-pre-js=${base_path}/shebang.txt" CACHE INTERNAL "")
set(HDF5_VERSION "1.12.2" CACHE STRING "HDF5 version to build")
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "use -fPIC for all libs" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_C "" CACHE STRING "" FORCE)

set(SRC_HASH_1.12.2 1ca14cadff7bc4b61826eee591da1a330f44c107db66c9510ee95df3b2bc5f78)
set(SRC_HASH_1.14.2 83eaee3f9d1790bb4b29368bf1a648ece763097a4122c80a81076e8fb1e890e6)
set(SRC_HASH_1.10.10 563940efec30ec027108bc425f45488ce98d356798bdf743441e574c2d52dd54)

if( NOT DEFINED SRC_HASH_${HDF5_VERSION})
  message( FATAL_ERROR "Version ${HDF5_VERSION} is not supported.  See CMakeLists.txt for valid versions" )
endif()

string(REPLACE "." "_" hdf5_source_version ${HDF5_VERSION})
message(STATUS "Building version ${HDF5_VERSION}...")

FetchContent_Declare(
  hdf5
  URL https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-${hdf5_source_version}.tar.gz
  URL_HASH SHA256=${SRC_HASH_${HDF5_VERSION}}
)
FetchContent_Populate(hdf5)

set (USE_LIBAEC ON CACHE BOOL "Use libaec szip replacement" FORCE)
set (USE_LIBAEC_STATIC TRUE)
set (SZIP_ROOT ${CMAKE_INSTALL_PREFIX})
# for find_package():
set (SZIP_DIR ${SZIP_ROOT}/cmake)
set (SZIP_INCLUDE_DIR ${SZIP_ROOT}/include)
set (SZIP_LIBRARY ${SZIP_ROOT}/lib/libsz.a)
set (libaec_DIR ${SZIP_ROOT}/cmake)
set (libaec_INCLUDE_DIR ${SZIP_ROOT}/include)
set (libaec_LIBRARY ${SZIP_ROOT}/lib/libaec.a)

set (ZLIB_ROOT ${CMAKE_INSTALL_PREFIX})
set (ZLIB_DIR ${CMAKE_INSTALL_PREFIX})
set (ZLIB_INCLUDE_DIR ${ZLIB_DIR}/include)
set (ZLIB_LIBRARY ${ZLIB_DIR}/lib/libz.a)
include_directories(${ZLIB_INCLUDE_DIR})
message(STATUS "ZLIB_DIR: ${ZLIB_DIR}")

# set the project name
project(libhdf5-wasm-build)

set (BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
option(BUILD_SHARED_LIBS "Build shared libs" OFF)
option(HDF5_ENABLE_THREADSAFE ON)
option(HDF5_BUILD_EXAMPLES "Build Examples" OFF)
option(HDF5_BUILD_TOOLS "Build Tools" ON)
option(HDF5_BUILD_UTILS "Build Utils" OFF)
option(HDF5_BUILD_CPP_LIB "Build CPP libraries" ON)
option(HDF5_ENABLE_Z_LIB_SUPPORT "Enable ZLIB" ON)
option(HDF5_ENABLE_SZIP_SUPPORT "Enable SZIP" ON)
option (HDF5_ENABLE_SZIP_ENCODING "Use SZip Encoding" ON)
option(SZIP_USE_EXTERNAL "needs to be off" 0)
option(ZLIB_USE_EXTERNAL "needs to be off" 0)

set (BUILD_TESTING OFF CACHE BOOL "Do not build tests by default" FORCE)
set(H5_HAVE_GETPWUID OFF)
set(H5_HAVE_SIGNAL OFF)

set(CMAKE_BUILD_TYPE RELEASE)

add_subdirectory(${hdf5_SOURCE_DIR} ${hdf5_BINARY_DIR})