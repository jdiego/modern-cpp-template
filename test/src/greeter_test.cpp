
#include "modern_cpp_project/greeter.hpp"
#include "modern_cpp_project/version.hpp"
#include <iostream>
#include <string>
#include <boost/ut.hpp>

namespace ut = boost::ut;


ut::suite<"GreeterTestSuite"> greeter_suite = [] {
    using namespace ut;
    using namespace greeter;
    "greeter"_test = [] {
        Greeter greeter("Tests");
        expect(greeter.greet(LanguageCode::EN) == "Hello, Tests!");
        expect(greeter.greet(LanguageCode::DE) == "Hallo Tests!");
        expect(greeter.greet(LanguageCode::ES) == "¡Hola Tests!");
        expect(greeter.greet(LanguageCode::FR) == "Bonjour Tests!");
    };

    "version"_test = [] {
        expect(std::string_view(MODERN_CPP_PROJECT_VERSION) == std::string_view("1.0.0") >> fatal);
        expect(std::string(MODERN_CPP_PROJECT_VERSION) == std::string("1.0.0"));
    };
};
