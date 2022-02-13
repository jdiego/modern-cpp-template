
#include "modern_cpp_project/greeter.hpp"
#include "modern_cpp_project/version.hpp"
#include <boost/ut.hpp> 
#include <iostream>
#include <string>

using namespace boost::ut;
boost::ut::suite greeter_teste_suite = [] {
    "run Greeter"_test = [] {
        using namespace greeter;

        Greeter greeter("Tests");

        expect(greeter.greet(LanguageCode::EN) == "Hello, Tests!");
        expect(greeter.greet(LanguageCode::DE) == "Hallo Tests!");
        expect(greeter.greet(LanguageCode::ES) == "¡Hola Tests!");
        expect(greeter.greet(LanguageCode::FR) == "Bonjour Tests!");
    };

    "run Greeter version"_test = [] {
        static_assert(std::string_view(MODERN_CPP_PROJECT_VERSION) == std::string_view("1.0.0"));
        expect(std::string(MODERN_CPP_PROJECT_VERSION) == std::string("1.0.0"));
    };
};
