add_library(
    sensors-sync
    STATIC
        ambient_light.c
        humidity.c
        moisture.c
        ninedof.c
        pressure.c
        proximity.c
        rainfall.c
        sound_pressure.c
        temperature.c
)

target_link_libraries(
    sensors-sync
    PUBLIC
        tock
        sensors
)

add_library(tock::sensors-sync ALIAS sensors-sync)
