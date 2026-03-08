cmake_minimum_required(VERSION 3.25...4.2)

project(Standalone LANGUAGES CXX)

set(APP_EXECUTABLE_NAME "modern_cpp_app")
set(LIBRARY_TARGET_NAME "modern_cpp_project")

# ---- Include Custom CMake Modules ----
include(../cmake/Utils.cmake)

# ---- Dependency Management ----
include(../cmake/CPM.cmake)
include(../cmake/PackageProject.cmake)

if(NOT TARGET ${LIBRARY_TARGET_NAME})
    # When invoked standalone; when used via add_subdirectory the target already exists
    CPMAddPackage(NAME ${LIBRARY_TARGET_NAME} SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/.. FORCE ON)
endif()

CPMAddPackage(
    NAME cxxopts
    GITHUB_REPOSITORY jarro2783/cxxopts
    VERSION 3.0.0
    OPTIONS "CXXOPTS_BUILD_EXAMPLES OFF" "CXXOPTS_BUILD_TESTS OFF"
)

# ---- Build Executable ----
file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
add_executable(${APP_EXECUTABLE_NAME} ${sources})

target_compile_features(${APP_EXECUTABLE_NAME} PRIVATE cxx_std_23)

set_target_properties(${APP_EXECUTABLE_NAME} PROPERTIES
    OUTPUT_NAME ${APP_EXECUTABLE_NAME}
)

target_link_libraries(${APP_EXECUTABLE_NAME}
    PRIVATE
    ${LIBRARY_TARGET_NAME}::${LIBRARY_TARGET_NAME}
    cxxopts::cxxopts
)