# Support for building Tock applications using CMake
#
# This module primarily provides the `add_tock_app()` function (documented below). It also defines
# several cache variables and target properties that influence how the apps are built.

include_guard(GLOBAL)

# Specifies a custom TBF package name for the app. If this property is not set, then the name of the
# target (as passed to `add_tock_app()`) is used as the package name.
define_property(TARGET PROPERTY PACKAGE_NAME)

# Specifies the major and minor version of the Tock kernel to target. These values are passed to
# elf2tab and, stored in the apps' TBF headers, and ultimately checked at runtime by the Tock kernel
# to ensure compatibility.
set(TOCK_KERNEL_VERSION_MAJOR 2 CACHE STRING "Major kernel version to target")
set(TOCK_KERNEL_VERSION_MINOR 0 CACHE STRING "Minor kernel version to target")

# Specifies default flash and RAM base addresses for all apps. The default values (0x80000000 for
# flash and 0x00000000 for RAM) are actually sentinel values that indicate that the app should be
# built as a position-independent executable.
# todo: maybe tie this to CMAKE_POSITION_INDEPENDENT_CODE?
set(TOCK_FLASH_BASE 0x80000000 CACHE STRING "Default flash base address for apps")
set(TOCK_RAM_BASE 0x00000000 CACHE STRING "Default RAM base address for apps")

# Number of bytes to reserve for app stack
set(TOCK_STACK_SIZE 2048 CACHE STRING "Default stack size for apps")
define_property(TARGET PROPERTY STACK_SIZE INITIALIZE_FROM_VARIABLE TOCK_STACK_SIZE)

# Number of bytes to reserve for app heap
set(TOCK_APP_HEAP_SIZE 1024 CACHE STRING "Default app heap size for apps")
define_property(TARGET PROPERTY APP_HEAP_SIZE INITIALIZE_FROM_VARIABLE TOCK_APP_HEAP_SIZE)

# Number of bytes to reserve for each app's kernel heap
set(TOCK_KERNEL_HEAP_SIZE 1024 CACHE STRING "Default kernel heap size for apps")
define_property(TARGET PROPERTY KERNEL_HEAP_SIZE INITIALIZE_FROM_VARIABLE TOCK_KERNEL_HEAP_SIZE)

# Number of bytes to reserve for the TBF footer
set(TOCK_FOOTER_SIZE 3000 CACHE STRING "Default TBF footer reservation for apps")
define_property(TARGET PROPERTY FOOTER_SIZE INITIALIZE_FROM_VARIABLE TOCK_FOOTER_SIZE)

# Locate linker script template and store in a variable. We do this ahead of time in order to use
# CMAKE_CURRENT_LIST_DIR, which would have an unexpected value if we tried to use it within the
# function below.
set(TOCK_LINKER_SCRIPT_TEMPLATE "${CMAKE_CURRENT_LIST_DIR}/userland_generic.ld")

