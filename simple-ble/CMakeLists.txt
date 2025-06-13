add_library(
    simple-ble
    STATIC
        gap.c
)

target_include_directories(
    simple-ble
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)
