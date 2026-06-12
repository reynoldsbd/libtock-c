#pragma once

#include "../tock.h"
#include "syscalls/aes_new_syscalls.h"

#ifdef __cplusplus
extern "C" {
#endif

// Encrypt a plaintext buffer using AES-128 in ECB mode.
//
// ECB (Electronic Codebook) encrypts each 16-byte block of the input
// independently using the same key. No initialization vector is used.
//
// Parameters:
//   key        - Pointer to the 128-bit (16-byte) encryption key.
//   key_len    - Length of the key buffer in bytes. Must be 16.
//   input      - Pointer to the plaintext data to encrypt. Length must be a
//                multiple of 16 bytes (the AES block size).
//   input_len  - Length of the input buffer in bytes.
//   output     - Pointer to a buffer where the ciphertext will be written.
//                Must be at least `input_len` bytes.
//   output_len - Length of the output buffer in bytes.
//   callback   - Function to call when the operation completes. The kernel
//                will invoke this upcall asynchronously after the encryption
//                finishes.
//   opaque     - Opaque pointer passed through to the callback.
//
// Returns RETURNCODE_SUCCESS if the operation was successfully started, or
// an error returncode if any buffer setup or command fails.
returncode_t libtock_aes_new_ecb_encrypt(const uint8_t* key, uint32_t key_len,
                                         const uint8_t* input, uint32_t input_len,
                                         uint8_t* output, uint32_t output_len,
                                         subscribe_upcall callback, void* opaque);

// Decrypt a ciphertext buffer using AES-128 in ECB mode.
//
// ECB (Electronic Codebook) decrypts each 16-byte block of the input
// independently using the same key. No initialization vector is used.
//
// Parameters:
//   key        - Pointer to the 128-bit (16-byte) decryption key.
//   key_len    - Length of the key buffer in bytes. Must be 16.
//   input      - Pointer to the ciphertext data to decrypt. Length must be a
//                multiple of 16 bytes (the AES block size).
//   input_len  - Length of the input buffer in bytes.
//   output     - Pointer to a buffer where the plaintext will be written.
//                Must be at least `input_len` bytes.
//   output_len - Length of the output buffer in bytes.
//   callback   - Function to call when the operation completes. The kernel
//                will invoke this upcall asynchronously after the decryption
//                finishes.
//   opaque     - Opaque pointer passed through to the callback.
//
// Returns RETURNCODE_SUCCESS if the operation was successfully started, or
// an error returncode if any buffer setup or command fails.
returncode_t libtock_aes_new_ecb_decrypt(const uint8_t* key, uint32_t key_len,
                                         const uint8_t* input, uint32_t input_len,
                                         uint8_t* output, uint32_t output_len,
                                         subscribe_upcall callback, void* opaque);

// Encrypt a plaintext buffer using AES-128 in CBC mode.
//
// CBC (Cipher Block Chaining) XORs each plaintext block with the previous
// ciphertext block before encrypting, producing ciphertext that depends on
// all preceding blocks. An initialization vector (IV) is required to seed
// the first block.
//
// Parameters:
//   key          - Pointer to the 128-bit (16-byte) encryption key.
//   key_len      - Length of the key buffer in bytes. Must be 16.
//   iv           - Pointer to the 16-byte initialization vector.
//   iv_len       - Length of the IV buffer in bytes. Must be 16.
//   input        - Pointer to the plaintext data to encrypt. Length must be a
//                  multiple of 16 bytes (the AES block size).
//   input_len    - Length of the input buffer in bytes.
//   output       - Pointer to a buffer where the ciphertext will be written.
//                  Must be at least `input_len` bytes.
//   output_len   - Length of the output buffer in bytes.
//   chain_iv     - Pointer to a 16-byte writable buffer. After the operation
//                  completes the kernel writes the updated IV here, which can
//                  be used as the IV for a subsequent CBC operation on the next
//                  chunk of data. May be NULL if IV chaining is not needed.
//   chain_iv_len - Length of the chain_iv buffer in bytes. Must be 16, or 0 if
//                  chain_iv is NULL.
//   callback     - Function to call when the operation completes.
//   opaque       - Opaque pointer passed through to the callback.
//
// Returns RETURNCODE_SUCCESS if the operation was successfully started, or
// an error returncode if any buffer setup or command fails.
returncode_t libtock_aes_new_cbc_encrypt(const uint8_t* key, uint32_t key_len,
                                         const uint8_t* iv, uint32_t iv_len,
                                         const uint8_t* input, uint32_t input_len,
                                         uint8_t* output, uint32_t output_len,
                                         uint8_t* chain_iv, uint32_t chain_iv_len,
                                         subscribe_upcall callback, void* opaque);

// Decrypt a ciphertext buffer using AES-128 in CBC mode.
//
// CBC (Cipher Block Chaining) reverses the encryption process: each block is
// decrypted and then XORed with the previous ciphertext block (or the IV for
// the first block) to recover the original plaintext.
//
// Parameters:
//   key          - Pointer to the 128-bit (16-byte) decryption key.
//   key_len      - Length of the key buffer in bytes. Must be 16.
//   iv           - Pointer to the 16-byte initialization vector that was used
//                  when the data was encrypted.
//   iv_len       - Length of the IV buffer in bytes. Must be 16.
//   input        - Pointer to the ciphertext data to decrypt. Length must be a
//                  multiple of 16 bytes (the AES block size).
//   input_len    - Length of the input buffer in bytes.
//   output       - Pointer to a buffer where the plaintext will be written.
//                  Must be at least `input_len` bytes.
//   output_len   - Length of the output buffer in bytes.
//   chain_iv     - Pointer to a 16-byte writable buffer. After the operation
//                  completes the kernel writes the updated IV here, which can
//                  be used as the IV for a subsequent CBC operation on the next
//                  chunk of data. May be NULL if IV chaining is not needed.
//   chain_iv_len - Length of the chain_iv buffer in bytes. Must be 16, or 0 if
//                  chain_iv is NULL.
//   callback     - Function to call when the operation completes.
//   opaque       - Opaque pointer passed through to the callback.
//
// Returns RETURNCODE_SUCCESS if the operation was successfully started, or
// an error returncode if any buffer setup or command fails.
returncode_t libtock_aes_new_cbc_decrypt(const uint8_t* key, uint32_t key_len,
                                         const uint8_t* iv, uint32_t iv_len,
                                         const uint8_t* input, uint32_t input_len,
                                         uint8_t* output, uint32_t output_len,
                                         uint8_t* chain_iv, uint32_t chain_iv_len,
                                         subscribe_upcall callback, void* opaque);

#ifdef __cplusplus
}
#endif
