#!/bin/bash

# Run this script at root directory to 
# - replace "Greeter" with new project name in all CMakeLists.txt
# - rename include/greeter to include/<project_name>

# Check if new project name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <new_project_name>"
    echo "Example: $0 MyProject"
    exit 1
fi

# Validate project name: must start with a letter and contain only
# alphanumeric characters, underscores, or dashes.
if [[ ! "$1" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
    echo "Error: Project name must start with a letter and contain only alphanumeric characters, underscores, or dashes."
    exit 1
fi

OLD_NAME="Greeter"
NEW_NAME="$1"
echo "Replacing '$OLD_NAME' with '$NEW_NAME' in CMakeLists.txt files ... "

# Initialize counters
FILES_PROCESSED=0
REPLACEMENTS_TOTAL=0

# Find and process all Makefiles
while IFS= read -r -d '' file; do
    # Count occurrences before replacement
    OCCURRENCES=$(grep -o "$OLD_NAME" "$file" | wc -l)
    
    if [ "$OCCURRENCES" -gt 0 ]; then
# Make the replacements
        sed -i "s/$OLD_NAME/$NEW_NAME/g" "$file"
        
        # Update counters
        REPLACEMENTS_TOTAL=$((REPLACEMENTS_TOTAL + OCCURRENCES))
        FILES_PROCESSED=$((FILES_PROCESSED + 1))        
    fi
done < <(find . -type f -name CMakeLists.txt -print0)

echo ""
echo "Summary:"
echo "Total Makefiles processed: $FILES_PROCESSED"
echo "Total replacements made: $REPLACEMENTS_TOTAL"

echo " Update include directory and includes"
OLD_NAME_LOWER=$(echo "$OLD_NAME" | tr '[:upper:]' '[:lower:]')
NEW_NAME_LOWER=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]')
mv "include/${OLD_NAME_LOWER}" "include/${NEW_NAME_LOWER}"
find . \( -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \) -exec sed -i "s/#include <${OLD_NAME_LOWER}/#include <${NEW_NAME_LOWER}/g" {} \;

echo "-- Update project version testing --"
OLD_NAME_UPPER=$(echo "$OLD_NAME" | tr '[:lower:]' '[:upper:]')
NEW_NAME_UPPER=$(echo "$NEW_NAME" | tr '[:lower:]' '[:upper:]')
find . -type f -exec sed -i "s/${OLD_NAME_UPPER}_/${NEW_NAME_UPPER}_/g" {} \;

# test new project is compilable and tested
cmake -S . -B build
cmake --build build

# run tests
ctest --test-dir build --output-on-failure
# format code
cmake --build build --target fix-format
# run standalone
APP_EXECUTABLE_NAME=$(grep -E 'set\(\s*APP_EXECUTABLE_NAME\s+' standalone/CMakeLists.txt | sed -E 's/.*set\(\s*APP_EXECUTABLE_NAME\s+([^)]+)\).*/\1/' | tr -d '[:space:]')
if [ -z "$APP_EXECUTABLE_NAME" ]; then
    APP_EXECUTABLE_NAME="modern_cpp_app"
fi
"./build/standalone/${APP_EXECUTABLE_NAME}" --help
# build docs
cmake --build build --target GenerateDocs