# Changelog: Floating Browser UI
Date: April 17, 2026

## Overview
Implemented a high-fidelity, interactive floating browser component that supports snapping, resizing, and immersive full-screen transitions.

## Features
- **Floating Window Architecture**: Independent floating view overlaying the infinite canvas.
- **Corner Snapping**: Physics-based dragging that snaps to the four corners of the screen.
- **Dynamic Resizing**: 
  - Proportional scale levels (10%, 40%, 60%, 100%).
  - Continuous drag-to-resize with smart snapping.
  - One-tap cycling with "bouncing" logic.
- **Corner-Aware UI**: Resize handles that dynamically move to the opposite corner of the window's anchor.
- **Advanced Navigation Bar**:
  - Functional Back, Forward, and Reload buttons.
  - Page title and security indicator display.
  - Safari-style loading progress bar.
- **Premium Aesthetics**:
  - High-end glassmorphism with layered shadows.
  - Light-reactive gradient strokes.
  - Immersive full-screen mode with drag-to-dismiss physics.

## Technical Improvements
- **Multi-Platform Support**: Unified `WebView` implementation for iOS, iPadOS, and macOS (`UIViewRepresentable` & `NSViewRepresentable`).
- **Performance**: Optimized gesture handling to prevent conflicts between movement and web interaction.
- **Haptics**: Integrated rigid and medium haptic feedback for all major interactions.
