---
name: godot-rag
description: Provides RAG (Retrieval-Augmented Generation) capabilities for Godot Engine documentation. Use this skill to search for Godot-specific APIs, nodes, signals, and GDScript syntax when helping with Godot game development.
---

# Godot RAG Skill

This skill allows you to search and retrieve information from the local clone of the Godot documentation.

## Workflow

1. **Identify Need:** When a user asks a question about Godot that requires specific API details or implementation patterns.
2. **Search Documentation:** Use the `search_docs.sh` script to find relevant `.rst` files.
3. **Read Context:** Read the most relevant files discovered in the search to extract the necessary information.
4. **Synthesize Response:** Use the retrieved information to provide accurate Godot code or explanations.

## Tool Usage

### Searching the Docs

Use the provided script to search:

```bash
./skills/godot-rag/scripts/search_docs.sh "Signal connection syntax"
```

The script searches for the query in `.rst` files within `docs/godot-docs/` (relative to the project root).

## Directory Structure Reference

- `classes/`: Contains the reference for all Godot classes.
- `getting_started/`: High-level introductions and step-by-step tutorials.
- `tutorials/`: Specific feature tutorials (2D, 3D, Physics, UI, etc.).
- `community/`: Information about the Godot community and contributing.
- `engine_details/`: Low-level engine information.

## Tips

- If the search returns many results, look for files in the `classes/` or `tutorials/` directories first.
- Godot 4 syntax often differs from Godot 3; ensure you are looking at relevant sections if the version is specified.
