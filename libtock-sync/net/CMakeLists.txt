add_library(
    net-sync
    STATIC
        ieee802154.c
        lora_phy.c
        udp.c
)

target_link_libraries(
    net-sync
    PUBLIC
        tock
        net
        services-sync
)

add_library(tock::net-sync ALIAS net-sync)
