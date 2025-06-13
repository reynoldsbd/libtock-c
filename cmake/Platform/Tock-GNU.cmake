# Custom platform information module for Tock OS applications
#
# This contains GNU-specific settings which are shared across multiple languages. This is not
# automatically loaded by CMake, but it is included manually by other modules in this folder.

####################################################################################################
# Common flags for compiling assembly, C, and C++ files for all architectures
####################################################################################################

unset(TOCK_GNU_CPPFLAGS)

# Allocate individual sections for each function and data item. This makes link-time garbage
# more effective.
list(APPEND TOCK_GNU_CPPFLAGS -ffunction-sections)
list(APPEND TOCK_GNU_CPPFLAGS -fdata-sections)

# Always embed DWARF 2 debug information, GCC switches, and stack usage information in ELF files,
# regardless of the build type. Tock apps are always transformed to TBF files before being executed,
# so there is no benefit to stripping or omitting debug information for certain build types.
list(APPEND TOCK_GNU_CPPFLAGS -gdwarf-2)
list(APPEND TOCK_GNU_CPPFLAGS -frecord-gcc-switches)
list(APPEND TOCK_GNU_CPPFLAGS -fstack-usage)

# Convert to a string
list(JOIN TOCK_GNU_CPPFLAGS " " TOCK_GNU_CPPFLAGS)

####################################################################################################
# Optimization flags for compiling C and C++ for all architectures
####################################################################################################

# todo: lto
set(TOCK_GNU_OPT_FLAGS "-Os -DNDEBUG")

####################################################################################################
# Support for relocatable code
####################################################################################################

# todo: add flags for PIC apps (fPIC, emit-relocs)
# todo: maybe a separate module, or part of toolchain?
