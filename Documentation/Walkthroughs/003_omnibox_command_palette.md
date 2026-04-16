# Walkthrough: Omnibox & Command Palette

This document provides a technical walkthrough of the newly introduced Omnibox and floating AI button, establishing the primary intent-driven interaction mechanism for the application.

## The Architecture

The feature is built around three main components:

### 1. `FloatingAiButton`
Located in `Azzam/Features/Omnibox/FloatingAiButton.swift`.
- **Minimalist Aesthetic:** Uses a sleek, dark circular button overlaid with a subtle white border.
- **Animation:** Features a `.blur(radius:)` and `.scaleEffect()` animation that cycles continuously using `Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)` to create a gentle, breathing "glow".
- **Haptics:** Integrates `UIImpactFeedbackGenerator` to provide satisfying tactile feedback when tapped on iOS devices.

### 2. `OmniboxView`
Located in `Azzam/Features/Omnibox/OmniboxView.swift`.
- **Glassmorphism:** Leverages SwiftUI's `.ultraThinMaterial` on a `RoundedRectangle` to create a beautiful frosted glass effect.
- **Focus Management:** Uses `@FocusState` to ensure the keyboard is immediately summoned and the text field is ready to receive input the moment the view is presented.
- **Dismissal Mechanism:** Features an almost-invisible background overlay (`Color.black.opacity(0.01)`) with an `.onTapGesture` to cleanly dismiss the Omnibox if the user taps outside the primary palette.

### 3. Core Integration (`ContentView`)
The `InfiniteCanvasView` is now wrapped inside a `ZStack` in `ContentView.swift`.
- **Positioning:** The AI button is encapsulated in an `HStack` and `VStack` with `Spacer()` views to permanently pin it to the `.bottomTrailing` corner.
- **Keyboard Shortcuts:** A hidden zero-opacity button with a `.keyboardShortcut("k", modifiers: .command)` modifier ensures that power users can quickly toggle the UI using `Cmd + K` regardless of their focus state.

## Next Steps
The Omnibox is currently populated with static, placeholder suggestions. Future iterations will wire this component up to a local LLM or cloud backend to parse user intents and dynamically stream UI modifications onto the `InfiniteCanvasView`.
