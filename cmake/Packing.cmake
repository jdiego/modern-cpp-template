cpmaddpackage("gh:TheLartians/PackageProject.cmake@1.6.0")

packageproject(
  # the name of the target to export
  NAME
  ${PROJECT_NAME}
  # the version of the target to export
  VERSION
  ${PROJECT_VERSION}
  # a temporary directory to create the config files
  BINARY_DIR
  ${PROJECT_BINARY_DIR}
  # location of the target's public headers
  INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/include
  # should match the target's INSTALL_INTERFACE include directory
  INCLUDE_DESTINATION
  include/${PROJECT_NAME}-${PROJECT_VERSION}
  # semicolon separated list of the project's dependencies DEPENDENCIES "fmt
  # 7.1.3;cxxopts 2.2.0" (optional) create a header containing the version info
  # Note: that the path to headers should be lowercase
  VERSION_HEADER
  "${VERSION_HEADER_LOCATION}"
  # (optional) create a export header using GenerateExportHeader module
  # EXPORT_HEADER "${PROJECT_NAME}/export.h" (optional) install your library
  # with a namespace (Note: do NOT add extra '::') NAMESPACE
  # ${PROJECT_NAMESPACE} (optional) define the project's version compatibility,
  # defaults to `AnyNewerVersion` supported values:
  # `AnyNewerVersion|SameMajorVersion|SameMinorVersion|ExactVersion`
  COMPATIBILITY
  AnyNewerVersion
  # (optional) option to disable the versioning of install destinations
  DISABLE_VERSION_SUFFIX
  YES
  # (optional) option to ignore target architecture for package resolution
  # defaults to YES for header only (i.e. INTERFACE) libraries
  ARCH_INDEPENDENT
  NO)
