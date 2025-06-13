add_library(
    interface
    STATIC
        button.c
        syscalls/button_syscalls.c
        buzzer.c
        syscalls/buzzer_syscalls.c
        console.c
        syscalls/console_syscalls.c
        led.c
        syscalls/led_syscalls.c
        syscalls/servo_syscalls.c
        usb_keyboard_hid.c
        syscalls/usb_keyboard_hid_syscalls.c
)

target_link_libraries(
    interface
    PUBLIC
        tock
)

add_library(tock::interface ALIAS interface)
