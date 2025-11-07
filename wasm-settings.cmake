# CMake cache initialization file for HDF5 WebAssembly builds
# Usage: emcmake cmake -C wasm-settings.cmake -S /path/to/hdf5 -B build-wasm

# Build type
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type" FORCE)

# Install directories - use simple relative paths to avoid nested structure
set(HDF5_INSTALL_BIN_DIR "bin" CACHE STRING "Binary install directory" FORCE)
set(HDF5_INSTALL_LIB_DIR "lib" CACHE STRING "Library install directory" FORCE)
set(HDF5_INSTALL_INCLUDE_DIR "include" CACHE STRING "Include install directory" FORCE)
set(HDF5_INSTALL_CMAKE_DIR "cmake" CACHE STRING "CMake install directory" FORCE)
set(HDF5_INSTALL_DATA_DIR "share" CACHE STRING "Data install directory" FORCE)

# External library support - use HDF5's built-in download mechanism
set(HDF5_ALLOW_EXTERNAL_SUPPORT "TGZ" CACHE STRING "Allow External Library Building (NO GIT TGZ)" FORCE)

# Download from URLs, not local files
set(ZLIB_USE_LOCALCONTENT OFF CACHE BOOL "Use local file for ZLIB FetchContent" FORCE)
set(LIBAEC_USE_LOCALCONTENT OFF CACHE BOOL "Use local file for LIBAEC FetchContent" FORCE)

# Force use of FetchContent to download from URLs (for 1_10_11 compatibility)
set(BUILD_ZLIB_WITH_FETCHCONTENT ON CACHE BOOL "Build ZLIB with FetchContent" FORCE)
set(BUILD_SZIP_WITH_FETCHCONTENT ON CACHE BOOL "Build SZIP with FetchContent" FORCE)

# Use consistent zlib and libaec versions for all HDF5 versions
# Override the version-specific cacheinit.cmake settings
# Note: Different HDF5 versions use different variable names (TGZ_ORIGNAME vs TGZ_NAME)
# set(ZLIB_TGZ_ORIGPATH "https://github.com/madler/zlib/releases/download/v1.3.1" CACHE STRING "Use ZLIB from original location" FORCE)
# set(ZLIB_TGZ_ORIGNAME "zlib-1.3.1.tar.gz" CACHE STRING "Use ZLIB from original compressed file (1_10_11)" FORCE)
# set(ZLIB_TGZ_NAME "zlib-1.3.1.tar.gz" CACHE STRING "Use HDF5_ZLib from compressed file" FORCE)
# set(LIBAEC_TGZ_ORIGPATH "https://github.com/MathisRosenhauer/libaec/releases/download/v1.1.3" CACHE STRING "Use LIBAEC from original location" FORCE)
# set(LIBAEC_TGZ_ORIGNAME "libaec-1.1.3.tar.gz" CACHE STRING "Use LIBAEC from original compressed file (1_10_11)" FORCE)
# set(SZAEC_TGZ_ORIGPATH "https://github.com/MathisRosenhauer/libaec/releases/download/v1.1.3" CACHE STRING "Use SZAEC from original location" FORCE)
# set(SZAEC_TGZ_NAME "libaec-1.1.3.tar.gz" CACHE STRING "Use SZip AEC from compressed file" FORCE)
# set(LIBAEC_TGZ_NAME "libaec-1.1.3.tar.gz" CACHE STRING "Use LIBAEC from compressed file" FORCE)

# External libraries to use
set(ZLIB_USE_EXTERNAL ON CACHE BOOL "Use external ZLIB library" FORCE)
set(SZIP_USE_EXTERNAL ON CACHE BOOL "Use external SZIP library" FORCE)

# Static linking
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries" FORCE)
set(BUILD_STATIC_LIBS ON CACHE BOOL "Build static libraries" FORCE)
set(HDF5_USE_ZLIB_STATIC ON CACHE BOOL "Use static zlib library" FORCE)
set(HDF5_USE_LIBAEC_STATIC ON CACHE BOOL "Use static libaec library" FORCE)

# Language support
set(HDF5_BUILD_FORTRAN OFF CACHE BOOL "Build Fortran libraries" FORCE)
set(HDF5_BUILD_JAVA OFF CACHE BOOL "Build Java libraries" FORCE)

# Feature builds
set(HDF5_BUILD_TOOLS OFF CACHE BOOL "Build HDF5 Tools")
set(HDF5_BUILD_CPP_LIB ON CACHE BOOL "Build C++ support" FORCE)
set(HDF5_BUILD_EXAMPLES OFF CACHE BOOL "Build HDF5 Library Examples" FORCE)
set(HDF5_BUILD_UTILS OFF CACHE BOOL "Build HDF5 Utils" FORCE)

# Enable compression support
set(HDF5_ENABLE_Z_LIB_SUPPORT ON CACHE BOOL "Enable ZLIB support" FORCE)
set(HDF5_ENABLE_SZIP_SUPPORT ON CACHE BOOL "Enable SZIP support" FORCE)
set(HDF5_ENABLE_SZIP_ENCODING ON CACHE BOOL "Enable SZIP encoding" FORCE)

# Testing
set(BUILD_TESTING OFF CACHE BOOL "Build HDF5 Unit Testing" FORCE)
set(HDF5_BUILD_TESTS OFF CACHE BOOL "Build HDF5 Unit Testing" FORCE)

# Packaging
set(HDF5_PACKAGE_EXTLIBS ON CACHE BOOL "Package external libraries with HDF5" FORCE)

# Disable unsupported features for WebAssembly
set(H5_HAVE_GETPWUID OFF CACHE BOOL "Disable getpwuid (not available in Emscripten)" FORCE)
set(H5_HAVE_SIGNAL OFF CACHE BOOL "Disable signal handling (not fully supported in Emscripten)" FORCE)

# Optional: Position independent code (useful for some build scenarios)
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "Build position independent code" FORCE)

# Optional: Disable executable suffix for cleaner output names
set(CMAKE_EXECUTABLE_SUFFIX_C "" CACHE STRING "Executable suffix" FORCE)

# Indicate that HDF5 is using internal configuration
set(HDF5_EXTERNALLY_CONFIGURED OFF CACHE BOOL "HDF5 externally configured" FORCE)
