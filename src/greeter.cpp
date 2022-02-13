#include "modern_cpp_project/greeter.hpp"
#include <fmt/format.h>

#include <spdlog/spdlog.h>
using namespace greeter;

Greeter::Greeter(std::string _name) : name(std::move(_name)) {
}

std::string Greeter::greet(LanguageCode lang) const {
    spdlog::info("Welcome to spdlog!");
    switch (lang) {
        case LanguageCode::EN:
            return fmt::format("Hello, {}!", name);
        case LanguageCode::DE:
            return fmt::format("Hallo {}!", name);
        case LanguageCode::ES:
            return fmt::format("¡Hola {}!", name);
        case LanguageCode::FR:
            return fmt::format("Bonjour {}!", name);
        default:
           std::string msg = fmt::format("Error: The Language Code is invalid: {}", name);
           spdlog::error(msg);
           return msg;
    }
}
