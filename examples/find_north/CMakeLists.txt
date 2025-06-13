add_tock_app(find_north main.c)

target_link_libraries(
    find_north
    PRIVATE
        tock::interface
        tock::sensors-sync
        m
)
