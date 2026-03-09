find_package(Doxygen OPTIONAL_COMPONENTS dot)

if(NOT DOXYGEN_FOUND)
    message(STATUS "Doxygen not found — documentation target will not be available.")
    return()
endif()

set(DOXYGEN_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/docs")
set(DOXYGEN_GENERATE_HTML    YES)
set(DOXYGEN_GENERATE_XML     NO)
set(DOXYGEN_USE_MDFILE_AS_MAINPAGE "${PROJECT_SOURCE_DIR}/README.md")
set(DOXYGEN_PROJECT_NAME   "${PROJECT_NAME}")
set(DOXYGEN_PROJECT_NUMBER "${PROJECT_VERSION}")
set(DOXYGEN_RECURSIVE      YES)
set(DOXYGEN_QUIET          YES)
set(DOXYGEN_WARN_IF_UNDOCUMENTED NO)

if(DOXYGEN_DOT_FOUND)
    set(DOXYGEN_HAVE_DOT YES)
endif()

doxygen_add_docs(
    doxygen-docs
    "${PROJECT_SOURCE_DIR}/include"
    "${PROJECT_SOURCE_DIR}/src"
    "${PROJECT_SOURCE_DIR}/README.md"
    COMMENT "Generating API documentation with Doxygen"
)

message(STATUS "Doxygen ${DOXYGEN_VERSION} found — target 'doxygen-docs' available.")
