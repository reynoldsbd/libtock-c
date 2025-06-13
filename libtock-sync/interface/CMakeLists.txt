add_library(
    interface-sync
    STATIC
        button.c
        buzzer.c
        console.c
        usb_keyboard_hid.c
)

target_link_libraries(
    interface-sync
    PUBLIC
        tock
        interface
)

add_library(tock::interface-sync ALIAS interface-sync)
