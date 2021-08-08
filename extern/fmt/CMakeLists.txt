
find_package(fmt)

if (fmt_FOUND)
    message(STATUS "Using external FMT version at: ${fmt_VERSION}.")
    # Make found targets globally available.
    
    set_target_properties( 
        fmt::fmt    # This is header only
        PROPERTIES IMPORTED_GLOBAL TRUE 
    )
else()
    message(STATUS "Downloading FMT LIBRARY")
    CPMAddPackage(
        NAME fmt
        GIT_TAG 7.1.3
        GITHUB_REPOSITORY fmtlib/fmt
        OPTIONS "FMT_INSTALL YES" # create an installable target
    )
    # Adds fmt::fmt
    message(STATUS "Exporting FMT Library as fmt::fmt")
endif()

