#!/bin/bash
# Appian Function Validator Hook
# Checks written/edited files for potentially hallucinated a! functions
# Runs on any file that contains Appian a! function calls
# Exit codes: 0 = pass (or not applicable)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="$SCRIPT_DIR/appian-functions.txt"

# Read the tool input from stdin
INPUT=$(cat)

# Extract file path from JSON input
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | grep -o '"filePath"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/"filePath"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

# Skip if no file path or file doesn't exist
if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Skip non-text files and the registry itself
case "$FILE_PATH" in
  *.png|*.jpg|*.gif|*.svg|*.ico|*.pdf|*.zip|*.jar|*.bin)
    exit 0
    ;;
  */appian-functions.txt|*/functions-registry.md)
    exit 0
    ;;
esac

# Check if registry exists
if [ ! -f "$REGISTRY" ]; then
  exit 0
fi

# Check if file contains any a! function calls (quick test)
if ! grep -q 'a![a-zA-Z]' "$FILE_PATH" 2>/dev/null; then
  exit 0
fi

# Extract all a!functionName patterns from the file
FOUND_FUNCTIONS=$(grep -oE 'a![a-zA-Z_][a-zA-Z0-9_]*' "$FILE_PATH" | sort -u)

if [ -z "$FOUND_FUNCTIONS" ]; then
  exit 0
fi

# Check each function against the registry
UNKNOWN=""
while IFS= read -r func; do
  # Skip version-suffixed functions (e.g., a!gridField_25r2 matches a!gridField)
  BASE_FUNC=$(echo "$func" | sed 's/_[0-9][0-9]r[0-9]$//')
  if ! grep -qx "$func" "$REGISTRY" && ! grep -qx "$BASE_FUNC" "$REGISTRY"; then
    UNKNOWN="$UNKNOWN  - $func()\n"
  fi
done <<< "$FOUND_FUNCTIONS"

if [ -n "$UNKNOWN" ]; then
  echo ""
  echo "APPIAN FUNCTION VALIDATION WARNING"
  echo "==================================="
  echo "The following a! functions in '$(basename "$FILE_PATH")' are NOT in the Appian 26.2 registry:"
  echo ""
  echo -e "$UNKNOWN"
  echo "These may be hallucinated. Verify at:"
  echo "  https://docs.appian.com/suite/help/26.2/Appian_Functions.html"
  echo ""
  echo "Common corrections:"
  echo "  a!milestoneStep()  -> a!milestoneField() with steps param"
  echo "  a!decimalField()   -> a!floatingPointField()"
  echo "  a!numberField()    -> a!integerField() or a!floatingPointField()"
  echo "  a!alertField()     -> a!messageBanner()"
  echo "  a!switchField()    -> a!toggleField()"
  echo "  a!link()           -> a!dynamicLink() or a!recordLink()"
  echo "==================================="
fi

exit 0
