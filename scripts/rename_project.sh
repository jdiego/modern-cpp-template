#!/usr/bin/env bash
# Run this script from the repository root to rename the template.
# Usage: ./scripts/rename_project.sh <NewProjectName>
# Example: ./scripts/rename_project.sh MyAwesomeLib
set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <NewProjectName>"
    echo "Example: $0 MyAwesomeLib"
    exit 1
fi

if [[ ! "$1" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    echo "Error: project name must start with a letter and contain only"
    echo "       alphanumeric characters or underscores."
    exit 1
fi

NEW_NAME="$1"
NEW_NAME_LOWER=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]')
NEW_NAME_UPPER=$(echo "$NEW_NAME_LOWER" | tr '[:lower:]' '[:upper:]')

OLD_PROJECT="modern_cpp_project"
OLD_PROJECT_UPPER="MODERN_CPP_PROJECT"
OLD_CLASS="Greeter"
OLD_NS="greeter"
NEW_CLASS="$NEW_NAME"
NEW_NS="$NEW_NAME_LOWER"

echo "Renaming template:"
echo "  project : $OLD_PROJECT  →  $NEW_NAME_LOWER"
echo "  class   : $OLD_CLASS  →  $NEW_CLASS"
echo "  macro   : $OLD_PROJECT_UPPER  →  $NEW_NAME_UPPER"
echo ""

# ---------------------------------------------------------------------------
# Portable sed -i: GNU sed uses -i, BSD (macOS) sed requires -i ''
# ---------------------------------------------------------------------------
sedi() {
    if sed --version 2>/dev/null | grep -q GNU; then
        sed -i "$@"
    else
        sed -i '' "$@"
    fi
}

# ---------------------------------------------------------------------------
# Files to process (exclude git, build artefacts, and CPM cache)
# ---------------------------------------------------------------------------
find_text_files() {
    find . \
        \( -name "*.cmake" -o -name "CMakeLists.txt" \
        -o -name "*.cpp"   -o -name "*.hpp" -o -name "*.h" \
        -o -name "*.md"    -o -name "*.json" \
        -o -name "*.yml"   -o -name "*.yaml" \
        -o -name "*.sh"    -o -name "Makefile" \) \
        -not -path "./.git/*" \
        -not -path "./build*" \
        -not -path "./cpm_modules/*" \
        -print0
}

# ---------------------------------------------------------------------------
# 1. Replace CMake project name and macro prefix
# ---------------------------------------------------------------------------
echo "Step 1/3 — replacing project identifiers..."
while IFS= read -r -d '' file; do
    if grep -qF "$OLD_PROJECT_UPPER" "$file" 2>/dev/null; then
        sedi "s/${OLD_PROJECT_UPPER}/${NEW_NAME_UPPER}/g" "$file"
    fi
    if grep -qF "$OLD_PROJECT" "$file" 2>/dev/null; then
        sedi "s/${OLD_PROJECT}/${NEW_NAME_LOWER}/g" "$file"
    fi
done < <(find_text_files)

# ---------------------------------------------------------------------------
# 2. Replace class name and namespace in source/header files
# ---------------------------------------------------------------------------
echo "Step 2/3 — replacing class and namespace identifiers..."
while IFS= read -r -d '' file; do
    if grep -qF "$OLD_CLASS" "$file" 2>/dev/null; then
        sedi "s/${OLD_CLASS}/${NEW_CLASS}/g" "$file"
    fi
    if grep -qF "namespace ${OLD_NS}" "$file" 2>/dev/null; then
        sedi "s/namespace ${OLD_NS}/namespace ${NEW_NS}/g" "$file"
    fi
    if grep -qF "${OLD_NS}::" "$file" 2>/dev/null; then
        sedi "s/${OLD_NS}::/${NEW_NS}::/g" "$file"
    fi
done < <(find . \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) \
              -not -path "./.git/*" -not -path "./build*" -print0)

# ---------------------------------------------------------------------------
# 3. Rename include directory
# ---------------------------------------------------------------------------
echo "Step 3/3 — renaming include directory..."
if [[ -d "include/${OLD_PROJECT}" ]]; then
    mv "include/${OLD_PROJECT}" "include/${NEW_NAME_LOWER}"
    echo "  include/${OLD_PROJECT} → include/${NEW_NAME_LOWER}"
fi

# ---------------------------------------------------------------------------
# Verify: configure, build, and test
# ---------------------------------------------------------------------------
echo ""
echo "Verifying rename — configuring..."
cmake --preset dev

echo "Building..."
cmake --build --preset dev

echo "Testing..."
ctest --preset dev

APP_EXECUTABLE_NAME=$(sed -nE 's/^[[:space:]]*set\(APP_EXECUTABLE_NAME[[:space:]]+"([^"]+)".*/\1/p' standalone/CMakeLists.txt | head -n 1)
if [[ -z "${APP_EXECUTABLE_NAME}" ]]; then
    APP_EXECUTABLE_NAME="modern_cpp_app"
fi

echo ""
echo "Done! Project renamed to '${NEW_NAME_LOWER}'."
echo "Standalone binary available at: build/dev/bin/${APP_EXECUTABLE_NAME}"
