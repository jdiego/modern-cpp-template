# only activate options for top level project
if(NOT PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  return()
endif()

# ---------------------------------------------------------------------------
# Project settings
# ---------------------------------------------------------------------------
option(${PROJECT_NAME}_BUILD_EXECUTABLE "Build the project as an executable, rather than a library." OFF)
option(${PROJECT_NAME}_BUILD_HEADERS_ONLY "Build the project as a header-only library." OFF)
option(${PROJECT_NAME}_USE_ALT_NAMES "Use alternative names for the project, such as naming the include directory all lowercase." ON)
option(${PROJECT_NAME}_VERBOSE_OUTPUT OFF)
option(${PROJECT_NAME}_BUILD_SHARED_LIBS "Build shared libraries" ON)
option(${PROJECT_NAME}_BUILD_WITH_MT "Build libraries as MultiThreaded DLL (Windows Only)" OFF)
option(${PROJECT_NAME}_ENABLE_CCACHE "Enable the usage of Ccache, in order to speed up rebuild times." OFF)
option(${PROJECT_NAME}_VERBOSE_OUTPUT "Enable verbose output, allowing for a better understanding of each step taken." ON)
option(${PROJECT_NAME}_GENERATE_EXPORT_HEADER "Create a `project_export.h` file containing all exported symbols." OFF)
option(${PROJECT_NAME}_THREAD_PREFER_PTHREAD "prefer pthread library on system with multiple thread libraries available")
set(${PROJECT_NAME}_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/include" CACHE STRING "Location of the target's public headers")
set(${PROJECT_NAME}_INCLUDE_DESTINATION  "include" CACHE STRING "Install interface location")
option(CPM_USE_LOCAL_PACKAGES "Always try to use `find_package` to get dependencies" TRUE)
###############################################################################
#          C O M P I L E R    A N D    S Y S T E M    O P T I O N S           #
###############################################################################


# ---------------------------------------------------------------------------
# Compiler Options
# ---------------------------------------------------------------------------
if (${PROJECT_NAME}_VERBOSE_OUTPUT)
    set(CMAKE_VERBOSE_MAKEFILE OFF)
endif()

if(NOT DEFINED CMAKE_CXX_STANDARD)
  # Let's ensure -std=c++xx instead of -std=g++xx
  option(CXX_STANDARD_REQUIRED "Require c++ standard" YES)
  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_EXTENSIONS NO)
endif()

if (${PROJECT_NAME}_THREAD_PREFER_PTHREAD)
    set(THREADS_PREFER_PTHREAD_FLAG TRUE)
endif()

# Configure the visibility of symbols in targets 
# Export all symbols when building a shared library
if(${PROJECT_NAME}_BUILD_SHARED_LIBS)
    #set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS OFF)
    #set(CMAKE_CXX_VISIBILITY_PRESET hidden) 
    #set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
endif()
# ---------------------------------------------------------------------------
# Unit testing
# ---------------------------------------------------------------------------
option(ENABLE_TESTING "Build all tests" FALSE)
option(${PROJECT_NAME}_ENABLE_UNIT_TESTING "Enable unit tests for the ${PROJECT_NAME} (from the `test` subfolder)." ON)

# ---------------------------------------------------------------------------
# Static analyzers
# Currently supporting: Clang-Tidy, Cppcheck.
# ---------------------------------------------------------------------------
option(${PROJECT_NAME}_ENABLE_CLANG_TIDY "Enable static analysis with Clang-Tidy." OFF)
option(${PROJECT_NAME}_ENABLE_CPPCHECK "Enable static analysis with Cppcheck." OFF)

# ---------------------------------------------------------------------------
# Code coverage
# ---------------------------------------------------------------------------
option(ENABLE_CODE_COVERAGE "Enable code coverage for all modules." OFF)
option(${PROJECT_NAME}_ENABLE_CODE_COVERAGE "Enable code coverage." OFF)

if(${PROJECT_NAME}_ENABLE_CCACHE)
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
option(${PROJECT_NAME}_ENABLE_DOXYGEN "Enable module Doxygen documentation." OFF)



