#
# Print a message only if the `VERBOSE_OUTPUT` option is on
#
function(verbose_message content)
    if(${PROJECT_NAME_UPPERCASE}_VERBOSE_OUTPUT)
        message(STATUS ${content})
    endif()
endfunction()

function(print_project_configuration)
    message(
        STATUS 
        "CMake ${CMAKE_VERSION} successfully configured ${PROJECT_NAME} using ${CMAKE_GENERATOR} generator"
    )
    message(STATUS "${PROJECT_NAME} package version: ${CMAKE_PROJECT_VERSION}")
    message(
        STATUS
        "${PROJECT_NAME} package dependencies: ${${PROJECT_NAME}_DEPENDENCIES}"
    )
    message(
        STATUS
        "${PROJECT_NAME} shared libraries: ${${PROJECT_NAME_UPPERCASE}_BUILD_SHARED_LIBS}"
    )
    if(${BUILD_SHARED_LIBS})
        message(STATUS "Building dynamic libraries")
    else()
        message(STATUS "Building static libraries")
    endif()
    message(STATUS "[cmake] Installation target path: ${CMAKE_INSTALL_PREFIX}")
    if(CMAKE_TOOLCHAIN_FILE)
        message(STATUS "[cmake] Use toolchain file: ${CMAKE_TOOLCHAIN_FILE}")
    endif()
    string(TOUPPER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)
    message(STATUS "[cmake] Build for OS type:      ${CMAKE_SYSTEM_NAME}")
    message(STATUS "[cmake] Build for OS version:   ${CMAKE_SYSTEM_VERSION}")
    message(STATUS "[cmake] Build for CPU type:     ${CMAKE_SYSTEM_PROCESSOR}")
    message(STATUS "[cmake] Build type:             ${CMAKE_BUILD_TYPE}")
    message(
        STATUS
        "[cmake] Build with cxx flags:   ${CMAKE_CXX_FLAGS_${BUILD_TYPE}} ${CMAKE_CXX_FLAGS}"
    )
    message(
        STATUS
        "[cmake] Build with c flags:     ${CMAKE_C_FLAGS_${BUILD_TYPE}} ${CMAKE_C_FLAGS}"
    )
    message(STATUS "[cmake] Source Directory:       ${CMAKE_SOURCE_DIR}")
endfunction()