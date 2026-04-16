//
//  PlaceholderNodeView.swift
//  Azzam
//
//  Created by Assistant on 16/04/2026.
//

import SwiftUI

struct PlaceholderNodeView: View {
    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                Text("Idea Node")
                    .font(.headline)
            }
            
            Text("This is a placeholder node on the infinite canvas. Drag me around!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 250)
        .background(
            RoundedRectangle(cornerRadius: 12)
                #if os(macOS)
                .fill(Color(nsColor: .windowBackgroundColor).opacity(0.8))
                #else
                .fill(Color(uiColor: .systemBackground).opacity(0.8))
                #endif
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .offset(
            x: offset.width + dragOffset.width,
            y: offset.height + dragOffset.height
        )
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    offset.width += value.translation.width
                    offset.height += value.translation.height
                }
        )
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        PlaceholderNodeView()
    }
}
