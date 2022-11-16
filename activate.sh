#!/bin/bash

# This script controls the version of Emscripten that is used to build the HDF5
# library. This specification can be important as objects built by different
# Emscripten versions are not guaranteed to be ABI compatible, so it is often
# desirable to link to a version of the HDF5 library that is built with the
# same version of the Emscripten SDK.

emsdk install 3.1.25
emsdk activate 3.1.25
