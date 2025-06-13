add_library(
    display
    STATIC
        screen.c
        syscalls/screen_syscalls.c
        text_screen.c
        syscalls/text_screen_syscalls.c
)

add_library(tock::display ALIAS display)
