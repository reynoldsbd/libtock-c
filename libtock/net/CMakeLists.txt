add_library(
    net
    STATIC
        ble.c
        eui64.c
        syscalls/eui64_syscalls.c
        ieee802154.c
        syscalls/ieee802154_syscalls.c
        lora_phy.c
        syscalls/lora_phy_syscalls.c
        nrf51_serialization.c
        syscalls/nrf51_serialization_syscalls.c
        udp.c
        syscalls/udp_syscalls.c
)

target_link_libraries(
    net
    PUBLIC
        tock
)

add_library(tock::net ALIAS net)
