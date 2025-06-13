add_tock_app(accel-leds main.c)

target_link_libraries(
    accel-leds
    PRIVATE
        tock::sensors-sync
        tock::interface
)
