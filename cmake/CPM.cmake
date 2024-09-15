set(CPM_DOWNLOAD_VERSION 0.39.0)
set(CPM_HASH_SUM "66639bcac9dd2907b2918de466783554c1334446b9874e90d38e3778d404c2ef")

if(CPM_SOURCE_CACHE)
    set(CPM_DOWNLOAD_LOCATION "${CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
elseif(DEFINED ENV{CPM_SOURCE_CACHE})
    set(CPM_DOWNLOAD_LOCATION "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
else()
    set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
endif()

# Expand relative path. This is important if the provided path contains a tilde (~)
get_filename_component(CPM_DOWNLOAD_LOCATION ${CPM_DOWNLOAD_LOCATION} ABSOLUTE)

function(download_cpm)
    message(STATUS "Downloading CPM.cmake to ${CPM_DOWNLOAD_LOCATION}")
    file(DOWNLOAD
       https://github.com/cpm-cmake/CPM.cmake/releases/download/v${CPM_DOWNLOAD_VERSION}/CPM.cmake
       ${CPM_DOWNLOAD_LOCATION} STATUS CPM_DOWNLOAD_STATUS
    )
    list(GET CPM_DOWNLOAD_STATUS 0 CPM_DOWNLOAD_STATUS_CODE)
    list(GET CPM_DOWNLOAD_STATUS 1 CPM_DOWNLOAD_ERROR_MESSAGE)
    if(${CPM_DOWNLOAD_STATUS_CODE} EQUAL 0)
        message(STATUS "CPM: Download completed successfully.")
    else()
        message(FATAL_ERROR "CPM: Error occurred during download: ${CPM_DOWNLOAD_ERROR_MESSAGE}")
    endif()
endfunction()

if(NOT (EXISTS ${CPM_DOWNLOAD_LOCATION}))
    download_cpm()
else()
    # resume download if it previously failed
    file(SHA256 ${CPM_DOWNLOAD_LOCATION} CPM_CHECK)
    if(NOT "${CPM_CHECK}" STREQUAL CPM_HASH_SUM)
        download_cpm()
    endif()
    unset(check)
endif()

include(${CPM_DOWNLOAD_LOCATION})
