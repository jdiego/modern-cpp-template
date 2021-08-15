# only activate options for top level project
if(NOT PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  return()
endif()

# ---------------------------------------------------------------------------
# SECTION: Compiler
# ---------------------------------------------------------------------------
option(${PROJECT_NAME}_VERBOSE_OUTPUT TRUE)
if(NOT DEFINED CMAKE_CXX_STANDARD)
  # Let's ensure -std=c++xx instead of -std=g++xx
  option(CXX_STANDARD_REQUIRED "Require c++ standard" YES)
  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_EXTENSIONS NO)
endif()
# Configure the visibility of symbols in targets
#set(CMAKE_CXX_VISIBILITY_PRESET hidden)
#set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

# ---------------------------------------------------------------------------
# SECTION: LIBS
# ---------------------------------------------------------------------------
# Note: same postfix as fmt and spdlog! CK
set(CMAKE_DEBUG_POSTFIX d)
option(BUILD_SHARED_LIBS "Build shared libraries" YES)
option(BUILD_WITH_MT "Build libraries as MultiThreaded DLL (Windows Only)" FALSE)


# ---------------------------------------------------------------------------
# SECTION: TEST
# ---------------------------------------------------------------------------
option(BUILD_TESTING "Build tests" FALSE)
