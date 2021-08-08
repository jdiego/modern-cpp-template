find_package(spdlog)

if (spdlog_FOUND)
    message(STATUS "Using external spdlog version at: ${spdlog_VERSION}.")
    # Make found targets globally available.
    set_target_properties( 
        spdlog::spdlog    
        PROPERTIES IMPORTED_GLOBAL TRUE 
    )
else()
    message(STATUS "Downloading spdlog LIBRARY")
    CPMAddPackage(
        NAME spdlog 
        GITHUB_REPOSITORY gabime/spdlog
    )
    # Adds spdlog::spdlog
    message(STATUS "Exporting FMT Library as spdlog::spdlog")
endif()

