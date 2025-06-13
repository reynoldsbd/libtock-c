# Collection of warnings and other hardening flags for Tock apps and libraries
#
# This file is automatically injected via CMakePresets.json when building directly within the
# libtock-c repository. Out-of-tree projects may choose to include this module at their discretion.

include_guard(DIRECTORY)

# Helper macro to add language-specific compile options
macro(add_language_compile_options language)
    foreach(option ${ARGN})
        add_compile_options($<$<COMPILE_LANGUAGE:${language}>:${option}>)
    endforeach()
endmacro()

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    # Enable source fortification
    # https://www.gnu.org/software/libc/manual/html_node/Source-Fortification.html
    add_compile_definitions(_FORTIFY_SOURCE=2)

    # Warn about sloppy symbol definitions
    add_link_options("LINKER:--warn-common")

    # Treat compiler warnings as errors
    set(CMAKE_COMPILE_WARNING_AS_ERROR ON)

    # Common warning flags for C and C++
    add_compile_options(
        -Wall
        -Wextra
        -Wdate-time                    # warn if __TIME__, __DATE__, or __TIMESTAMP__ used
        -Wfloat-equal                  # floats used with '=' operator, likely imprecise
        -Wformat-nonliteral           # can't check format string
        -Wformat-security             # using untrusted format strings
        -Wformat-y2k                  # use of strftime that assumes two digit years
        -Winit-self                   # { int i = i }
        -Wmissing-declarations        # global functions without declarations
        -Wmissing-field-initializers  # struct initialization without field names, warn if not all used
        -Wmissing-format-attribute    # something looks printf-like but isn't marked as such
        -Wmissing-noreturn           # functions that should be marked __attribute__((noreturn))
        -Wmultichar                  # use of 'foo' instead of "foo"
        -Wpointer-arith              # sizeof on things not defined (i.e. sizeof(void))
        -Wredundant-decls            # redundant declarations
        -Wshadow                     # variable shadowing
        -Wunused-macros              # macro defined in this file not used
        -Wunused-parameter           # function parameter is unused
        -Wwrite-strings              # attempt to modify string literals
        -Wlogical-op                 # suspicious use of logical operators in expressions
        -Wtrampolines                # attempt to generate a trampoline on the NX stack
        -Wstack-usage=$<TARGET_PROPERTY:STACK_SIZE>
    )

    # C-only warning flags
    add_language_compile_options(C
        -Wbad-function-cast          # questionable casts
        -Wmissing-prototypes         # global function defined without prototype
        -Wnested-externs             # misuse of extern keyword
        -Wold-style-definition       # old-style function definitions
        -Wjump-misses-init           # goto or switch skips over variable initialization
    )

    # C++-only warning flags
    add_language_compile_options(CXX
        -Wctor-dtor-privacy          # unusable class because everything private and no friends
        -Wdelete-non-virtual-dtor    # catches undefined behavior with virtual destructors
        -Wold-style-cast             # C-style cast in C++ code
        -Woverloaded-virtual         # subclass shadowing makes parent implementations unavailable
        -Wsign-promo                 # gcc did what spec requires, but probably not what you want
        -Wstrict-null-sentinel       # strict null sentinel checking
        -Wsuggest-final-methods      # methods that could be marked final
        -Wsuggest-final-types        # types that could be marked final
        -Wsuggest-override           # overridden virtual function without override keyword
        -Wuseless-cast               # unnecessary casts
        -Wzero-as-null-pointer-constant  # use of 0 as NULL in C++
    )

    # Commented out flags from Configuration.mk that were deemed too noisy or problematic:
    #
    # -Wcast-qual                   # const char* -> char* (noisy with libnrfserialization)
    # -Wswitch-default              # switch without default (doesn't cover all cases)
    # -Wstrict-prototypes           # function defined without specifying argument types (C-only, noisy)
    # -Wabi -Wabi-tag               # inter-compiler ABI issues
    # -Waggregate-return            # warn if things return structs
    # -Wcast-align                  # alignment issues in casts
    # -Wconversion                  # implicit conversion warnings (too many from syscalls)
    # -Wdisabled-optimization       # gcc skipped optimization
    # -Wdouble-promotion            # warn if float -> double implicitly
    # -Wformat-signedness           # format string signedness issues (too obnoxious)
    # -Wfloat-conversion            # subset of -Wconversion
    # -Winline                      # something marked inline wasn't inlined
    # -Winvalid-pch                 # bad precompiled header
    # -Wmissing-include-dirs        # missing include directories
    # -Woverlength-strings          # compiler compatibility for long strings
    # -Wpacked                      # struct with packed attribute that does nothing
    # -Wpadded                      # padding added to struct (noisy for argument structs)
    # -Wpedantic                    # strict ISO C/C++
    # -Wsign-conversion             # implicit integer sign conversions
    # -Wstack-protector             # only if -fstack-protector
    # -Wsuggest-attribute=const     # suggest const attribute (noisy)
    # -Wsuggest-attribute=pure      # suggest pure attribute (noisy)
    # -Wswitch-enum                 # switch of enum doesn't cover all cases (annoying)
    # -Wsystem-headers              # warnings from system headers
    # -Wtraditional                 # traditional C compatibility
    # -Wundef                       # undefined identifier in #if (too much noise from libraries)
    # -Wunsafe-loop-optimizations   # compiler can't determine loop bounds
    # -Wvariadic-macros             # variadic macros can't be used in ISO C
    # -Wvector-operation-performance # vector operation performance
    # -Wvla                         # variable length arrays
    # -Wunsuffixed-float-constants  # float constant issues (doesn't work right)
    # -Wtraditional-conversion      # prototype causes different conversion (very noisy)
    #
    # C++-specific flags that were commented out:
    # -Wc++-compat                  # C/C++ compatibility issues
    # -Wc++11-compat                # C++11 compatibility
    # -Wc++14-compat                # C++14 compatibility  
    # -Wconditionally-supported     # conditionally-supported constructs
    # -Weffc++                      # Effective C++ style violations
    # -Wmultiple-inheritance        # multiple inheritance warnings
    # -Wnamespaces                  # namespace usage warnings
    # -Wnoexcept                    # missing noexcept
    # -Wnon-virtual-dtor            # non-virtual destructor
    # -Wsynth                       # legacy flag
    # -Wtemplates                   # template usage warnings
    # -Wvirtual-inheritance         # virtual inheritance warnings
else()
    message(WARNING "Hardening flags are not supported for compiler ${CMAKE_C_COMPILER_ID}")
endif()
