#pragma once

#include <stdint.h>
#include <stddef.h>

#include "../../tock.h"

#ifdef __cplusplus
extern "C" {
#endif

// Performs AES-CTR encryption or decryption.
//
// Note: In CTR mode, encryption and decryption are the same operation.
//
// The key and key_len parameters provide the AES key. The length of the key determines the strength
// of the AES operation: 16 bytes for AES-128 and 32 bytes for AES-256. If any other value is passed
// for key_len, this function will return EINVAL.
//
// The iv parameter provides the initialization vector for the operation. The length of the buffer
// is assumed to exactly match the AES block size (16 bytes). On input, the given value will be used
// as the IV for the first CTR block, then incremented for each subsequent block. After all CTR
// operations have completed and this function returns, the iv buffer will be updated to contain a
// new IV value suitable for chaining to the _next_ CTR operation.
//
// The input and input_len parameters provide the data to be encrypted or decrypted. The input_len
// must be a multiple of the AES block size, or else this function will return EINVAL.
//
// The output parameter provides the buffer where the encrypted or decrypted data is stored. The
// length of this buffer is assumed to exactly match the input_len parameter.
returncode_t aes_ctr_crypt(
    const uint8_t *key, size_t key_len,
    uint8_t *iv,
    const uint8_t *input, size_t input_len,
    uint8_t *output
);

#ifdef __cplusplus
}
#endif
