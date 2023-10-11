cmake_minimum_required(VERSION 3.24)
include(FetchContent)

project(libz
  VERSION 1.3
)

# install to parent folder:
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR PARENT_PATH PARENT_DIR)
message(STATUS "install: ${PARENT_DIR}/libz")

# pre-cache the linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-sNODERAWFS=1 -sFORCE_FILESYSTEM=1 -sSINGLE_FILE=1 --extern-pre-js=${CMAKE_SOURCE_DIR}/shebang.txt" CACHE INTERNAL "")
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "use -fPIC for all libs" FORCE)
set(CMAKE_EXECUTABLE_SUFFIX_C "" CACHE STRING "" FORCE)

FetchContent_Declare(
  zlib
  URL http://zlib.net/fossils/zlib-1.3.tar.gz
  URL_HASH  SHA256=ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e
)
FetchContent_Populate(zlib)
include_directories(${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})
add_subdirectory(${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})

include(CPack)

# set some local install folders for CPack
set(ZLIB_PUBLIC_HDRS
    ${zlib_BINARY_DIR}/zconf.h
    ${zlib_SOURCE_DIR}/zlib.h
)
set(ZLIB_PC ${zlib_BINARY_DIR}/zlib.pc)

if(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
    install(TARGETS zlib zlibstatic
        RUNTIME DESTINATION "bin"
        ARCHIVE DESTINATION "lib"
        LIBRARY DESTINATION "lib" )
endif()
if(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
    install(FILES ${ZLIB_PUBLIC_HDRS} DESTINATION "include")
endif()
if(NOT SKIP_INSTALL_FILES AND NOT SKIP_INSTALL_ALL )
    install(FILES ${ZLIB_PC} DESTINATION "share/pkgconfig")
endif()