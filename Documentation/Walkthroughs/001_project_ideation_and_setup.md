# Walkthrough: Project Ideation & Initial Setup

## Overview
This walkthrough covers the initial setup phase for **CAOCAP Azzam**, focusing on defining the architectural boundaries for an agentic web IDE built on macOS.

## Conceptual Framework
The application aims to consolidate typical developer tools into a single, intent-driven interface. The primary driver is the "Omnibox", a smart text field that interprets user intent to dynamically display:
1. **Web Browser** using WebKit (`WKWebView`).
2. **Code Editor** for modifying or writing code.
3. **AI Agent** for natural language collaboration and code generation.

## Technical Execution (Day 1)
To support this ambitious modularity, we abandoned the standard SwiftData template and established a custom folder structure:

1. **Folder Separation**: We divided the project into `App`, `Core`, `Features`, `Services`, `Models`, and `Resources`.
2. **Feature Isolation**: By housing the `Browser`, `Editor`, and `Agent` inside the `Features` directory, we ensure they can be developed independently before being merged via a central `AppStateManager`.
3. **Project Integrity**: We preserved the macOS native compilation, ensuring Xcode 16 continues to dynamically sync with our file structure without breaking the `project.pbxproj`. 

## Open Design Questions
Before proceeding to logic implementation, the following design questions remain open for discussion:
1. **UI Layout**: Position of the Omnibox (floating vs static toolbar).
2. **Project Workspace**: Temporary memory workspaces vs predefined local folders.
3. **Terminal Capabilities**: Native shell bridge vs UI simulation.
4. **Cross-Platform**: Strict focus on macOS vs designing generic SwiftUI from day 1.
