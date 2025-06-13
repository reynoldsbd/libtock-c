# This file automatically includes a few additional CMake modules which change build behavior, for
# instance TockHardening.cmake.
#
# This module is not intended to be include()-ed directly, but rather injected using
# CMAKE_PROJECT_INCLUDE when building directly from the libtock-c repo. This ensures that downstream
# projects (who typically build out-of-tree and include libtock-c via add_subdirectory()) are not
# polluted with the optional modules unless they explicitly include them.

include_guard(GLOBAL)

include(TockHardening)
