# Settings for finding correct Boost libraries.
set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
set(Boost_NO_BOOST_CMAKE ON)
set(BOOST_NO_SYSTEM_PATHS ON)

# Search for Boost libraries.
find_package(Boost REQUIRED)
if(Boost_FOUND)
  if(NOT Boost_VERSION_STRING VERSION_LESS 1.71.0)
    message(
      STATUS
        "New Boost version may have incorrect or missing dependencies and imported targets"
    )
  endif()
  message(STATUS "Boost version: ${Boost_VERSION}")

  # Make found targets globally available.
  set_target_properties(Boost::boost # This is header only
                        PROPERTIES IMPORTED_GLOBAL TRUE)
endif()
