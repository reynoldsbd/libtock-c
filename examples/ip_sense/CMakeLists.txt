add_tock_app(ip_sense main.c)

set_property(TARGET ip_sense PROPERTY APP_HEAP_SIZE 2048)

target_link_libraries(
    ip_sense
    PRIVATE
        tock::net-sync
        tock::sensors-sync
        tock::services-sync
)
