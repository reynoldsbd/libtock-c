add_tock_app(sensor-receive main.cc)

target_link_libraries(
    sensor-receive
    PRIVATE
        RadioLib
)
