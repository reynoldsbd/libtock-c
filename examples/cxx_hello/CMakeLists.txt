add_tock_app(cxx_hello main.cc)

target_link_libraries(
    cxx_hello
    PRIVATE
        tock::services-sync
)
