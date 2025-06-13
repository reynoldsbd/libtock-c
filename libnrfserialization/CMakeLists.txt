# todo: some parameterization, probably via cache vars
# todo: selectively include/build this directory based on cache var and preset?

# Grab sources from nrf5x-base repository
include(FetchContent)
FetchContent_Declare(
    nrf5x-base
    GIT_REPOSITORY https://github.com/lab11/nrf5x-base
    GIT_TAG        f813b5dbfef3b7a71044bca72e2ab8b3c4d9e593
)
FetchContent_MakeAvailable(nrf5x-base)

# Settings and config for softdevice SDK
set(SDK_VERSION 11)
set(SDK_DIR_NAME nrf51_sdk_11.0.0)
set(SOFTDEVICE_MODEL s130)
set(NRF_DEVICE SAM4L)
set(NRF_BOARD BOARD_CUSTOM)

# Location for BLE Address if stored in Flash
set(BLEADDR_FLASH_LOCATION 0x0007FFF8)

# todo: tweak central/peripheral link counts based on ram size

# C11 required for nrf5x-base
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)


# Disable warnings for extrenal library
set(CMAKE_COMPILE_WARNING_AS_ERROR OFF)

# Define the library and add basic sources
add_library(
    nrfserialization
    STATIC
        serialization_tock.c
        softdevice_handler_tock.c
        ${nrf5x-base_SOURCE_DIR}/lib/simple_ble.c
        ${nrf5x-base_SOURCE_DIR}/advertisement/simple_adv.c
        ${nrf5x-base_SOURCE_DIR}/advertisement/eddystone.c
        ${nrf5x-base_SOURCE_DIR}/services/device_info_service.c
)

# Helper function to add globbed sources from a subdirectory of the nrf5x-base repo
function(add_nrf_sources dir)
    file(GLOB sources "${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/${dir}/*.c")
    target_sources(nrfserialization PRIVATE ${sources})
endfunction()

# Add all C sources from the following subdirectories
add_nrf_sources(components/serialization/application/codecs/${SOFTDEVICE_MODEL}/serializers)
add_nrf_sources(components/serialization/application/codecs/${SOFTDEVICE_MODEL}/middleware)
add_nrf_sources(components/serialization/application/transport)
add_nrf_sources(components/serialization/common/struct_ser/${SOFTDEVICE_MODEL})
add_nrf_sources(components/serialization/common)
add_nrf_sources(components/serialization/common/transport)
add_nrf_sources(components/ble/common)
add_nrf_sources(components/ble/ble_db_discovery)
add_nrf_sources(components/ble/ble_services/ble_hrs_c)
add_nrf_sources(components/ble/ble_services/ble_bas_c)
add_nrf_sources(components/ble/ble_services/ble_dis)
add_nrf_sources(components/libraries/mailbox)
add_nrf_sources(components/libraries/util)
add_nrf_sources(components/libraries/scheduler)
add_nrf_sources(components/libraries/trace)

target_include_directories(
    nrfserialization
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}

        ${nrf5x-base_SOURCE_DIR}/advertisement
        ${nrf5x-base_SOURCE_DIR}/lib
        ${nrf5x-base_SOURCE_DIR}/services

        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/ble/common
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/ble/ble_db_discovery
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/ble/ble_services/ble_hrs_c
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/ble/ble_services/ble_bas_c
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/ble/ble_services/ble_dis

        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/softdevice/common/softdevice_handler
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/softdevice/${SOFTDEVICE_MODEL}/headers
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/softdevice/${SOFTDEVICE_MODEL}/headers/nrf51

        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/common/
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/common/struct_ser/${SOFTDEVICE_MODEL}
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/common/transport/
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/common/transport/ser_phy
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/common/transport/ser_phy/config
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/application/codecs/common
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/application/codecs/${SOFTDEVICE_MODEL}/serializers
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/application/hal
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/serialization/application/transport

        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/device/

        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/libraries/mailbox
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/libraries/timer
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/libraries/trace
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/libraries/scheduler
        ${nrf5x-base_SOURCE_DIR}/sdk/${SDK_DIR_NAME}/components/libraries/util
)

target_compile_definitions(
    nrfserialization
    PUBLIC
        ${NRF_DEVICE}
        ${NRF_BOARD}
        SDK_VERSION_${SDK_VERSION}
        SOFTDEVICE_${SOFTDEVICE_MODEL}
        __TOCK__
        SVCALL_AS_NORMAL_FUNCTION
        BLE_STACK_SUPPORT_REQD
        SOFTDEVICE_PRESENT
        CENTRAL_LINK_COUNT=1
        PERIPHERAL_LINK_COUNT=1
        BLEADDR_FLASH_LOCATION=${BLEADDR_FLASH_LOCATION}
)

target_link_libraries(
    nrfserialization
    PRIVATE
        tock::net
        tock::peripherals
        tock::services-sync
)
