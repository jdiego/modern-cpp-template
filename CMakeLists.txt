cmake_minimum_required(VERSION 3.22)

# ######################################################################################################################
# Define the Project Name and Description
# ######################################################################################################################
project(
    modern_cpp_project
    VERSION 1.0.0
    LANGUAGES CXX
    DESCRIPTION "ModernCppProject is a project template for Modern C++"
)

# Make sure that custom modules are found
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# ######################################################################################################################
# Include guards: Prevent building in the source directory
# ######################################################################################################################
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.\n")
endif()


include(CheckCXXCompilerFlag)
include(CheckTypeSize)
include(CMakePrintHelpers)
include(cmake/Utils.cmake)
include(cmake/CompilerWarnings.cmake) 

# ######################################################################################################################
# Import top level settings.
# Warning: They only activate for top level project, and not if it is included through add_subdirectory
# ######################################################################################################################
include(cmake/GlobalSettings.cmake) 

# ######################################################################################################################
# Setup project : Import standard settings
# ######################################################################################################################
include(cmake/StandardSettings.cmake)


message(STATUS "Started CMake for ${PROJECT_NAME} v${PROJECT_VERSION}...\n")
# ######################################################################################################################
# Add dependencies
# ######################################################################################################################
include(cmake/CPM.cmake)
CPMAddPackage("gh:TheLartians/Format.cmake@1.7.3")

# PackageProject.cmake will be used to make our target installable
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.11.0")

# Collect the built libraries and include directories
# A semicolon separated list of the project's dependencies
set(${PROJECT_NAME}_DEPENDENCIES "")

CPMAddPackage(
  NAME fmt
  GIT_TAG 10.1.1
  GITHUB_REPOSITORY fmtlib/fmt
  OPTIONS "FMT_INSTALL YES" # create an installable target
)
list(APPEND ${PROJECT_NAME}_DEPENDENCIES "fmt 10.1.1")

CPMAddPackage(
    NAME spdlog
    GITHUB_REPOSITORY gabime/spdlog
    VERSION 1.12.0
    OPTIONS "SPDLOG_INSTALL YES" "SPDLOG_FMT_EXTERNAL YES" # create an installable target and force uses a external fmt
)

list(APPEND ${PROJECT_NAME}_DEPENDENCIES "spdlog 1.12.0")


# ######################################################################################################################
# Source tree
# ######################################################################################################################
#add_subdirectory(src)

file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

add_library(${PROJECT_NAME} ${headers} ${sources})
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 23)
# being a cross-platform target, we enforce standards conformance on MSVC
target_compile_options(${PROJECT_NAME} PUBLIC "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive->")



# Link dependencies
target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt spdlog::spdlog)

target_include_directories(
    ${PROJECT_NAME} 
    PUBLIC 
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
    # Set the build/user include directories to allow usage of header files in the
    # `src` directory, but only for utilities
    PRIVATE 
        ${CMAKE_SOURCE_DIR}/src
)

# ######################################################################################################################
# Add version header
# the location where the project's version header will be placed should match the project's regular header paths
# ######################################################################################################################
set(VERSION_HEADER_LOCATION "${PROJECT_NAME_LOWERCASE}/version.hpp")
configure_file(${CMAKE_CURRENT_LIST_DIR}/cmake/version.hpp.in ${VERSION_HEADER_LOCATION} @ONLY)

# ######################################################################################################################
# Create an installable target
# ######################################################################################################################
packageProject(
    # the name of the target to export
    NAME ${PROJECT_NAME}
    # the version of the target to export
    VERSION ${PROJECT_VERSION}
    # (optional) install your library with a namespace (Note: do NOT add extra '::')
    NAMESPACE ${PROJECT_NAME}
    # a temporary directory to create the config files
    BINARY_DIR ${PROJECT_BINARY_DIR}
    # location of the target's public headers
    # A.K.A Install the `include` directory
    INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include
    # Install the `include` directory.
    # NOTE: should match the target's INSTALL_INTERFACE include directory
    INCLUDE_DESTINATION include/${PROJECT_NAME}-${PROJECT_VERSION}
    # (optional) create a header containing the version info
    # Note: that the path to headers should be lowercase
    VERSION_HEADER "${VERSION_HEADER_LOCATION}"
    
    # (optional) create a export header using GenerateExportHeader module
    #EXPORT_HEADER "${PROJECT_NAME}/export.hpp"

    # (optional) define the project's version compatibility, defaults to `AnyNewerVersion`
    # supported values: `AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion`
    COMPATIBILITY SameMajorVersion
    # semicolon separated list of the project's dependencies
    DEPENDENCIES "${${PROJECT_NAME}_DEPENDENCIES}"
    # (optional) option to disable the versioning of install destinations
    DISABLE_VERSION_SUFFIX YES
    # (optional) option to ignore target architecture for package resolution
    # defaults to YES for header only (i.e. INTERFACE) libraries
    ARCH_INDEPENDENT YES
)


# ######################################################################################################################
# Add uninstall target
# ######################################################################################################################
CONFIGURE_FILE(
   "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
   "${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
   IMMEDIATE @ONLY)

ADD_CUSTOM_TARGET(uninstall
    "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
)


# ######################################################################################################################
# Unit testing setup: Testing only available if this is the main app
# ######################################################################################################################
if (CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME AND ${PROJECT_NAME_UPPERCASE}_ENABLE_TESTING) AND BUILD_TESTING)
    message(STATUS "Build unit tests for the project. Tests should always be found in the test folder\n")
    add_subdirectory(test)
endif()

# ######################################################################################################################
# INFO
# ######################################################################################################################
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    message(STATUS "CMake ${CMAKE_VERSION} successfully configured ${PROJECT_NAME} using ${CMAKE_GENERATOR} generator")
    message(STATUS "${PROJECT_NAME} package version: ${CMAKE_PROJECT_VERSION}")
    message(STATUS "${PROJECT_NAME} package dependencies: ${${PROJECT_NAME}_DEPENDENCIES}")
    if(BUILD_SHARED_LIBS)
        message(STATUS "Building dynamic libraries")
    else()
        message(STATUS "Building static libraries")
    endif()
    message(STATUS "[cmake] Installation target path: ${CMAKE_INSTALL_PREFIX}")
    if(CMAKE_TOOLCHAIN_FILE)
        message(STATUS "[cmake] Use toolchain file:		${CMAKE_TOOLCHAIN_FILE}")
    endif()
    string(TOUPPER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
    message(STATUS "[cmake] Build for OS type:      ${CMAKE_SYSTEM_NAME}")
    message(STATUS "[cmake] Build for OS version:   ${CMAKE_SYSTEM_VERSION}")
    message(STATUS "[cmake] Build for CPU type:     ${CMAKE_SYSTEM_PROCESSOR}")
    message(STATUS "[cmake] Build type:             ${CMAKE_BUILD_TYPE}")
    message(STATUS "[cmake] Build with cxx flags:   ${CMAKE_CXX_FLAGS_${BUILD_TYPE}} ${CMAKE_CXX_FLAGS}")
    message(STATUS "[cmake] Build with c flags:     ${CMAKE_C_FLAGS_${BUILD_TYPE}} ${CMAKE_C_FLAGS}")
    message(STATUS "[cmake] Source Directory:       ${CMAKE_SOURCE_DIR}")
    message(STATUS "[cmake] Project Directory:      ${PROJECT_SOURCE_DIR}")
endif()