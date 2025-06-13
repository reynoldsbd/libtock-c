add_tock_app(buttons main.c)

target_link_libraries(
    buttons
    PRIVATE
        tock::interface
)
