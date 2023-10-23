cmake_minimum_required(VERSION 3.24)
include(FetchContent)

# get grandparent path
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR PARENT_PATH base_path)
cmake_path(GET base_path PARENT_PATH base_path)

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sFORCE_FILESYSTEM=1 -sSINGLE_FILE=1 --extern-pre-js=${base_path}/shebang.txt" CACHE INTERNAL "")
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "use -fPIC for all libs" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_C "" CACHE STRING "" FORCE)
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)
set(CMAKE_BUILD_TYPE RELEASE)

FetchContent_Declare(
  libaec
  GIT_REPOSITORY https://gitlab.dkrz.de/k202009/libaec
  GIT_TAG v1.0.6
  OVERRIDE_FIND_PACKAGE
)
set(libaec_USE_STATIC_LIBS ON)
FetchContent_MakeAvailable(libaec)