# Walkthrough: Implementing the Floating Browser UI
Date: April 17, 2026

## Objective
To create a high-fidelity, independent floating browser that overlays the infinite canvas, allowing the user to browse documentation or web resources while maintaining focus on the editor.

## Key Components

### 1. `FloatingWindowManager.swift`
The global state manager that coordinates the position and size of all floating elements (Browser and AI Button).
- **Corner Snapping**: Manages `ScreenCorner` enum and current anchor.
- **Size Levels**: Tracks `BrowserSizeLevel` from `.tiny` (10%) to `.fullScreen` (100%).
- **Collision Logic**: Handles the logic to "swap" positions between the AI Button and the Browser if they collide.

### 2. `FloatingBrowserView.swift`
The primary UI orchestrator.
- **Glassmorphism**: Uses `.ultraThinMaterial` with a `LinearGradient` stroke to achieve a premium Apple look.
- **Gesture Layering**:
  - `DraggableCornerModifier`: Handles overall window movement and corner snapping.
  - `DragGesture` (Top Bar): Handles full-screen drag-to-dismiss with interactive springs.
  - `DragGesture` (Resize Handle): Handles continuous resizing and snapping.
- **Corner Awareness**: The `handleCorner` logic ensures the resize button is always in the corner furthest from the window's anchor, allowing the window to grow away from its stuck corner.

### 3. `WebView.swift` (Multi-platform)
A unified wrapper for `WKWebView`.
- **`PlatformViewRepresentable`**: A custom typealias system that automatically switches between `UIViewRepresentable` (iOS) and `NSViewRepresentable` (macOS).
- **Navigation Commands**: Uses an enum-based `WebCommand` system to trigger Back, Forward, and Reload actions without using non-equatable closures.
- **Progress Tracking**: Uses KVO (Key-Value Observation) on `estimatedProgress` and `isLoading` to feed real-time data to the custom navigation bar.

### 4. `DraggableCornerModifier.swift`
Provides the physics-based snapping logic.
- **Spring Physics**: Uses `withAnimation(.spring(...))` to animate snapping to corners.
- **Haptic Feedback**: Triggers haptics when a snap occurs, giving a "mechanical" feel to the digital interface.

## Interaction Design
- **One-Tap Cycle**: Tapping the resize handle cycles through sizes in a "bounce" pattern (Tiny → Small → Medium → Full → Medium → Small → Tiny).
- **Drag-to-Dismiss**: In full-screen mode, pulling down on the top bar "peels" the window back into its windowed state with dynamic corner rounding.
- **Loading Progress**: A subtle progress bar at the bottom of the top bar provides visual confirmation of web page status.

## Future Improvements
- **Tab Management**: Support for multiple tabs within the floating view.
- **URL Entry**: A fully functional text field for custom URL entry.
- **Persistent State**: Saving the browser's last position and size to `UserDefaults`.
