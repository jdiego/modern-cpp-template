cmake_minimum_required(VERSION 3.24...3.31)

project(Standalone LANGUAGES CXX)

set(APP_EXECUTABLE_NAME "modern_cpp_app")
set(LIBRARY_TARGET_NAME "modern_cpp_project")

# ---- Include Custom CMake Modules ----
include(../cmake/Utils.cmake)

# ---- Dependency Management ----
include(../cmake/CPM.cmake)
include(../cmake/PackageProject.cmake)

CPMAddPackage(NAME ${LIBRARY_TARGET_NAME} SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/.. FORCE ON)

# ---- Build Executable ----
file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
add_executable(${APP_EXECUTABLE_NAME} ${sources})

set_target_properties(${APP_EXECUTABLE_NAME} PROPERTIES
    CXX_STANDARD 23
    OUTPUT_NAME ${APP_EXECUTABLE_NAME}
)

target_link_libraries(${APP_EXECUTABLE_NAME}
    PRIVATE
    ${LIBRARY_TARGET_NAME}::${LIBRARY_TARGET_NAME}
)