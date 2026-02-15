# Godot Game Development Agent System

This repository is dedicated to building an advanced agentic system for autonomous Godot game development. It leverages the `gemini` CLI to provide a suite of specialized skills and a Godot editor integration.

## 🚀 Key Components

### 1. 🛠️ Godot Agent Skills
A comprehensive set of skills for the `gemini` CLI that allow agents to interact with Godot projects programmatically. These skills cover:
- **Project Management**: Modify `project.godot` settings.
- **Scene Building**: Generate valid `.tscn` files for 2D, 3D, and UI.
- **Code Analysis**: Lint and inspect GDScript.
- **Asset Management**: Create resources, shaders, and animations.
- **RAG Integration**: Search official Godot documentation for up-to-date API usage.

### 2. 🔌 Godot Gemini Plugin
An official Godot Editor plugin that integrates the `gemini` CLI directly into the editor interface.
- **Chat Interface**: Talk to Gemini without leaving Godot.
- **Non-blocking**: Uses threading to prevent editor freezes during command execution.
- **Context Aware**: (Planned) Automatically includes project context in prompts.

## 📂 Repository Structure

- `.gemini/skills/`: The core logic for all Godot-specific agent capabilities.
- `godot-gemini-plugin/`: The source code for the Godot Editor addon.
- `docs/`: Documentation and reference materials.

## 🛠️ Getting Started

### Prerequisites
- [Godot Engine 4.x](https://godotengine.org/)
- [Gemini CLI](https://github.com/google/gemini-cli)

### Installation
1. Clone this repository.
2. Link the skills to your `gemini` CLI configuration.
3. Copy `godot-gemini-plugin/addons/gemini_assistant` to your own Godot project's `addons/` folder.
4. Enable the plugin in **Project Settings -> Plugins**.

## 📄 Documentation
- [Design Document](design_doc.md): Detailed architecture and roadmap.
- [Plugin Readme](godot-gemini-plugin/README.md): Usage instructions for the editor integration.
