add_library(
    services-sync
    STATIC
        alarm.c
        unit_test.c
)

target_link_libraries(
    services-sync
    PUBLIC
        tock
        services
)

add_library(tock::services-sync ALIAS services-sync)
