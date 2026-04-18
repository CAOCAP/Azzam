//
//  ContentView.swift
//  Azzam
//
//  Created by الشيخ عزام on 16/04/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var browserState: BrowserWindowState
    #if os(macOS)
    @Environment(\.openWindow) private var openWindow
    #endif
    @State private var isOmniboxPresented = false
    @StateObject private var windowManager = FloatingWindowManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main App Content
                InfiniteCanvasView()
                    .ignoresSafeArea()
                    // Keyboard shortcut to toggle Omnibox
                    .onKeyPress(keys: [.return]) { press in
                        return .ignored
                    }
                
                // Hidden button for keyboard shortcut
                Button("") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isOmniboxPresented.toggle()
                    }
                }
                .keyboardShortcut("k", modifiers: .command)
                .opacity(0)

                #if os(macOS)
                Button("") {
                    openBrowserWindow()
                }
                .keyboardShortcut("b", modifiers: .command)
                .opacity(0)
                #endif

                #if !os(macOS)
                // Floating Browser View
                FloatingBrowserView(manager: windowManager, containerSize: geometry.size)
                    // Apply corner dragging modifier
                    .draggableCorner(
                        itemType: .browser,
                        manager: windowManager,
                        containerSize: geometry.size,
                        itemSize: windowManager.browserSizeLevel.dimensions(in: geometry.size)
                    )
                    .zIndex(10)
                #endif
                
                // Floating AI Button
                FloatingAiButton {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isOmniboxPresented.toggle()
                    }
                }
                .draggableCorner(
                    itemType: .aiButton,
                    manager: windowManager,
                    containerSize: geometry.size,
                    itemSize: CGSize(width: 60, height: 60)
                )
                .zIndex(20)
                
                // Omnibox Overlay
                if isOmniboxPresented {
                    OmniboxView(isPresented: $isOmniboxPresented)
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                        .zIndex(100)
                }
            }
            // Ensure ZStack takes up the full GeometryReader
            .frame(width: geometry.size.width, height: geometry.size.height)
            #if os(macOS)
            .onAppear {
                openBrowserWindowIfNeeded()
            }
            #endif
        }
        .ignoresSafeArea(.keyboard)
    }

    #if os(macOS)
    private func openBrowserWindowIfNeeded() {
        guard !browserState.hasOpenedInitialWindow else { return }
        browserState.hasOpenedInitialWindow = true
        openWindow(id: BrowserWindowState.windowID)
    }

    private func openBrowserWindow() {
        openWindow(id: BrowserWindowState.windowID)
    }
    #endif
}

#Preview {
    ContentView()
        .environmentObject(BrowserWindowState())
}
