#
# Print a message only if the `VERBOSE_OUTPUT` option is on
#
function(verbose_message content)
    if(${PROJECT_NAME_UPPERCASE}_VERBOSE_OUTPUT)
        message(STATUS ${content})
    endif()
endfunction()
