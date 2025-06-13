add_library(
    peripherals-sync
    STATIC
        adc.c
        crc.c
        gpio.c
        gpio_async.c
        rng.c
        rtc.c
        spi_controller.c
        spi_peripheral.c
        usb.c
)

target_link_libraries(
    peripherals-sync
    PUBLIC
        tock
        peripherals
)

add_library(tock::peripherals-sync ALIAS peripherals-sync)
