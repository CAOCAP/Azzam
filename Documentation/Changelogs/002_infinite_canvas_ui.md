# Changelog: Infinite Canvas UI

**Date:** April 16, 2026
**Version:** 0.0.2

## Features
- **Infinite Canvas Foundation**: Replaced the boilerplate Day 1 `ContentView` with a new `InfiniteCanvasView` acting as the root of the application window.
- **Native Scrolling**: Utilized a massively sized `ScrollView([.horizontal, .vertical])` (100,000x100,000 points) initialized at its absolute center to provide native trackpad gestures (two-finger scroll, momentum, elastic bounce) without resorting to custom scroll event handling.
- **Performant Grid Background**: Introduced `CanvasGridPattern.swift`. Instead of iterating millions of dots, we used `ImageRenderer` to render a single tile and used `.resizable(resizingMode: .tile)` for highly optimized, memory-efficient CoreAnimation rendering across the infinite canvas.
- **Settings & Persisted State**: Implemented a native macOS `SettingsView` scene using `SwiftUI.Settings`. Users can dynamically update the grid dot color.
- **Safe Persistence**: Created an extension (`Color+RawRepresentable.swift`) to encode/decode `Color` values (using `NSKeyedArchiver`) directly into `@AppStorage`, bypassing the need for manual `UserDefaults` wrappers.
- **Interactive Node**: Added `PlaceholderNodeView.swift`, a dummy draggable component to showcase absolute positioning relative to the scrolling canvas.
