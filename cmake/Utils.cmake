#
# Print a message only if the `VERBOSE_OUTPUT` option is on
#
function(verbose_message content)
    if(${PROJECT_NAME}_VERBOSE_OUTPUT)
        message(STATUS ${content})
    endif()
endfunction()

function(add_package)
    list(LENGTH ARGN argnLength)
    if(argnLength EQUAL 1)
        cpm_parse_add_package_single_arg("${ARGN}" ARGN)
        # The shorthand syntax implies EXCLUDE_FROM_ALL
        set(ARGN "${ARGN};EXCLUDE_FROM_ALL;YES")
    endif()
    set(oneValueArgs
        NAME
        FORCE
        VERSION
        GIT_TAG
        DOWNLOAD_ONLY
        GITHUB_REPOSITORY
        GITLAB_REPOSITORY
        BITBUCKET_REPOSITORY
        GIT_REPOSITORY
        SOURCE_DIR
        DOWNLOAD_COMMAND
        FIND_PACKAGE_ARGUMENTS
        NO_CACHE
        GIT_SHALLOW
        EXCLUDE_FROM_ALL
        SOURCE_SUBDIR
    )
    cmake_parse_arguments(CPM_ARGS "" "${oneValueArgs}" "" "${ARGN}")
    message(STATUS "==============================================")
    message(STATUS "CPM: ${CPM_ARGS_NAME}")
    message(STATUS "==============================================")

endfunction()

