add_library(
    peripherals
    STATIC
        adc.c
        syscalls/adc_syscalls.c
        syscalls/alarm_syscalls.c
        analog_comparator.c
        syscalls/analog_comparator_syscalls.c
        crc.c
        syscalls/crc_syscalls.c
        dac.c
        syscalls/dac_syscalls.c
        gpio_async.c
        syscalls/gpio_async_syscalls.c
        gpio.c
        syscalls/gpio_syscalls.c
        i2c_master_slave.c
        i2c_master.c
        rng.c
        syscalls/rng_syscalls.c
        rtc.c
        syscalls/rtc_syscalls.c
        spi_controller.c
        syscalls/spi_controller_syscalls.c
        spi_peripheral.c
        syscalls/spi_peripheral_syscalls.c
        usb.c
        syscalls/usb_syscalls.c
)

target_link_libraries(
    peripherals
    PUBLIC
        tock
)

add_library(tock::peripherals ALIAS peripherals)
