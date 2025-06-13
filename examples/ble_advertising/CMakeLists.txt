add_tock_app(ble_advertising main.c)

target_link_libraries(
    ble_advertising
    PRIVATE
        tock::tock
        tock::net
        simple-ble
)
