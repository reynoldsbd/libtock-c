#pragma once

#include "../../tock.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    AES_NEW_ECB = 1,
    AES_NEW_CBC = 2,
} aes_new_mode;

typedef enum {
    AES_NEW_ENCRYPT = 0,
    AES_NEW_DECRYPT = 1,
} aes_new_operation;

returncode_t libtock_aes_new_set_upcall(subscribe_upcall callback, void* opaque);

returncode_t libtock_aes_new_set_readonly_allow_key_buffer(const uint8_t* key, uint32_t len);

returncode_t libtock_aes_new_set_readonly_allow_iv_buffer(const uint8_t* iv, uint32_t len);

returncode_t libtock_aes_new_set_readonly_allow_input_buffer(const uint8_t* input, uint32_t len);

returncode_t libtock_aes_new_set_readwrite_allow_output_buffer(uint8_t* output, uint32_t len);

returncode_t libtock_aes_new_set_readwrite_allow_chain_iv_buffer(uint8_t* chain_iv, uint32_t len);

returncode_t libtock_aes_new_command_crypt(aes_new_mode mode, aes_new_operation operation);

#ifdef __cplusplus
}
#endif
