cmake_minimum_required(VERSION 3.24)
include(FetchContent)

project(LIBAEC)

# install to parent folder:
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR PARENT_PATH PARENT_DIR)

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sFORCE_FILESYSTEM=1 -sSINGLE_FILE=1 --extern-pre-js=${CMAKE_SOURCE_DIR}/shebang.txt" CACHE INTERNAL "")
# set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/dist" CACHE STRING "local install folder" FORCE)
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "use -fPIC for all libs" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_C "" CACHE STRING "" FORCE)

FetchContent_Declare(
  libaec
  GIT_REPOSITORY https://gitlab.dkrz.de/k202009/libaec
  GIT_TAG v1.0.6
  # OVERRIDE_FIND_PACKAGE
)
set(libaec_USE_STATIC_LIBS ON)
FetchContent_MakeAvailable(libaec)