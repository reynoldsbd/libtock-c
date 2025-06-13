# Custom platform information module for Tock OS applications
#
# This file is automatically loaded by CMake during its initialization process whenever
# CMAKE_SYSTEM_NAME is set to "Tock". Its role is to define any language-agnostic CMake settings
# needed for building and linking Tock applications.
#
# See the file libtock-c/doc/cmake.md for a more detailed explanation of how this file is used.

####################################################################################################
# Flags for linking Tock applications
####################################################################################################

# Use .elf as the executable suffix
set(CMAKE_EXECUTABLE_SUFFIX ".elf")

# Omit build ID, resulting in a more deterministic build
string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,--build-id=none")

# Omit the toolchain's built-in crt0 since libtock-c provides its own
string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -nostartfiles")

# Enable garbage collection of unused sections
string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,--gc-sections")

string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,-Map=%")

####################################################################################################
# Custom newlib support
####################################################################################################

set(TOCK_NEWLIB OFF CACHE BOOL "Download and use Tock's custom newlib")
if(TOCK_NEWLIB)
    include(TockNewlib)
endif()
