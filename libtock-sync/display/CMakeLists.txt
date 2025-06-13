add_library(
    display-sync
    STATIC
        screen.c
        text_screen.c
)

target_link_libraries(
    display-sync
    PUBLIC
        tock
        display
)

add_library(tock::display-sync ALIAS display-sync)
