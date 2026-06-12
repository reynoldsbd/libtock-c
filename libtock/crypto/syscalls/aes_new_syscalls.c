#include "aes_new_syscalls.h"

#define DRIVER_NUM_AES_NEW    0x99999

#define TOCK_AES_NEW_CB              0

#define TOCK_AES_NEW_KEY_BUF         0
#define TOCK_AES_NEW_IV_BUF          1
#define TOCK_AES_NEW_INPUT_BUF       2
#define TOCK_AES_NEW_OUTPUT_BUF      0
#define TOCK_AES_NEW_CHAIN_IV_BUF    1

#define TOCK_AES_NEW_CRYPT           1

returncode_t libtock_aes_new_set_upcall(subscribe_upcall callback, void* opaque) {
  subscribe_return_t sval = subscribe(DRIVER_NUM_AES_NEW, TOCK_AES_NEW_CB, callback, opaque);
  return tock_subscribe_return_to_returncode(sval);
}

returncode_t libtock_aes_new_set_readonly_allow_key_buffer(const uint8_t* key, uint32_t len) {
  allow_ro_return_t aval = allow_readonly(DRIVER_NUM_AES_NEW, TOCK_AES_NEW_KEY_BUF, (void*) key, len);
  return tock_allow_ro_return_to_returncode(aval);
}

returncode_t libtock_aes_new_set_readonly_allow_iv_buffer(const uint8_t* iv, uint32_t len) {
  allow_ro_return_t aval = allow_readonly(DRIVER_NUM_AES_NEW, TOCK_AES_NEW_IV_BUF, (void*) iv, len);
  return tock_allow_ro_return_to_returncode(aval);
}

returncode_t libtock_aes_new_set_readonly_allow_input_buffer(const uint8_t* input, uint32_t len) {
  allow_ro_return_t aval = allow_readonly(DRIVER_NUM_AES_NEW, TOCK_AES_NEW_INPUT_BUF, (void*) input, len);
  return tock_allow_ro_return_to_returncode(aval);
}

returncode_t libtock_aes_new_set_readwrite_allow_output_buffer(uint8_t* output, uint32_t len) {
  allow_rw_return_t aval = allow_readwrite(DRIVER_NUM_AES_NEW, TOCK_AES_NEW_OUTPUT_BUF, (void*) output, len);
  return tock_allow_rw_return_to_returncode(aval);
}

returncode_t libtock_aes_new_set_readwrite_allow_chain_iv_buffer(uint8_t* chain_iv, uint32_t len) {
  allow_rw_return_t aval = allow_readwrite(DRIVER_NUM_AES_NEW, TOCK_AES_NEW_CHAIN_IV_BUF, (void*) chain_iv, len);
  return tock_allow_rw_return_to_returncode(aval);
}

returncode_t libtock_aes_new_command_crypt(aes_new_mode mode, aes_new_operation operation) {
  syscall_return_t cval = command(DRIVER_NUM_AES_NEW, TOCK_AES_NEW_CRYPT, (uint32_t) mode, (uint32_t) operation);
  return tock_command_return_novalue_to_returncode(cval);
}
