cmake_minimum_required(VERSION 3.22)

if (${CMAKE_PROJECT_NAME})
    set(MODULE_NAME ${CMAKE_PROJECT_NAME})
else()
    set(MODULE_NAME modern_cpp_project)
endif()

set(TEST_SUITE ${MODULE_NAME}TestRunner)
project(${TEST_SUITE} LANGUAGES CXX)

message(STATUS "Started ${TEST_SUITE} Test Suite for ${CMAKE_PROJECT_NAME}...\n")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


include(../cmake/Utils.cmake)
# ######################################################################################################################
# Options
# ######################################################################################################################
option(TEST_USE_INSTALLED_VERSION "Test the version found by find_package" OFF)
option(CPM_USE_LOCAL_PACKAGES "Always try to use `find_package` to get dependencies" TRUE)

# ######################################################################################################################
# Dependencies
# ######################################################################################################################
include(../cmake/CPM.cmake)

CPMAddPackage(
    NAME doctest
    GITHUB_REPOSITORY doctest/doctest
    VERSION 2.4.11
)
CPMAddPackage("gh:TheLartians/Format.cmake@1.7.3")

if(TEST_USE_INSTALLED_VERSION)
    find_package(${MODULE_NAME} REQUIRED)
elseif(PROJECT_IS_TOP_LEVEL)
    CPMAddPackage(NAME ${MODULE_NAME} SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)
    # needed to generate test target
    enable_testing()
endif()

# ######################################################################################################################
# Adding unit test files
# ######################################################################################################################
file(GLOB TEST_SOURCES CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
verbose_message("Adding ${TEST_SOURCES} to ${TEST_SUITE} test suite.")

# ######################################################################################################################
# Create binary 
# ######################################################################################################################
add_executable(${TEST_SUITE} ${TEST_SOURCES})
target_compile_features(${TEST_SUITE} PRIVATE cxx_std_23)
target_link_libraries(${TEST_SUITE} doctest::doctest ${MODULE_NAME})

# ######################################################################################################################
# Enable compiler warnings
# ######################################################################################################################
if(NOT TEST_USE_INSTALLED_VERSION)
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        target_compile_options(${MODULE_NAME} PUBLIC -Wall -Wpedantic -Wextra -Werror)
    elseif(MSVC)
        target_compile_options(${MODULE_NAME} PUBLIC /W4 /WX)
        target_compile_definitions(${TEST_SUITE} PUBLIC DOCTEST_CONFIG_USE_STD_HEADERS)
    endif()

    target_compile_definitions(${TEST_SUITE} PUBLIC DOCTEST_CONFIG_USE_STD_HEADERS)
endif()

# ######################################################################################################################
# ---- Add Tests ----
# ######################################################################################################################
# Note: doctest and similar testing frameworks can automatically configure CMake tests. 
# For other testing frameworks add the tests target instead: 
# add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})

# testing frameworks add the tests target instead:
if(NOT doctest_SOURCE_DIR)
    add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})
else()
    include(${doctest_SOURCE_DIR}/scripts/cmake/doctest.cmake)
    doctest_discover_tests(${TEST_SUITE})
endif()



# ######################################################################################################################
# Setup code coverage if enabled
# ######################################################################################################################
if (${MODULE_NAME}_ENABLE_CODE_COVERAGE OR ENABLE_CODE_COVERAGE)
  # ---- code coverage ----
  target_compile_options(${MODULE_NAME} PUBLIC -O0 -g -fprofile-arcs -ftest-coverage)
  target_link_options(${MODULE_NAME} PUBLIC -fprofile-arcs -ftest-coverage)
endif()


verbose_message("Finished adding unit tests for ${MODULE_NAME}.")
