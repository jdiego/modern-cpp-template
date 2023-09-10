# only activate for top level project
if(NOT PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  return()
endif()

##############################################################################
#                         C M A K E    C O N T R O L                         #
##############################################################################

# Put the libraries and binaries that get built into directories at the top of 
# the build tree rather than in hard-to-find leaf directories. This simplifies 
# manual testing and the use of the build tre.
set(MAINFOLDER ${PROJECT_SOURCE_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
# Windows DLLs are "runtime" for CMake. 
# Output them to "bin" like the Visual Studio projects do.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
    
# Let's nicely support folders in IDE's
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
if(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json")
    execute_process(
       COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json
       ${CMAKE_CURRENT_SOURCE_DIR}/compile_commands.json
    )
endif()

##############################################################################
# Global Project Settings
##############################################################################
include(${CMAKE_CURRENT_LIST_DIR}/StaticAnalyzers.cmake)

# Testing only available if this is the main app.
# Note this needs to be done in the main CMakeLists since it calls
# enable_testing, which must be in the main CMakeLists.
include(CTest)

# needed to generate test target
enable_testing()