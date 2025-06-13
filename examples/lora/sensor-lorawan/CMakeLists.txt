add_tock_app(
    sensor-lorawan
        main.cc
        CayenneLPP.cc
)

set_property(TARGET sensor-lorawan PROPERTY STACK_SIZE 4096)

target_compile_definitions(
    sensor-lorawan
    PRIVATE
        RADIOLIB_CLOCK_DRIFT_MS=9
)

# todo: comment with explanation
# todo: is this the right behavior? should we print a warning or something?
if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/radioConfig.h)
    target_compile_definitions(
        sensor-lorawan
        PRIVATE
            RADIO_CONFIG_CI=radioConfig_example.h
    )
endif()

target_link_libraries(
    sensor-lorawan
    PRIVATE
        tock::sensors-sync
        RadioLib
)
