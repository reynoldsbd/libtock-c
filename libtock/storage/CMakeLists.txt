add_library(
    storage
    STATIC
        app_state.c
        syscalls/app_state_syscalls.c
        isolated_nonvolatile_storage.c
        syscalls/isolated_nonvolatile_storage_syscalls.c
        kv.c
        syscalls/kv_syscalls.c
        nonvolatile_storage.c
        syscalls/nonvolatile_storage_syscalls.c
        sdcard.c
        syscalls/sdcard_syscalls.c
)

add_library(tock::storage ALIAS storage)
