cmake_minimum_required(VERSION 3.24)
include(FetchContent)

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sFORCE_FILESYSTEM=1 -sSINGLE_FILE=1 --extern-pre-js=${CMAKE_SOURCE_DIR}/shebang.txt" CACHE INTERNAL "")
set(HDF5_VERSION "1_12_3" CACHE STRING "HDF5 version to build")
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "use -fPIC for all libs" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_C "" CACHE STRING "" FORCE)

set(SRC_HASH_1_12_3 39e2e3e25f2263f2dc3370556c174952675d7ac51c4d6f7d4f5e8b3a8bd10ac6)
set(SRC_HASH_1.14.5 ec2e13c52e60f9a01491bb3158cb3778c985697131fc6a342262d32a26e58e44)
set(SRC_HASH_1.14.6 6df53f84376d87e96eeb255703e3b1a348fc08a48e06e37053f1bfb379970189)
set(SRC_HASH_1_10_11 4ef6375fc7d8c54dcd66e9bc35a7a3580d33cd8878bdf21ad1eb388a43863159)

if( NOT DEFINED SRC_HASH_${HDF5_VERSION})
  message( FATAL_ERROR "Version ${HDF5_VERSION} is not supported.  See CMakeLists.txt for valid versions" )
endif()

message(STATUS "Building version ${HDF5_VERSION}...")

# Collect all patch files
file(GLOB PATCH_FILES LIST_DIRECTORIES false
    "${CMAKE_CURRENT_SOURCE_DIR}/patches/${HDF5_VERSION}/*.patch"
)

message(STATUS "Patches found: ${PATCH_FILES}")
# Create patch command if patches exist
set (patch_files_command)
if(PATCH_FILES)
    foreach(patch_file ${PATCH_FILES})
        list(APPEND patch_files_command
           COMMAND patch -p1 --forward --ignore-whitespace -i "${patch_file}"
        )
    endforeach()
endif()

FetchContent_Declare(
  hdf5
  URL https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-${HDF5_VERSION}.tar.gz
  URL_HASH SHA256=${SRC_HASH_${HDF5_VERSION}}
  PATCH_COMMAND ${patch_files_command}
  UPDATE_DISCONNECTED 1
  # prevent running CMakeLists.txt immediately, see
  # https://discourse.cmake.org/t/prevent-fetchcontent-makeavailable-to-execute-cmakelists-txt/12704
  # (makes FetchContent_MakeAvailable work like deprecated FetchContent_Populate)
  SOURCE_SUBDIR non_existant_dir
)
FetchContent_GetProperties(hdf5)
if (NOT hdf5_POPULATED)
  FetchContent_MakeAvailable(hdf5)
endif()

include(${hdf5_SOURCE_DIR}/config/cmake/cacheinit.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/wasm-settings.cmake)
set(HDF5_PLUGIN_SYMBOLS_STRING "" CACHE STRING "Emscripten exported functions string - only populate if building executables")
if(HDF5_BUILD_TOOLS)
  # this brings in the HDF5_PLUGIN_SYMBOLS_STRING and HDF5_PLUGIN_SYMBOLS variables and
  # the format_exported_functions() function
  include(${CMAKE_CURRENT_SOURCE_DIR}/plugin_symbols.cmake)
endif()

# set the project name
project(libhdf5-wasm-build)

set(CMAKE_BUILD_TYPE RELEASE)

add_subdirectory(${hdf5_SOURCE_DIR} ${hdf5_BINARY_DIR})

# Add plugin support linker flags to HDF5 tools after they're defined
if(HDF5_BUILD_TOOLS)
  # List of HDF5 tools to modify
  set (HDF5_TOOLS h5dump h5repack h5diff h5ls h5stat h5copy h5mkgrp h5repart h5jam h5unjam h5clear h5debug h5format_convert h5perf_serial h5watch)
  list (APPEND HDF5_PLUGIN_SYMBOLS main)
  format_exported_functions(HDF5_PLUGIN_SYMBOLS HDF5_PLUGIN_SYMBOLS_STRING)

  foreach(tool ${HDF5_TOOLS})
    if(TARGET ${tool})
      target_link_options(${tool} PRIVATE
        -sALLOW_MEMORY_GROWTH=1
        -sALLOW_TABLE_GROWTH=1
        -sMAIN_MODULE=2
        -sWASM_BIGINT=1
        -sENVIRONMENT=node
        --pre-js=${CMAKE_SOURCE_DIR}/env-setup.js
        "SHELL:-sEXPORTED_FUNCTIONS=\"${HDF5_PLUGIN_SYMBOLS_STRING}\""
      )
    endif()
  endforeach()
  message(STATUS "Added Emscripten linker options to HDF5 tools")
endif()

install(EXPORT hdf5-targets DESTINATION cmake)
install (
    FILES ${hdf5_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/hdf5-config.cmake
    DESTINATION cmake
    COMPONENT configinstall
)
