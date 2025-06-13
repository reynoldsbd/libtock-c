add_tock_app(
    blink
        main.c
)

target_link_libraries(
    blink
    PRIVATE
        tock::interface
        tock::services-sync
)
