#include "aes_new.h"

returncode_t libtock_aes_new_ecb_encrypt(const uint8_t* key, uint32_t key_len,
                                         const uint8_t* input, uint32_t input_len,
                                         uint8_t* output, uint32_t output_len,
                                         subscribe_upcall callback, void* opaque) {
  returncode_t ret;

  ret = libtock_aes_new_set_upcall(callback, opaque);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_key_buffer(key, key_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_input_buffer(input, input_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readwrite_allow_output_buffer(output, output_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  return libtock_aes_new_command_crypt(AES_NEW_ECB, AES_NEW_ENCRYPT);
}

returncode_t libtock_aes_new_ecb_decrypt(const uint8_t* key, uint32_t key_len,
                                         const uint8_t* input, uint32_t input_len,
                                         uint8_t* output, uint32_t output_len,
                                         subscribe_upcall callback, void* opaque) {
  returncode_t ret;

  ret = libtock_aes_new_set_upcall(callback, opaque);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_key_buffer(key, key_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_input_buffer(input, input_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readwrite_allow_output_buffer(output, output_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  return libtock_aes_new_command_crypt(AES_NEW_ECB, AES_NEW_DECRYPT);
}

returncode_t libtock_aes_new_cbc_encrypt(const uint8_t* key, uint32_t key_len,
                                         const uint8_t* iv, uint32_t iv_len,
                                         const uint8_t* input, uint32_t input_len,
                                         uint8_t* output, uint32_t output_len,
                                         uint8_t* chain_iv, uint32_t chain_iv_len,
                                         subscribe_upcall callback, void* opaque) {
  returncode_t ret;

  ret = libtock_aes_new_set_upcall(callback, opaque);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_key_buffer(key, key_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_iv_buffer(iv, iv_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_input_buffer(input, input_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readwrite_allow_output_buffer(output, output_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  if (chain_iv != NULL) {
    ret = libtock_aes_new_set_readwrite_allow_chain_iv_buffer(chain_iv, chain_iv_len);
    if (ret != RETURNCODE_SUCCESS) return ret;
  }

  return libtock_aes_new_command_crypt(AES_NEW_CBC, AES_NEW_ENCRYPT);
}

returncode_t libtock_aes_new_cbc_decrypt(const uint8_t* key, uint32_t key_len,
                                         const uint8_t* iv, uint32_t iv_len,
                                         const uint8_t* input, uint32_t input_len,
                                         uint8_t* output, uint32_t output_len,
                                         uint8_t* chain_iv, uint32_t chain_iv_len,
                                         subscribe_upcall callback, void* opaque) {
  returncode_t ret;

  ret = libtock_aes_new_set_upcall(callback, opaque);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_key_buffer(key, key_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_iv_buffer(iv, iv_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readonly_allow_input_buffer(input, input_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  ret = libtock_aes_new_set_readwrite_allow_output_buffer(output, output_len);
  if (ret != RETURNCODE_SUCCESS) return ret;

  if (chain_iv != NULL) {
    ret = libtock_aes_new_set_readwrite_allow_chain_iv_buffer(chain_iv, chain_iv_len);
    if (ret != RETURNCODE_SUCCESS) return ret;
  }

  return libtock_aes_new_command_crypt(AES_NEW_CBC, AES_NEW_DECRYPT);
}
