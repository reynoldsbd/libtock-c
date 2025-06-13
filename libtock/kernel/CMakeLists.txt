add_library(
    kernel
    STATIC
        ipc.c
        read_only_state.c
        syscalls/read_only_state_syscalls.c
)

target_link_libraries(
    kernel
    PUBLIC
        tock
)

add_library(tock::kernel ALIAS kernel)
