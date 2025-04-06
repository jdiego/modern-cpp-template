cmake_minimum_required(VERSION 3.24...3.31)

set(MODULE_NAME modern_cpp_project)
set(TEST_SUITE ModernCppProjectTestRunner)

project(${TEST_SUITE} LANGUAGES CXX)

# ######################################################################################################################
# Options
# ######################################################################################################################
option(TEST_USE_INSTALLED_VERSION "Test the version found by find_package" OFF)
option(CPM_USE_LOCAL_PACKAGES "Always try to use `find_package` to get dependencies" TRUE)


include(../cmake/Utils.cmake)
include(../cmake/PackageProject.cmake)
# ######################################################################################################################
# Dependencies
# ######################################################################################################################
include(../cmake/CPM.cmake)

CPMAddPackage(
    NAME ut
    GITHUB_REPOSITORY boost-ext/ut
    VERSION  2.3.0
)

CPMAddPackage("gh:TheLartians/Format.cmake@1.8.1")

if(TEST_USE_INSTALLED_VERSION)
    find_package(${MODULE_NAME} REQUIRED)
else()
    CPMAddPackage(NAME ${MODULE_NAME} SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/.. FORCE ON)
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
#add_dependencies(${TEST_SUITE} ${MODULE_NAME})


get_target_property(ut_include_dirs Boost::ut INTERFACE_INCLUDE_DIRECTORIES)
target_include_directories(${TEST_SUITE} PRIVATE ${ut_SOURCE_DIR}/include)
target_link_libraries(${TEST_SUITE} PRIVATE Boost::ut ${MODULE_NAME}::${MODULE_NAME})

target_compile_features(${TEST_SUITE} PRIVATE cxx_std_23)

# ######################################################################################################################
# Enable compiler warnings
# ######################################################################################################################
if(NOT TEST_USE_INSTALLED_VERSION)
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        target_compile_options(${MODULE_NAME} PUBLIC -Wall -Wpedantic -Wextra -Werror)
    elseif(MSVC)
        target_compile_options(${MODULE_NAME} PUBLIC /W4 /WX)
    endif()
endif()
# ######################################################################################################################
# ---- Enabling Tests ----
# ######################################################################################################################
enable_testing()
# Note: doctest and similar testing frameworks can automatically configure CMake tests.
# For other testing frameworks add the tests target instead:
# add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})
add_test(NAME ${TEST_SUITE} COMMAND ${TEST_SUITE})

# ######################################################################################################################
# Setup code coverage if enabled
# ######################################################################################################################
if (${MODULE_NAME}_ENABLE_CODE_COVERAGE OR ENABLE_CODE_COVERAGE)
    # ---- code coverage ----
    target_compile_options(${MODULE_NAME} PUBLIC -O0 -g -fprofile-arcs -ftest-coverage)
    target_link_options(${MODULE_NAME} PUBLIC -fprofile-arcs -ftest-coverage)
endif()


message(STATUS "Finished adding unit tests for ${TEST_SUITE}.")
