add_tock_app(
    ble-uart
        ble_nus.c
        main.c
)

target_link_libraries(
    ble-uart
    PRIVATE
        tock::tock
        tock::net
        tock::interface
        tock::interface-sync
        nrfserialization
)
