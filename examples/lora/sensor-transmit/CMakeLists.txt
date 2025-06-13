add_tock_app(sensor-transmit main.cc)

target_link_libraries(
    sensor-transmit
    PRIVATE
        tock::sensors-sync
        RadioLib
)
