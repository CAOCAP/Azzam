//
//  FloatingAiButton.swift
//  Azzam
//
//  Created by App on 16/04/2026.
//

import SwiftUI

struct FloatingAiButton: View {
    let action: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            // Add a subtle haptic feedback here if desired
            #if os(iOS)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            #endif
            action()
        }) {
            ZStack {
                // Subtle Glow effect
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .blur(radius: isAnimating ? 15 : 5)
                    .scaleEffect(isAnimating ? 1.15 : 1.0)
                
                // Main Button
                Circle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                
                // Icon
                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        FloatingAiButton {
            print("AI Button Tapped")
        }
    }
}
