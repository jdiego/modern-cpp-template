cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

set(LIB_NAME ${CMAKE_PROJECT_NAME})
set(TEST_SUITE ${CMAKE_PROJECT_NAME}-testrunner)
include (Utils)
message(STATUS "Started ${TEST_LIB} Test Suite for ${CMAKE_PROJECT_NAME}...\n")
#
project(${TESTE_SUITE} LANGUAGES CXX)

# ######################################################################################################################
# Options
# ######################################################################################################################
option(TEST_INSTALLED_VERSION "Test the version found by find_package" OFF)
option(CPM_USE_LOCAL_PACKAGES "Always try to use `find_package` to get dependencies" TRUE)


# ######################################################################################################################
# Adding Dependencies
# ######################################################################################################################
CPMAddPackage(
    NAME doctest
    GITHUB_REPOSITORY doctest/doctest
    VERSION 2.4.8
)

if(TEST_INSTALLED_VERSION)
    find_package(${LIB_NAME} REQUIRED)
elseif(NOT ${${PROJECT_NAME_UPPERCASE}_ENABLE_TESTING})
    verbose_message("Adding {LIB_NAME}.")
    CPMAddPackage(NAME ${ProjectModule} SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)
endif()

# ######################################################################################################################
# Adding unit test files
# ######################################################################################################################
file(GLOB TEST_SOURCES CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
verbose_message("Adding ${TEST_SOURCES} to ${TEST_SUITE} test suite.")
add_executable(${TEST_SUITE} ${TEST_SOURCES})
# ######################################################################################################################
# Set the compiler standard
# ######################################################################################################################
set_target_properties(${TEST_SUITE} PROPERTIES CXX_STANDARD 17)


target_link_libraries(${TEST_SUITE} doctest::doctest ${LIB_NAME})
# ######################################################################################################################
# Enable compiler warnings
# ######################################################################################################################
if(NOT TEST_INSTALLED_VERSION AND MSVC)
  verbose_message("Setting up DOCTEST to ${TEST_SUITE} test suite on MSCV.")
  target_compile_definitions(${TEST_SUITE} PUBLIC DOCTEST_CONFIG_USE_STD_HEADERS)
endif()

# ######################################################################################################################
# Setup code coverage if enabled
# ######################################################################################################################
if (${CMAKE_PROJECT_NAME}_ENABLE_CODE_COVERAGE OR ENABLE_CODE_COVERAGE)
  # ---- code coverage ----
  target_compile_options(${CMAKE_PROJECT_NAME} PUBLIC -O0 -g -fprofile-arcs -ftest-coverage)
  target_link_options(${CMAKE_PROJECT_NAME} PUBLIC -fprofile-arcs -ftest-coverage)
endif()


# ######################################################################################################################
# ---- Add ${TestLib}Tests ----
# ######################################################################################################################
enable_testing()
# Load the desired unit testing framework Note: doctest and similar testing
# frameworks can automatically configure CMake tests. For other testing
# frameworks add the tests target instead: add_test(NAME greeterTests COMMAND
# ${TestLib}Tests)

include(${doctest_SOURCE_DIR}/scripts/cmake/doctest.cmake)
doctest_discover_tests(${TEST_SUITE})

verbose_message("Finished adding unit tests for ${CMAKE_PROJECT_NAME}.")
