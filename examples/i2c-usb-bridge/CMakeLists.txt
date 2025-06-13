add_tock_app(i2c-usb-bridge main.c)

target_link_libraries(
    i2c-usb-bridge
    PRIVATE
        tock::interface-sync
        tock::peripherals
)
