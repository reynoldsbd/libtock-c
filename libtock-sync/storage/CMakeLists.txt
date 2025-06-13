add_library(
    storage-sync
    STATIC
        app_state.c
        isolated_nonvolatile_storage.c
        kv.c
        nonvolatile_storage.c
        sdcard.c
)

target_link_libraries(
    storage-sync
    PUBLIC
        tock
        storage
)

add_library(tock::storage-sync ALIAS storage-sync)