# Add a Tock OS application to the project
#
# Usage is identical to add_executable():
#
#     add_tock_app(name [EXCLUDE_FROM_ALL] [SOURCES...])
#
# This will add a new executable target named `name` to the project using the source files specified
# by `SOURCES`. If `EXCLUDE_FROM_ALL` is specified, the target will be omitted from the default
# `all` target for this project.
#
# Two cache variables, `TOCK_FLASH_BASE_<name>` and `TOCK_RAM_BASE_<name>`, are automatically
# defined and can be used to specify the base flash and RAM addresses for the app. If flash and RAM
# addresses are not specified, then the app will be linked as a position-independent executable (or
# an error will be raised if the target does not support PIC).
#
# The app is automatically linked against the `tock::runtime` and `tock::runtime-sync` libraries,
# which provide the crt0 as well as most of the syscall symbols required by embedded libc
# implementations.
#
# A custom command is added to the target to run `elf2tab` on the resulting ELF file to produce TBF
# and TAB files for the app. These files are suitable for being loaded and executed by the Tock
# kernel.
#
# The `TockApp` CMake module defines a number of cache variables and target properties that can be
# used to further configure the app after it has been created by this function. Refer to the doc
# comments in `TockApp.cmake` for complete details.
function(add_tock_app name)
    cmake_parse_arguments(
        TOCK_APP
        EXCLUDE_FROM_ALL
        ""
        ""
        ${ARGN}
    )

    unset(EXCLUDE_FROM_ALL)

    if(TOCK_APP_EXCLUDE_FROM_ALL)
        set(EXCLUDE_FROM_ALL "EXCLUDE_FROM_ALL")
    endif()

    add_executable(
        ${name}

        # Expands to either "" or "EXCLUDE_FROM_ALL", depending on whether the caller specified the
        # EXCLUDE_FROM_ALL option.
        ${EXCLUDE_FROM_ALL}

        # Remaining arguments are the source files for the app
        ${TOCK_APP_UNPARSED_ARGUMENTS}
    )

    # Automatically link the tock runtime library
    target_link_libraries(
        ${name}
        PRIVATE
            "-Wl,--start-group"
                "-Wl,--whole-archive"
                    tock::runtime
                    tock::runtime-sync
                "-Wl,--no-whole-archive"
                -lc
            "-Wl,--end-group"
    )

    # Define cache variables which for setting the app's flash and RAM base addresses
    set(TOCK_FLASH_BASE_${name} ${TOCK_FLASH_BASE} CACHE STRING "Base flash address for ${name} app")
    set(TOCK_RAM_BASE_${name} ${TOCK_RAM_BASE} CACHE STRING "Base RAM address for ${name} app")

    # todo: check for sentinel values and set PIC flags, or raise error if pic is not supported

    # Generate custom linker script for the app
    set(FLASH_BASE ${TOCK_FLASH_BASE_${name}})
    set(RAM_BASE ${TOCK_RAM_BASE_${name}})
    configure_file(${TOCK_LINKER_SCRIPT_TEMPLATE} ${name}.ld)
    target_link_options(
        ${name}
        PRIVATE
            LINKER:--defsym=STACK_SIZE=$<TARGET_PROPERTY:STACK_SIZE>
            LINKER:--defsym=APP_HEAP_SIZE=$<TARGET_PROPERTY:APP_HEAP_SIZE>
            LINKER:--defsym=KERNEL_HEAP_SIZE=$<TARGET_PROPERTY:KERNEL_HEAP_SIZE>
            "-T${CMAKE_CURRENT_BINARY_DIR}/${name}.ld"
    )

    # Run elf2tab to produce TBF and TAB files
    #
    # The heavy use of generator expressions in the block below enables the caller to set properties
    # on the newly created app target after this function returns. This avoids the need to clutter
    # this function's signature with a large number of parameters and makes it feel much closer to a
    # simple wrapper around add_executable().
    set(
        ELF2TAB_ARGS
            --output-file "${CMAKE_CURRENT_BINARY_DIR}/${name}.tab"
            # Use PACKAGE_NAME
            --package-name "$<IF:$<BOOL:$<TARGET_PROPERTY:PACKAGE_NAME>>,$<TARGET_PROPERTY:PACKAGE_NAME>,${name}>"
            --kernel-major ${TOCK_KERNEL_VERSION_MAJOR}
            --kernel-minor ${TOCK_KERNEL_VERSION_MINOR}
            --stack $<TARGET_PROPERTY:STACK_SIZE>
            --app-heap $<TARGET_PROPERTY:APP_HEAP_SIZE>
            --kernel-heap $<TARGET_PROPERTY:KERNEL_HEAP_SIZE>
            $<$<BOOL:$<TARGET_PROPERTY:FOOTER_SIZE>>:--minimum-footer-size=$<TARGET_PROPERTY:FOOTER_SIZE>>
    )
    add_custom_command(
        TARGET ${name}
        POST_BUILD
        COMMAND elf2tab ${ELF2TAB_ARGS} $<TARGET_FILE:${name}>
        BYPRODUCTS
            "${CMAKE_CURRENT_BINARY_DIR}/${name}.tab"
            "${CMAKE_CURRENT_BINARY_DIR}/${name}.tbf"
        COMMENT "Generating TBF and TAB files for ${name}"
    )
endfunction()
