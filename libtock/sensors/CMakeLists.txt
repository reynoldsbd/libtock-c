add_library(
    sensors
    STATIC
        ambient_light.c
        syscalls/ambient_light_syscalls.c
        humidity.c
        syscalls/humidity_syscalls.c
        moisture.c
        syscalls/moisture_syscalls.c
        ninedof.c
        syscalls/ninedof_syscalls.c
        pressure.c
        syscalls/pressure_syscalls.c
        proximity.c
        syscalls/proximity_syscalls.c
        rainfall.c
        syscalls/rainfall_syscalls.c
        sound_pressure.c
        syscalls/sound_pressure_syscalls.c
        temperature.c
        syscalls/temperature_syscalls.c
        touch.c
        syscalls/touch_syscalls.c
)

add_library(tock::sensors ALIAS sensors)