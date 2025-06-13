add_library(
    crypto-sync
    STATIC
        hmac.c
        sha.c
)

target_link_libraries(
    crypto-sync
    PUBLIC
        tock
        crypto
)

add_library(tock::crypto-sync ALIAS crypto-sync)
