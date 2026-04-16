# Changelog: Omnibox & Command Palette

**Date:** April 16, 2026
**Version:** 0.0.3

## Features
- **Omnibox UI**: Introduced `OmniboxView.swift`, a sleek Raycast/Spotlight-style floating palette using an `.ultraThinMaterial` glassmorphic background to cleanly pop off the infinite canvas.
- **Intent-Driven Input**: Added a borderless text field that auto-focuses upon presentation, setting the foundation for the core user-to-agent intent flow.
- **Floating AI Button**: Created `FloatingAiButton.swift` pinned to the bottom trailing edge of the screen. Features a sleek, minimalist dark style with a gently pulsing white glow to summon the Omnibox.
- **Keyboard Navigation**: Implemented a global `Cmd + K` shortcut via `.keyboardShortcut("k", modifiers: .command)` in `ContentView` to rapidly toggle the Omnibox.
- **Placeholder Actions**: Included placeholder suggestions (e.g., "Create a new component...", "Explain the selected code...") within the Omnibox scroll view to prepare for dynamic, context-aware command generation.
