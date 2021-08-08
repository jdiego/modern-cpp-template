cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# Make sure that custom modules are found
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Enables the Visibility Property on all target types
cmake_policy(SET CMP0063 NEW)
# Enables the MSVC_RUNTIME_LIBRARY property on targets
cmake_policy(SET CMP0091 NEW)


# Define the Project Name and Description
project(modern_cpp_project VERSION 1.0.0 LANGUAGES CXX DESCRIPTION "moderncpp-project is a starter project for Modern C++")

# Set Project version (used for library versioning and for CPack)
set(CMAKE_PROJECT_VERSION ${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR}.${CMAKE_PROJECT_VERSION_PATCH})
set(${PROJECT_NAME}_USE_ALT_NAMES TRUE)

if(${PROJECT_NAME}_USE_ALT_NAMES)
    string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWERCASE)
    string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPERCASE)
else()
    set(PROJECT_NAME_LOWERCASE ${PROJECT_NAME})
    set(PROJECT_NAME_UPPERCASE ${PROJECT_NAME})
endif()

#################################################################################
# Project Settings
#################################################################################

# Only do these if this is the main project, and not if it is included through add_subdirectory
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    # Put the libraries and binaries that get built into directories at the
    # top of the build tree rather than in hard-to-find leaf
    # directories. This simplifies manual testing and the use of the build
    # tree rather than installed Boost libraries.
    set(MAINFOLDER ${PROJECT_SOURCE_DIR})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
    # Windows DLLs are "runtime" for CMake. 
    # Output them to "bin" like the Visual Studio projects do.
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

    # Must use GNUInstallDirs to install libraries into correct
    # locations on all platforms.
    include(GNUInstallDirs)

    # Let's nicely support folders in IDE's
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)

    # Generate the compile_commands.json file
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
    if( EXISTS "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" )
        EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json
        ${CMAKE_CURRENT_SOURCE_DIR}/compile_commands.json
    )
    endif()
    # Let's ensure -std=c++xx instead of -std=g++xx
    set( CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)
    
    # Always use '-fPIC'/'-fPIE' option.
    set( CMAKE_POSITION_INDEPENDENT_CODE ON )
   
    #
    set(CMAKE_CONFIGURATION_TYPES "Debug" CACHE STRING "" FORCE)
    set(CMAKE_VERBOSE_MAKEFILE OFF)

    # Set the Relative Path Configurations
    set(CMAKE_SKIP_BUILD_RPATH FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    
    # Configure the visibility of symbols in targets
    #set(CMAKE_CXX_VISIBILITY_PRESET hidden)
    #set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

    # Testing only available if this is the main app
    # Note this needs to be done in the main CMakeLists
    # since it calls enable_testing, which must be in the
    # main CMakeLists.
    include(CTest)

    # Docs only available if this is the main app
    find_package(Doxygen)
    if(Doxygen_FOUND)
        add_subdirectory(docs)
    else()
        message(STATUS "Doxygen not found, not building docs")
    endif()

    ################################################################################
    # Define Options
    ################################################################################
    option(BUILD_TESTING "Build tests" FALSE)
    option(BUILD_SHARED_LIBS "Build shared libraries" TRUE)
    option(BUILD_WITH_MT "Build libraries as MultiThreaded DLL (Windows Only)" FALSE)
    option(${PROJECT_NAME}_VERBOSE_OUTPUT TRUE)

endif()


################################################################################
# Define CMake Module Imports
################################################################################
include(CMakePackageConfigHelpers)
include(InstallRequiredSystemLibraries)
include(GenerateExportHeader)

# Setup C/C++ compiler options
# Compiler settings - special settings for known compilers
include(CheckCXXCompilerFlag)
include(CMakePackageConfigHelpers)
include(CheckTypeSize)
include(CMakePrintHelpers)
include(CompilerWarnings)

include(CPM)
include(Utils)

#################################################################################
# The location where the project's version header will be placed should match 
# the project's regular header paths. This allows users to install and find the 
# library via `find_package()`.
#################################################################################
set(VERSION_HEADER_LOCATION "${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME_LOWERCASE}/version.hpp")

configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/cmake/version.hpp.in 
    ${VERSION_HEADER_LOCATION} 
    @ONLY
)

################################################################################
# Add dependencies
################################################################################
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
#################################################################################
# Source tree
#################################################################################
add_subdirectory(extern)
add_subdirectory(src)

#################################################################################
# PACKING
#################################################################################


#################################################################################
# Unit testing setup
#################################################################################
if(${BUILD_TESTING})
    message(STATUS "Build unit tests for the project. Tests should always be found in the test folder\n")
    add_subdirectory(test)
endif()


if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)

    message(STATUS "CMake ${CMAKE_VERSION} successfully configured ${PROJECT_NAME} using ${CMAKE_GENERATOR} generator")
    message(STATUS "${PROJECT_NAME} package version: ${CMAKE_PROJECT_VERSION}")
    if(BUILD_SHARED_LIBS)
    	message(STATUS "Building dynamic libraries")
    else()
    	message(STATUS "Building static libraries")
    endif()
    message(STATUS "[cmake] Installation target path: ${CMAKE_INSTALL_PREFIX}")
    if(CMAKE_TOOLCHAIN_FILE)
    	message(STATUS "[cmake] Use toolchain file:		${CMAKE_TOOLCHAIN_FILE}")
    endif()
    message(STATUS "[cmake] Build for OS type:      ${CMAKE_SYSTEM_NAME}")
    message(STATUS "[cmake] Build for OS version:   ${CMAKE_SYSTEM_VERSION}")
    message(STATUS "[cmake] Build for CPU type:     ${CMAKE_SYSTEM_PROCESSOR}")
    message(STATUS "[cmake] Build type:             ${CMAKE_BUILD_TYPE}")
    string(TOUPPER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
    message(STATUS "[cmake] Build with cxx flags:   ${CMAKE_CXX_FLAGS_${BUILD_TYPE}} ${CMAKE_CXX_FLAGS}")
    message(STATUS "[cmake] Build with c flags:     ${CMAKE_C_FLAGS_${BUILD_TYPE}} ${CMAKE_C_FLAGS}")
endif()
