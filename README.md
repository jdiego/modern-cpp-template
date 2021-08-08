<p align="center">
  <img src="https://repository-images.githubusercontent.com/254842585/4dfa7580-7ffb-11ea-99d0-46b8fe2f4170" height="175" width="auto" />
</p>


# Modern C++ Template

A quick C++ template for modern CMake projects, aimed to be an easy to use
starting point.

This is my personal take on such a type of template, thus I might not use the 
best practices or you might disagree with how I do things. Any and all feedback
is greatly appreciated!

## Features
-  Modern **CMake** configuration and project, which, to the best of my knowledge, uses the best practices and the [Modern CMake practices](https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/)
- Suited for single header libraries and projects of any scale
- Options to build as a header-only library, static library or shared library.
- **Package manager support**, via [CPM.cmake](https://github.com/TheLartians/CPM.cmake), to reproducible dependency management 
- **Unit testing** support through [doctest](https://github.com/onqtam/doctest)
- TODO: Installable target with automatic versioning information and header generation via [PackageProject.cmake](https://github.com/TheLartians/PackageProject.cmake)
- TODO: **CI workflows for Windows, Linux and MacOS** using [GitHub Actions](https://help.github.com/en/actions/)
- TODO: **Code coverage**, enabled by using the `ENABLE_CODE_COVERAGE` option, through *Codecov* CI integration [codecov](https://codecov.io)
- Code formatting enforced by [clang-format](https://clang.llvm.org/docs/ClangFormat.html) and [cmake-format](https://github.com/cheshirekow/cmake_format) via [Format.cmake](https://github.com/TheLartians/Format.cmake)
- TODO: **Static analyzers** integration
- TODO: **Ccache** integration, for speeding up rebuild times


