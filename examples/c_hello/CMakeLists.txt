add_tock_app(c_hello main.c)

target_link_libraries(
    c_hello
    PRIVATE
        tock::interface
)
