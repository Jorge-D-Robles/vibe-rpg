# Code & Project Guidelines

This document is the "Single Source of Truth" for coding standards and project idioms. All agents MUST follow these rules.

## 🏛️ General Architecture
- **Composition over Inheritance**: Use Nodes and Resources for behavior, not deep class hierarchies.
- **Signal Bus**: Use `res://scripts/core/Events.gd` for cross-system communication.
- **Static Typing**: Always use GDScript 2.0 type hints (`var x: int = 0`).
- **Resource-Based Data**: All game data (Items, Stats, Spells) must be stored in `.tres` files.

## naming_conventions
- **Files/Folders**: `snake_case.gd`, `snake_case.tscn`.
- **Variables/Functions**: `snake_case`.
- **Classes**: `PascalCase`.
- **Constants**: `SCREAMING_SNAKE_CASE`.
- **Private Members**: Prefix with underscore `_private_var`.

## 📁 Directory Structure
- `res://scenes/`: Visual scene files.
- `res://scripts/`: GDScript files (grouped by system).
- `res://assets/`: Raw assets (sprites, audio).
- `res://resources/`: Data instances (.tres).

## 🛠️ Specialized Idioms
- **Pixel Art**: `texture_filter = Nearest` (Inherit).
- **OnReady**: Use `@onready var node = $Path` for node references.
- **Exports**: Use `@export` for inspector variables to avoid hardcoding.
