#include "modern_cpp_project/greeter.hpp"
#include "modern_cpp_project/version.hpp"

#include <iostream>
#include <string>
#include <unordered_map>

auto main(void) -> int {
    const std::unordered_map<std::string, greeter::LanguageCode> languages{
        {"en", greeter::LanguageCode::EN},
        {"de", greeter::LanguageCode::DE},
        {"es", greeter::LanguageCode::ES},
        {"fr", greeter::LanguageCode::FR},
    };

    greeter::Greeter greeter("Hello World");

    return 0;
}