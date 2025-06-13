cmake_minimum_required(VERSION 3.25)

project(libtock-c)

include(TockApp)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_subdirectory(examples)
# add_subdirectory(libnrfserialization) # not working with cmake yet
add_subdirectory(libtock)
add_subdirectory(libtock-sync)
add_subdirectory(RadioLib)
add_subdirectory(simple-ble)
