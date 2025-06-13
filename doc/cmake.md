CMake
=====

wip docs for how libtock-c uses cmake

right now just using this file to keep notes about things
that SHOULD be documented later

new prereqs
cmake, ninja

explain layering
- presets
- toolchain files
- platform modules
- regular modules
- cmakelists

contract between toolchain file and other modules,
i.e. what must toolchain provide in order to work with tock

options for libc - can be provided by toolchain or use
prebuilt newlib
TOCK_NEWLIB
TOCK_NEWLIB_SUBDIR
TOCK_NEWLIB_LIBDIR
