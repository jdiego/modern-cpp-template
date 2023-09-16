cmake_minimum_required(VERSION 3.22)

if (${CMAKE_PROJECT_NAME})
    set(MODULE_NAME ${CMAKE_PROJECT_NAME})
else()
    set(MODULE_NAME modern_cpp_project)
endif()

project(Standalone LANGUAGES CXX)

# --- Import tools ----

include(../cmake/Utils.cmake)

# ######################################################################################################################
# Options
# ######################################################################################################################
option(STANDALONE_USE_INSTALLED_VERSION "Test the version found by find_package" OFF)
option(CPM_USE_LOCAL_PACKAGES "Always try to use `find_package` to get dependencies" TRUE)
# ---- Dependencies ----

include(../cmake/CPM.cmake)

CPMAddPackage(
  GITHUB_REPOSITORY jarro2783/cxxopts
  VERSION 3.0.0
  OPTIONS "CXXOPTS_BUILD_EXAMPLES NO" "CXXOPTS_BUILD_TESTS NO" "CXXOPTS_ENABLE_INSTALL YES"
)

if(STANDALONE_USE_INSTALLED_VERSION)
    find_package(${MODULE_NAME} REQUIRED)
elseif(PROJECT_IS_TOP_LEVEL)
    CPMAddPackage(NAME ${MODULE_NAME} SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)
endif()

# ---- Create standalone executable ----

file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)

add_executable(${PROJECT_NAME} ${sources})

set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 23 OUTPUT_NAME ${MODULE_NAME})

target_link_libraries(${PROJECT_NAME} ${MODULE_NAME} cxxopts)
