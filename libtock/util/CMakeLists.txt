add_library(
    util
    STATIC
        streaming_process_slice.c
)

add_library(tock::util ALIAS util)
