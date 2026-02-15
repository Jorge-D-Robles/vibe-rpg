#!/bin/bash

# Search the Godot documentation for a query.
# Usage: ./search_docs.sh "query" [path_to_docs]

QUERY=$1
DOCS_PATH=${2:-"docs/godot-docs"}

if [ -z "$QUERY" ]; then
    echo "Usage: $0 "query" [path_to_docs]"
    exit 1
fi

# Search for the query in .rst files, ignoring some common directories
# Limit results to 20 matches to avoid context overflow
grep -rniE "$QUERY" "$DOCS_PATH" --include="*.rst" --exclude-dir={_static,_build,_templates} | head -n 20
