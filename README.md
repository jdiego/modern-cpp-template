<p align="center">
  <img src="https://repository-images.githubusercontent.com/254842585/4dfa7580-7ffb11ea-99d0-46b8fe2f4170" height="175" width="auto" />
</p>

# Modern C++ Template

A C++23 project template with modern CMake (3.25+), reproducible dependency management, and a clean library/binary structure — ready to scaffold your next project.

## Features

- **C++23** with `std::format` and `std::print` — no third-party formatting library required
- **Modern CMake** (3.25…4.2) with version-range syntax, `FILE_SET HEADERS`, and `CMAKE_VERIFY_INTERFACE_HEADER_SETS`
- **[CMakePresets.json](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html)** — `dev`, `release`, `asan`, `tsan`, `coverage`, `warnings-as-errors` presets out of the box
- **Reproducible dependencies** via [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake) with local-cache support
- **Structured logging** via [spdlog](https://github.com/gabime/spdlog) (configured to use `std::format` internally)
- **Unit testing** via [boost-ext/ut](https://github.com/boost-ext/ut) — expression-based, no macros
- **CLI binary** support via [cxxopts](https://github.com/jarro2783/cxxopts) in the standalone target
- **Installable library** with automatic versioning and `find_package` support via [PackageProject.cmake](https://github.com/TheLartians/PackageProject.cmake)
- **CI workflows** for Ubuntu, macOS and Windows via [GitHub Actions](https://github.com/features/actions), including standalone and install verification
- **Code coverage** instrumentation (gcov) with [Codecov](https://codecov.io) CI integration
- **Static analysis** support via clang-tidy and cppcheck
- **Compiler cache** support via ccache (`*_ENABLE_CCACHE=ON`)
- **Code formatting** enforced by [clang-format](https://clang.llvm.org/docs/ClangFormat.html) and [cmake-format](https://github.com/cheshirekow/cmake_format) via [Format.cmake](https://github.com/TheLartians/Format.cmake)

## Requirements

| Tool | Minimum version |
|------|----------------|
| CMake | 3.25 |
| C++ compiler | GCC 13 / Clang 16 / MSVC 19.38 (full C++23 support) |
| Git | any recent |

## Project structure

```
.
├── include/modern_cpp_project/   # Public headers (installed via FILE_SET)
│   └── greeter.hpp
├── src/                          # Library implementation
│   └── greeter.cpp
├── test/                         # Standalone test project (also a subdirectory)
│   └── src/greeter_test.cpp
├── standalone/                   # Standalone binary project (also a subdirectory)
│   └── src/main.cpp
├── all/                          # Meta-project: builds everything (for IDEs)
│   └── CMakeLists.txt
├── cmake/                        # Bundled CMake utilities
│   ├── CPM.cmake
│   ├── PackageProject.cmake
│   ├── CompilerWarnings.cmake
│   ├── StandardSettings.cmake
│   ├── StaticAnalyzers.cmake
│   └── version.hpp.in
├── CMakeLists.txt                # Root: builds library + optional test/standalone
└── CMakePresets.json
```

## Usage

### 1 — Configure & build with presets (recommended)

```bash
# Debug build (library + tests + standalone)
cmake --preset dev
cmake --build --preset dev
ctest --preset dev

# Release
cmake --preset release
cmake --build --preset release

# AddressSanitizer + UBSan
cmake --preset asan
cmake --build --preset asan
ctest --preset asan

# ThreadSanitizer
cmake --preset tsan
cmake --build --preset tsan

# Code coverage
cmake --preset coverage
cmake --build --preset coverage
ctest --preset coverage

# Warnings as errors
cmake --preset warnings-as-errors
cmake --build --preset warnings-as-errors
```

Each preset writes its build artifacts to `build/<preset-name>/`.

---

### 2 — Manual CMake (without presets)

```bash
cmake -B build \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DMODERN_CPP_PROJECT_ENABLE_TESTING=ON \
  -DMODERN_CPP_PROJECT_ENABLE_STANDALONE=ON

cmake --build build
ctest --test-dir build --output-on-failure
```

---

### 3 — Library only (as a dependency)

When this project is consumed via `add_subdirectory` or CPM, only the library is built (no tests, no standalone):

```bash
cmake -B build -DMODERN_CPP_PROJECT_ENABLE_TESTING=OFF -DMODERN_CPP_PROJECT_ENABLE_STANDALONE=OFF
```

Or via CPM in a consumer project:

```cmake
CPMAddPackage("gh:your-org/modern-cpp-template@1.0.0")
target_link_libraries(my_target PRIVATE modern_cpp_project::modern_cpp_project)
```

---

### 4 — Test project (standalone)

The `test/` directory is a self-contained CMake project that can be built independently:

```bash
cmake -B build/test -S test
cmake --build build/test
ctest --test-dir build/test --output-on-failure
```

---

### 5 — Standalone binary (standalone)

The `standalone/` directory is also a self-contained project:

```bash
cmake -B build/standalone -S standalone
cmake --build build/standalone
./build/standalone/bin/modern_cpp_app --help
./build/standalone/bin/modern_cpp_app --name Alice --lang fr
```

---

### 6 — All-in-one (for IDEs)

The `all/` meta-project configures the library, tests, and standalone in a single build tree — useful for IDE indexing:

```bash
cmake -B build/all -S all
cmake --build build/all
ctest --test-dir build/all
```

---

### 7 — Install

```bash
cmake --preset release
cmake --build --preset release --target install
```

Or with a custom prefix:

```bash
cmake --preset release -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build --preset release --target install
```

After install, downstream projects can use:

```cmake
find_package(modern_cpp_project REQUIRED)
target_link_libraries(my_app PRIVATE modern_cpp_project::modern_cpp_project)
```

---

### 8 — Scaffold a new project

Use the rename script to replace the `Greeter` example with your own names:

```bash
bash scripts/rename_project.sh MyProject
```

This replaces all occurrences of `Greeter`/`greeter` with `MyProject`/`myproject` in CMakeLists.txt files and renames the include directory.

---

## CMake options

| Option | Default | Description |
|--------|---------|-------------|
| `MODERN_CPP_PROJECT_ENABLE_TESTING` | `ON` | Build unit tests |
| `MODERN_CPP_PROJECT_ENABLE_STANDALONE` | `ON` | Build standalone binary |
| `MODERN_CPP_PROJECT_BUILD_SHARED_LIBS` | `ON` | Build shared library (OFF = static) |
| `MODERN_CPP_PROJECT_BUILD_HEADERS_ONLY` | `OFF` | Header-only library mode |
| `MODERN_CPP_PROJECT_WARNINGS_AS_ERRORS` | `OFF` | Treat compiler warnings as errors |
| `MODERN_CPP_PROJECT_ENABLE_CLANG_TIDY` | `OFF` | Enable clang-tidy static analysis |
| `MODERN_CPP_PROJECT_ENABLE_CPPCHECK` | `OFF` | Enable cppcheck static analysis |
| `MODERN_CPP_PROJECT_ENABLE_CCACHE` | `OFF` | Enable ccache for faster rebuilds |
| `MODERN_CPP_PROJECT_ENABLE_CODE_COVERAGE` | `OFF` | Enable gcov code coverage |
| `CPM_SOURCE_CACHE` | — | Path to CPM download cache (set as env var to persist across builds) |

## Makefile convenience targets

```bash
make test         # clean build + run tests (Release)
make coverage     # gcov coverage report
make docs         # Doxygen HTML docs
make install      # install to /tmp/modern_cpp_project
make format       # check formatting (clang-format + cmake-format)
make fix-format   # auto-fix formatting
make check        # run cppcheck
make clean        # remove build/
make update       # download latest CPM.cmake
```

## Dependencies

| Library | Version | Purpose |
|---------|---------|---------|
| [spdlog](https://github.com/gabime/spdlog) | 1.15.0 | Structured logging |
| [boost-ext/ut](https://github.com/boost-ext/ut) | 2.3.0 | Unit testing (test only) |
| [cxxopts](https://github.com/jarro2783/cxxopts) | 3.0.0 | CLI argument parsing (standalone only) |
| [Format.cmake](https://github.com/TheLartians/Format.cmake) | 1.8.1 | Code formatting targets |

All dependencies are managed by CPM.cmake and pinned to specific versions. Set `CPM_SOURCE_CACHE` to avoid re-downloading on clean builds:

```bash
export CPM_SOURCE_CACHE=~/.cache/cpm
```
