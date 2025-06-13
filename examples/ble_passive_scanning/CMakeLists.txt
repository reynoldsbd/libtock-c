add_tock_app(
    ble_passive_scanning
        advertisement.cpp
        advertisement_list.cpp
        main.cpp
)

set_property(
    TARGET ble_passive_scanning
    PROPERTY APP_HEAP_SIZE 4096
)

target_link_libraries(
    ble_passive_scanning
    PRIVATE
        tock::net
)
