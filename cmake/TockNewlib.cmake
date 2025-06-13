# Custom Newlib Support for Tock Apps
#
# This module downloads a prebuilt, Tock-optimized version of the newlib C library and modifies the
# necessary CMake variables to ensure it is properly used by all C and C++ code.
#
# Properly integrating a custom libc into the CMake build system requires modifying some CMake
# variables which cannot be set in a normal CMakeLists.txt file. Hence, this module is intended to
# be included as part of a CMake platform information module, i.e. Platform/Tock.cmake.
#
# The following cache variables must be set when using this module:
#
# * TOCK_NEWLIB_SUBDIR - Subdirectory within Tock's newlib archive which contains the newlib
#   implementation for the current CPU.
# * TOCK_NEWLIB_LIBDIR - Subdirectory within newlib's "lib" directory containing ISA and
#   ABI-specific static libraries.

include_guard(GLOBAL)

include(FetchContent)

# Define and validate cache variable parameters
set(TOCK_NEWLIB_SUBDIR "" CACHE STRING "CPU-specific subdirectory within Tock's newlib archive")
set(TOCK_NEWLIB_LIBDIR "" CACHE STRING "ISA and ABI-specific subdirectory within newlib's 'lib' directory")
if(TOCK_NEWLIB_SUBDIR STREQUAL "" OR TOCK_NEWLIB_LIBDIR STREQUAL "")
    message(FATAL_ERROR "TOCK_NEWLIB_SUBDIR and TOCK_NEWLIB_LIBDIR must be set to use Tock's custom newlib")
endif()

# In order to properly integrate with CMake's try_compile() functionality, several variables must be
# explicitly propagated into test projects.
list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
    # Compiler information
    CMAKE_C_COMPILER_ID
    CMAKE_C_COMPILER_VERSION

    # Prevent re-downloading any FetchContent artifacts
    FETCHCONTENT_BASE_DIR

    # Architecture-specific parameters for newlib subdirectories
    TOCK_NEWLIB_SUBDIR
    TOCK_NEWLIB_LIBDIR
)

# Determine Newlib version based on compiler major version
string(REPLACE "." ";" COMPILER_VERSION_PARTS ${CMAKE_C_COMPILER_VERSION})
list(GET COMPILER_VERSION_PARTS 0 COMPILER_MAJOR_VERSION)
if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    if(COMPILER_MAJOR_VERSION EQUAL 10)
        set(NEWLIB_VERSION "4.2.0.20211231")
    elseif(COMPILER_MAJOR_VERSION EQUAL 11)
        set(NEWLIB_VERSION "4.2.0.20211231")
    elseif(COMPILER_MAJOR_VERSION EQUAL 12)
        set(NEWLIB_VERSION "4.3.0.20230120")
    elseif(COMPILER_MAJOR_VERSION EQUAL 13)
        set(NEWLIB_VERSION "4.3.0.20230120")
    elseif(COMPILER_MAJOR_VERSION EQUAL 14)
        set(NEWLIB_VERSION "4.4.0.20231231")
    else()
        message(WARNING "Unrecognized GCC version ${CMAKE_C_COMPILER_VERSION}. Using default Newlib version.")
        set(NEWLIB_VERSION "4.4.0.20231231")
    endif()
else()
    message(FATAL_ERROR "Custom Newlib is not supported for compiler ${CMAKE_C_COMPILER_ID}")
endif()

# NEWLIB_PKG is also used as the name of the FetchContent package. We intentionally include the
# version string as part of the package name so that multiple versions can coexist, which in turn
# allows multiple presets to share a common FETCHCONTENT_BASE_DIR to cache package downloads.
set(NEWLIB_PKG "libtock-newlib-${NEWLIB_VERSION}")
set(NEWLIB_FILE "${NEWLIB_PKG}.zip")
message(STATUS "Downloading ${NEWLIB_FILE}")

if(NEWLIB_VERSION STREQUAL "4.2.0.20211231")
    set(NEWLIB_SHA "5916d76f1cc3c0f5487275823c85a9a9954edfa15f5706342ecb254d634ed559")
elseif(NEWLIB_VERSION STREQUAL "4.3.0.20230120")
    set(NEWLIB_SHA "2595f02f7cb2fd2e444f4ddc7955deca4c52deb3f91411c4d28326be8b0d9e0d")
elseif(NEWLIB_VERSION STREQUAL "4.4.0.20231231")
    set(NEWLIB_SHA "686af44e1bba625eb24b3cfb1fd2d48a61848c1edebbd49b5dbec554ebf2ea94")
endif()

# Download Newlib archive from one of the mirrors maintained by the Tock project
#
# We include the version as part of the package name so that multiple newlib versions can be
# downloaded side-by-side.
set(NEWLIB_PKG "libtock-newlib-${NEWLIB_VERSION}}")
FetchContent_Declare(
    tock-newlib
    URL
        https://www.cs.virginia.edu/~bjc8c/archive/tock/${NEWLIB_FILE}
        https://alpha.mirror.svc.schuermann.io/files/tock/${NEWLIB_FILE}
    URL_HASH SHA256=${NEWLIB_SHA}
)
FetchContent_MakeAvailable(tock-newlib)

# Configure search paths for headers and libraries
#
# The following CMake commands will add the appropriate directories to the preprocessor and linker
# search paths, ensuring that the newlib C library is used instead of whatever other standard
# library may be included with the current toolchain.
#
# N.B. We explicitly _avoid_ GCC's "-nostdlib" or other such "-noXXX" flags.
#
# It would be great if we could use some combination of "-noXXX" flags to strictly guarantee that
# only our newlib is used. However this would also remove access to the compiler's built-in headers
# and libraries (e.g. stddef.h, libgcc.a), which are required by newlib itself.
#
# A future improvement could be to explicitly compute the compiler-specific search directories based
# on output from one of GCC's -print-xxx options. But we would still need to figure out how to make
# this work with the circular dependencies from sys.c without cluttering our CMake projects with a
# bunch of non-portable paths.
list(APPEND CMAKE_C_STANDARD_INCLUDE_DIRECTORIES
    ${tock-newlib_SOURCE_DIR}/${TOCK_NEWLIB_SUBDIR}/include
)
string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -L${tock-newlib_SOURCE_DIR}/${TOCK_NEWLIB_SUBDIR}/lib/${TOCK_NEWLIB_LIBDIR}")
