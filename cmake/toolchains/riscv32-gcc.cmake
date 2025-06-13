# Toolchain file for RISC-V 32-bit GCC toolchain

####################################################################################################
# Detect compiler executable
####################################################################################################

# RISC-V toolchains, irrespective of their name-tuple, can compile for
# essentially any target. Thus, try a few known names and choose the one for
# which a compiler is found.
find_program(
    RISCV_GCC
    NAMES
        riscv64-none-elf-gcc
        riscv32-none-elf-gcc
        riscv64-elf-gcc
        riscv32-elf-gcc
        riscv64-unknown-elf-gcc
    REQUIRED
)

# Identify the GCC triple based on the name of the compiler executable found above
file(GET RISCV_GCC STEM RISCV_GCC_STEM)
string(REPLACE -gcc "" GCC_TRIPLE "${RISCV_GCC_STEM}")

set(CMAKE_C_COMPILER ${GCC_TRIPLE}-gcc)
set(CMAKE_CXX_COMPILER ${GCC_TRIPLE}-g++)

####################################################################################################
# Default C and C++ compiler flags
####################################################################################################

# todo: need to set march, or will cmake do it automatically?

list(APPEND RISCV_CPPFLAGS_INIT -mabi=ilp32)
list(APPEND RISCV_CPPFLAGS_INIT -mcmodel=medlow)

list(JOIN RISCV_CPPFLAGS_INIT " " RISCV_CPPFLAGS_INIT)
set(CMAKE_C_FLAGS_INIT "${RISCV_CPPFLAGS_INIT}")
set(CMAKE_CXX_FLAGS_INIT "${RISCV_CPPFLAGS_INIT}")

####################################################################################################
# Default linker flags
####################################################################################################

set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--no-relax")
