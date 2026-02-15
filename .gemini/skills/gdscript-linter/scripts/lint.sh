#!/bin/bash

FILE_PATH="$1"

if [ -z "$FILE_PATH" ]; then
  echo "Usage: lint.sh [path_to_gd_file]"
  exit 1
fi

# Resolve res://
if [[ "$FILE_PATH" == res://* ]]; then
  FILE_PATH="${FILE_PATH#res://}"
fi

if [ ! -f "$FILE_PATH" ]; then
  # Try looking in subdirs
  if [ -f "godot-gemini-plugin/$FILE_PATH" ]; then
    FILE_PATH="godot-gemini-plugin/$FILE_PATH"
  elif [ -f "../$FILE_PATH" ]; then
     FILE_PATH="../$FILE_PATH"
  else
     echo "Error: File $FILE_PATH not found."
     exit 1
  fi
fi

# Check for gdlint
if command -v gdlint &> /dev/null; then
  echo "Running gdlint..."
  gdlint "$FILE_PATH"
  exit $?
fi

# Check for godot
if command -v godot &> /dev/null; then
  echo "Running godot --check-only..."
  godot --headless --check-only --script "$FILE_PATH"
  exit $?
fi

echo "Warning: Neither 'gdlint' nor 'godot' command found in PATH."
echo "Please install gdtoolkit (pip install gdtoolkit) or add Godot to your PATH."
echo "Skipping linting."
exit 0
