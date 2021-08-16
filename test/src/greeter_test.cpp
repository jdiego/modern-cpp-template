#include "modern_cpp_project/greeter.hpp"
#include "modern_cpp_project/version.hpp"
#include <doctest/doctest.h>

#include <string>

TEST_CASE("Greeter") {
    using namespace greeter;

    Greeter greeter("Tests");

    CHECK(greeter.greet(LanguageCode::EN) == "Hello, Tests!");
    CHECK(greeter.greet(LanguageCode::DE) == "Hallo Tests!");
    CHECK(greeter.greet(LanguageCode::ES) == "¡Hola Tests!");
    CHECK(greeter.greet(LanguageCode::FR) == "Bonjour Tests!");
}

TEST_CASE("Greeter version") {
    static_assert(std::string_view(MODERN_CPP_PROJECT_VERSION) == std::string_view("1.0.0"));
    CHECK(std::string(MODERN_CPP_PROJECT_VERSION) == std::string("1.0.0"));
}