add_library(
    kernel-sync
    STATIC
        read_only_state.c
)

target_link_libraries(
    kernel-sync
    PUBLIC
        tock
        kernel
)

add_library(tock::kernel-sync ALIAS kernel-sync)
