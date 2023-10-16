# ---------------------------------------------------------------------------
# Project settings
# ---------------------------------------------------------------------------
option(${PROJECT_NAME_UPPERCASE}_BUILD_HEADERS_ONLY "Build the project as an header only library." OFF)
option(${PROJECT_NAME_UPPERCASE}_BUILD_EXECUTABLE "Build the project as an executable, rather than a library." OFF)
option(${PROJECT_NAME_UPPERCASE}_BUILD_HEADERS_ONLY "Build the project as a header-only library." OFF)
option(${PROJECT_NAME_UPPERCASE}_VERBOSE_OUTPUT "Turn on verbose mode." ON)
option(${PROJECT_NAME_UPPERCASE}_MAKEFILE_VERBOSE_OUTPUT "Turn on cmake verbose makefile." OFF)
option(${PROJECT_NAME_UPPERCASE}_BUILD_SHARED_LIBS "Build shared libraries." ON)
option(${PROJECT_NAME_UPPERCASE}_BUILD_WITH_MT "Build libraries as MultiThreaded DLL (Windows Only)." OFF)
option(${PROJECT_NAME_UPPERCASE}_ENABLE_CCACHE "Enable the usage of Ccache, in order to speed up rebuild times." OFF)
option(${PROJECT_NAME_UPPERCASE}_VERBOSE_OUTPUT "Enable verbose output, allowing for a better understanding of each step taken." ON)
option(${PROJECT_NAME_UPPERCASE}_GENERATE_EXPORT_HEADER "Create a `project_export.h` file containing all exported symbols." OFF)
option(${PROJECT_NAME_UPPERCASE}_THREAD_PREFER_PTHREAD "prefer pthread library on system with multiple thread libraries available." ON)
option(${PROJECT_NAME_UPPERCASE}_WARNINGS_AS_ERRORS "Make all warnings into errors." OFF)
option(${PROJECT_NAME_UPPERCASE}_BUILD_EXECUTABLE "Build and run a standalone executable target" OFF)
# ---------------------------------------------------------------------------
# Packing options
# ---------------------------------------------------------------------------
set(${PROJECT_NAME_UPPERCASE}_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/include" CACHE STRING "Location of the target's public headers")
set(${PROJECT_NAME_UPPERCASE}_INCLUDE_DESTINATION  "include" CACHE STRING "Install interface location")
option(CPM_USE_LOCAL_PACKAGES "Always try to use `find_package` to get dependencies" TRUE)

###############################################################################
#          C O M P I L E R    A N D    S Y S T E M    O P T I O N S           #
###############################################################################
# ---------------------------------------------------------------------------
# Compiler Options
# ---------------------------------------------------------------------------
option(CXX_STANDARD_REQUIRED "Require C++ Standard" ON)
set(CMAKE_DEBUG_POSTFIX d)
# Always use '-fPIC'/'-fPIE' option.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
#
set(CMAKE_CONFIGURATION_TYPES "Debug" CACHE STRING "" FORCE)


if (${PROJECT_NAME_UPPERCASE}_MAKEFILE_VERBOSE_OUTPUT)
    set(CMAKE_VERBOSE_MAKEFILE ON)
endif()

if(NOT DEFINED CMAKE_CXX_STANDARD)
    # Let's ensure -std=c++xx instead of -std=g++xx
    set(CMAKE_CXX_STANDARD 23)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)
endif()

if (${PROJECT_NAME_UPPERCASE}_THREAD_PREFER_PTHREAD)
    set(THREADS_PREFER_PTHREAD_FLAG TRUE)
endif()

# Configure the visibility of symbols in targets 
# Export all symbols when building a shared library
if(${PROJECT_NAME_UPPERCASE}_BUILD_SHARED_LIBS)
    #set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS OFF)
    #set(CMAKE_CXX_VISIBILITY_PRESET hidden) 
    #set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
    set(BUILD_SHARED_LIBS ON)
endif()

if (${APPLE})
    set(CMAKE_MACOSX_RPATH 1)
endif()

if (UNIX)
    # This will allow to use same _DEBUG macro available in both Linux as well 
    # as Windows - MSCV environment. Easy to put Debug specific code.
    add_compile_options("$<$<CONFIG:DEBUG>:-D_DEBUG>")    
endif (UNIX)

if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
endif()

###############################################################################
# RPATH business
################################################################################
# RPATH - how to properly handle rpath https://cmake.org/Wiki/CMake_RPATH_handling
# RPATH - a list of directories which is linked into the executable, supported on most UNIX systems.
# By default if you don't change any RPATH related settings, CMake will link the
# executables and shared libraries with full RPATH to all used libraries in
# the build tree. When installing, it will clear the RPATH of these targets so
# they are installed with an empty RPATH. The following settings are recommended

# use, i.e. don't skip the full RPATH for the build tree
# Set the Relative Path Configurations
set(CMAKE_SKIP_BUILD_RPATH FALSE)
# when building, don't use the install RPATH already
# (but later on when installing)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# ---------------------------------------------------------------------------
# Unit testing
# ---------------------------------------------------------------------------
option(ENABLE_TESTING "Build all tests" OFF)
option(${PROJECT_NAME_UPPERCASE}_ENABLE_TESTING "Enable unit tests for the ${PROJECT_NAME} (from the `test` subfolder)." ON)

# ---------------------------------------------------------------------------
# Static analyzers
# Currently supporting: Clang-Tidy, Cppcheck.
# ---------------------------------------------------------------------------
option(${PROJECT_NAME_UPPERCASE}_ENABLE_CLANG_TIDY "Enable static analysis with Clang-Tidy." OFF)
option(${PROJECT_NAME_UPPERCASE}_ENABLE_CPPCHECK "Enable static analysis with Cppcheck." OFF)

# ---------------------------------------------------------------------------
# Code coverage
# ---------------------------------------------------------------------------
option(ENABLE_CODE_COVERAGE "Enable code coverage for all modules." OFF)
option(${PROJECT_NAME_UPPERCASE}_ENABLE_CODE_COVERAGE "Enable code coverage." OFF)

if(${PROJECT_NAME_UPPERCASE}_ENABLE_CCACHE)
    find_program(CCACHE_FOUND ccache)
    if(CCACHE_FOUND)
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
        set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
    endif()
endif()


# ---------------------------------------------------------------------------
# Documentation
# ---------------------------------------------------------------------------
option(ENABLE_DOXYGEN "Enable Doxygen documentation builds of source." OFF)
option(${PROJECT_NAME_UPPERCASE}_ENABLE_DOXYGEN "Enable module Doxygen documentation." OFF)




