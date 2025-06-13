add_library(
    services
    STATIC
        alarm.c
)

target_link_libraries(
    services
    PUBLIC
        tock
        peripherals
)

add_library(tock::services ALIAS services)
