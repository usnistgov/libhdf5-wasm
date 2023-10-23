cmake_minimum_required(VERSION 3.24)
include(FetchContent)

# get grandparent path
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR PARENT_PATH base_path)
cmake_path(GET base_path PARENT_PATH base_path)

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sFORCE_FILESYSTEM=1 -sSINGLE_FILE=1 --extern-pre-js=${base_path}/shebang.txt" CACHE INTERNAL "")
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "use -fPIC for all libs" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_C "" CACHE STRING "" FORCE)

set(CMAKE_BUILD_TYPE RELEASE)

FetchContent_Declare(
  zlib
  URL http://zlib.net/fossils/zlib-1.3.tar.gz
  URL_HASH  SHA256=ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e
  OVERRIDE_FIND_PACKAGE
)
FetchContent_Populate(zlib)

# add global included path because zlib not set up to be subproject
include_directories(${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})
add_subdirectory(${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})