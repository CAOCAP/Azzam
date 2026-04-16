//
//  ContentView.swift
//  Azzam
//
//  Created by الشيخ عزام on 16/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var isOmniboxPresented = false
    
    var body: some View {
        ZStack {
            // Main App Content
            InfiniteCanvasView()
                .ignoresSafeArea()
                // Keyboard shortcut to toggle Omnibox
                .onKeyPress(keys: [.return]) { press in
                    // Just an example if we want to catch return, but we will use keyboardShortcut below
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
            
            // Floating AI Button Overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingAiButton {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isOmniboxPresented.toggle()
                        }
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
            
            // Omnibox Overlay
            if isOmniboxPresented {
                OmniboxView(isPresented: $isOmniboxPresented)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .zIndex(100)
            }
        }
    }
}

#Preview {
    ContentView()
}
