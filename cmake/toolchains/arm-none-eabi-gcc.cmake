# Toolchain file for ARM GCC toolchain

####################################################################################################
# Set the compiler executable
####################################################################################################

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)

####################################################################################################
# Default C and C++ compiler flags
####################################################################################################

unset(ARM_CPPFLAGS_INIT)

# Required cache variable for user to specify ARM CPU type
set(TOCK_ARM_CPU "" CACHE STRING "ARM CPU type (e.g., cortex-m0, cortex-m3, etc.)")
list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES TOCK_ARM_CPU)

# CPU-specific flags
if(TOCK_ARM_CPU STREQUAL "cortex-m0")
    list(APPEND ARM_CPPFLAGS_INIT -mcpu=cortex-m0)
    list(APPEND ARM_CPPFLAGS_INIT -march=armv6s-m)
elseif(TOCK_ARM_CPU STREQUAL "cortex-m3")
    list(APPEND ARM_CPPFLAGS_INIT -mcpu=cortex-m3)
elseif(TOCK_ARM_CPU STREQUAL "cortex-m4")
    list(APPEND ARM_CPPFLAGS_INIT -mcpu=cortex-m4)
elseif(TOCK_ARM_CPU STREQUAL "cortex-m7")
    list(APPEND ARM_CPPFLAGS_INIT -mcpu=cortex-m7)
else()
    message(FATAL_ERROR "Unrecognized ARM CPU type \"${TOCK_ARM_CPU}\"")
endif()

# Assume no hardware floating point support
list(APPEND ARM_CPPFLAGS_INIT -mfloat-abi=soft)

# Use thumb instructions for smaller code footprint
list(APPEND ARM_CPPFLAGS_INIT -mthumb)

# Flags for position independent code generation
# todo: should pic flags be optional, or handled somewhere else?
list(APPEND ARM_CPPFLAGS_INIT
    -fPIC
    -msingle-pic-base
    -mpic-register=r9
    -mno-pic-data-is-text-relative
)

list(JOIN ARM_CPPFLAGS_INIT " " ARM_CPPFLAGS_INIT)
set(CMAKE_C_FLAGS_INIT "${ARM_CPPFLAGS_INIT}")
set(CMAKE_CXX_FLAGS_INIT "${ARM_CPPFLAGS_INIT}")

####################################################################################################
# Default linker flags
####################################################################################################

# todo: should pic flags be optional, or handled somewhere else?
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--emit-relocs")
