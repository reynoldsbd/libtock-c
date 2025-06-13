add_subdirectory(crypto)
add_subdirectory(display)
add_subdirectory(interface)
add_subdirectory(kernel)
add_subdirectory(net)
add_subdirectory(peripherals)
add_subdirectory(sensors)
add_subdirectory(services)
add_subdirectory(util)

add_library(
    tock
    STATIC
        tock.c
)

target_include_directories(
    tock
    PUBLIC
        ${PROJECT_SOURCE_DIR}
)

add_library(tock::tock ALIAS tock)

add_library(
    runtime
    STATIC
        crt0.c
        sys.c
)

target_link_libraries(
    runtime
    PRIVATE
        tock
        interface
)

add_library(tock::runtime ALIAS runtime)
