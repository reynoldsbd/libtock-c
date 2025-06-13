add_library(
    crypto
    STATIC
        aes.c
        syscalls/aes_syscalls.c
        hmac.c
        syscalls/hmac_syscalls.c
        sha.c
        syscalls/sha_syscalls.c
)

add_library(tock::crypto ALIAS crypto)
