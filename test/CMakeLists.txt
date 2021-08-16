cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

set(ProjectModule ${CMAKE_PROJECT_NAME})
set(TestLib ${CMAKE_PROJECT_NAME}TestSuite)
#
project(${TestLib} LANGUAGES CXX)

include (../cmake/StandardSettings)

# ---- Options ----
option(TEST_INSTALLED_VERSION "Test the version found by find_package" OFF)

verbose_message("Adding tests under ${TestLib}.../${CMAKE_PROJECT_NAME}")

# ---- Dependencies ----
cpmaddpackage("gh:onqtam/doctest#2.4.5")
cpmaddpackage("gh:TheLartians/Format.cmake@1.7.0")

if(TEST_INSTALLED_VERSION)
    find_package(${ProjectModule} REQUIRED)
else()
    #CPMAddPackage(NAME ${ProjectModule} SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)
endif()
#
file(GLOB test_sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
#
add_executable(${TestLib} ${test_sources})

target_link_libraries(${TestLib} doctest::doctest ${ProjectModule})
set_target_properties(${TestLib} PROPERTIES CXX_STANDARD 20)

# enable compiler warnings
if(NOT TEST_INSTALLED_VERSION)
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES
                                              "GNU")
    target_compile_options(${TestLib} PUBLIC -Wall -Wpedantic -Wextra -Werror)
  elseif(MSVC)
    target_compile_options(${TestLib} PUBLIC /W4 /WX)
    target_compile_definitions(${TestLib} PUBLIC DOCTEST_CONFIG_USE_STD_HEADERS)
  endif()
endif()

# ---- code coverage ----
if (${CMAKE_PROJECT_NAME}_ENABLE_CODE_COVERAGE OR ENABLE_CODE_COVERAGE)
  target_compile_options(${TestLib} PUBLIC -O0 -g -fprofile-arcs -ftest-coverage)
  target_link_options(${TestLib} PUBLIC -fprofile-arcs -ftest-coverage)
endif()


# ---- Add ${TestLib}Tests ----
enable_testing()
# Load the desired unit testing framework Note: doctest and similar testing
# frameworks can automatically configure CMake tests. For other testing
# frameworks add the tests target instead: add_test(NAME greeterTests COMMAND
# ${TestLib}Tests)

include(${doctest_SOURCE_DIR}/scripts/cmake/doctest.cmake)
doctest_discover_tests(${TestLib})

verbose_message("Finished adding unit tests for ${CMAKE_PROJECT_NAME}.")
