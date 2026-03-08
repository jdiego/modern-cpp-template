#include "modern_cpp_project/greeter.hpp"
#include "modern_cpp_project/version.hpp"

#include <cxxopts.hpp>
#include <format>
#include <print>
#include <string>
#include <unordered_map>

int main(int argc, char** argv) {
    cxxopts::Options options(MODERN_CPP_PROJECT_NAME, "A modern C++ greeter application");

    // clang-format off
    options.add_options()
        ("h,help",    "Print usage")
        ("v,version", "Print version")
        ("n,name",    "Name to greet",    cxxopts::value<std::string>()->default_value("World"))
        ("l,lang",    "Language (en/de/es/fr)", cxxopts::value<std::string>()->default_value("en"));
    // clang-format on

    auto result = options.parse(argc, argv);

    if (result.count("help")) {
        std::print("{}\n", options.help());
        return 0;
    }

    if (result.count("version")) {
        std::print("{} v{}\n", MODERN_CPP_PROJECT_NAME, MODERN_CPP_PROJECT_VERSION);
        return 0;
    }

    const std::unordered_map<std::string, greeter::LanguageCode> languages{
        {"en", greeter::LanguageCode::EN},
        {"de", greeter::LanguageCode::DE},
        {"es", greeter::LanguageCode::ES},
        {"fr", greeter::LanguageCode::FR},
    };

    const auto name = result["name"].as<std::string>();
    const auto lang = result["lang"].as<std::string>();

    const auto it = languages.find(lang);
    if (it == languages.end()) {
        std::println(stderr, "Error: unsupported language '{}'. Use: en, de, es, fr", lang);
        return 1;
    }

    greeter::Greeter greeter(name);
    std::println("{}", greeter.greet(it->second));

    return 0;
}
