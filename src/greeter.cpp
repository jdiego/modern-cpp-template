#include "modern_cpp_project/greeter.hpp"

#include <format>
#include <spdlog/spdlog.h>

using namespace greeter;

Greeter::Greeter(std::string _name) : name(std::move(_name)) {
}

std::string Greeter::greet(LanguageCode lang) const {
    spdlog::info("Greeting requested for: {}", name);

    switch (lang) {
    case LanguageCode::EN:
        return std::format("Hello, {}!", name);
    case LanguageCode::DE:
        return std::format("Hallo {}!", name);
    case LanguageCode::ES:
        return std::format("¡Hola {}!", name);
    case LanguageCode::FR:
        return std::format("Bonjour {}!", name);
    default:
        auto msg = std::format("Error: invalid language code for name: {}", name);
        spdlog::error(msg);
        return msg;
    }
}
