# ##############################################################################
# Create library, setup header and source files
# ##############################################################################

# ---- Add source files ----
set(LIBNAME ${PROJECT_NAME_LOWERCASE})

# ##############################################################################
# Define Options
# ##############################################################################
option(${LIBNAME}_BUILD_HEADERS_ONLY FALSE)

# CMAKE_SOURCE_DIR does indeed refer to the folder where the top-level
# CMakeLists.txt is defined. However, PROJECT_SOURCE_DIR refers to the folder of
# the CMakeLists.txt containing the most recent project() command.

# Note: globbing sources is considered bad practice as CMake's generators may
# not detect new files automatically. Keep that in mind when changing files, or
# explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/include/*.hpp")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/src/*.cpp")

# IDEs should put the headers in a nice place
source_group(TREE "${CMAKE_SOURCE_DIR}/include" PREFIX "Header Files" FILES ${HEADER_LIST})

if(${LIBNAME}_BUILD_HEADERS_ONLY)
    add_library(${LIBNAME} INTERFACE)
else()
    add_library(${LIBNAME} ${headers} ${sources})
endif()

set_target_properties(${LIBNAME}
    PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}"
)