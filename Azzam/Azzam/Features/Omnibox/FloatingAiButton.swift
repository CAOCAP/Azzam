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
                // Glow effect
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6), Color.pink.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .blur(radius: isAnimating ? 20 : 10)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                
                // Main Button
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.purple, Color.blue, Color.pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
                
                // Icon
                Image(systemName: "sparkles")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isAnimating ? 10 : -10))
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
