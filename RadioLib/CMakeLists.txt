# Workaround to avoid warnings in GNUInstallDirs, which is used by RadioLib
#
# We don't use CMake's "install" infrastructure for Tock, so we just set a default value to
# short-circuit the detection logic within GNUInstallDirs.
set(CMAKE_INSTALL_LIBDIR lib)

# todo: Consider using FetchContent instead of Git submodule
add_subdirectory(RadioLib EXCLUDE_FROM_ALL SYSTEM)

# Suppress warnings from RadioLib since it is an external library
target_compile_options(RadioLib PRIVATE -w)

# Supplement the RadioLib target with Tock-specific bindings via libtockHal.h
target_include_directories(
    RadioLib
    INTERFACE
        ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(
    RadioLib
    INTERFACE
        tock::kernel
        tock::net
        tock::net-sync
        tock::peripherals
        tock::services-sync
)
