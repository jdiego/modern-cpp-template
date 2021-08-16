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
source_group(
    TREE "${CMAKE_SOURCE_DIR}/include"
    PREFIX "Header Files"
    FILES ${HEADER_LIST})

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
verbose_message("Added all header and implementation files.\n")

#
# Set the project standard and warnings
#
if(${LIBNAME}_BUILD_HEADERS_ONLY)
    target_compile_features(${LIBNAME} INTERFACE cxx_std_20)
else()
    target_compile_features(${LIBNAME} PUBLIC cxx_std_20)
endif()

#
set_project_warnings(${LIBNAME})
verbose_message("Applied compiler warnings. Using standard ${CMAKE_CXX_STANDARD}.\n")

# Link dependencies

# Identify and link with the specific "packages" the project uses
target_link_libraries(${LIBNAME} PRIVATE Threads::Threads fmt::fmt)

# Set the build/user include directories Allow usage of header files in the
# `src` directory, but only for utilities
if(${LIBNAME}_BUILD_HEADERS_ONLY)
    target_include_directories(${LIBNAME} 
        INTERFACE 
            $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
            $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
    )
else()
    target_include_directories(
        ${LIBNAME}
        PUBLIC 
            $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
            $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
        PRIVATE 
            ${CMAKE_SOURCE_DIR}/src
    )
endif()

verbose_message("Finished setting up include directories.")

# Provide alias to library for
add_library(${LIBNAME}::${LIBNAME} ALIAS ${LIBNAME})

# Exporting
#set_target_properties(${LIBNAME} PROPERTIES EXPORT_NAME ${LIBNAME})
# So that another folders could refer to it without finding the package.
#export(PACKAGE ${LIBNAME})

verbose_message("Project is now aliased as ${LIBNAME}::${LIBNAME}.\n")
