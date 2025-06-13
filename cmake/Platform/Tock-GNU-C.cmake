# Custom platform information module for Tock OS applications
#
# This file is automatically loaded by CMake during its initialization process whenever
# CMAKE_SYSTEM_NAME is set to "Tock", the "C" language is enabled, and the toolchain is detected to
# be "GNU". Its role is to define any CMake settings needed to compile C source code for Tock
# applications.
#
# See the file libtock-c/doc/cmake.md for a more detailed explanation of how this file is used.

include("${CMAKE_CURRENT_LIST_DIR}/Tock-GNU.cmake")

# Use .o as the object file suffix for Tock applications
set(CMAKE_C_OUTPUT_EXTENSION ".o")

# Set default C flags
string(APPEND CMAKE_C_FLAGS_INIT " ${TOCK_GNU_CPPFLAGS}")

# Set flags for different optimization levels
set(CMAKE_C_FLAGS_RELEASE_INIT " ${TOCK_GNU_OPT_FLAGS}")
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT " ${TOCK_GNU_OPT_FLAGS}")
set(CMAKE_C_FLAGS_MINSIZEREL_INIT " ${TOCK_GNU_OPT_FLAGS}")
