add_subdirectory(crypto)
add_subdirectory(display)
add_subdirectory(interface)
add_subdirectory(kernel)
add_subdirectory(net)
add_subdirectory(peripherals)
add_subdirectory(sensors)
add_subdirectory(services)
add_subdirectory(storage)

add_library(
    runtime-sync
    STATIC
        sys.c
)

target_link_libraries(
    runtime-sync
    PRIVATE
        interface-sync
)

add_library(tock::runtime-sync ALIAS runtime-sync)
