//
//  CanvasGridPattern.swift
//  Azzam
//
//  Created by Assistant on 16/04/2026.
//

import SwiftUI

struct CanvasGridPattern: View {
    @AppStorage("canvasDotColor") private var dotColor: Color = .gray
    let spacing: CGFloat = 20
    let dotSize: CGFloat = 2
    
    @State private var tiledImage: Image?

    var body: some View {
        Group {
            if let tiledImage = tiledImage {
                tiledImage
                    .resizable(resizingMode: .tile)
                    .ignoresSafeArea()
            } else {
                Color.clear
            }
        }
        .onAppear {
            updatePatternImage()
        }
        .onChange(of: dotColor) { _, _ in
            updatePatternImage()
        }
    }
    
    @MainActor
    private func updatePatternImage() {
        let dotView = ZStack {
            Color.clear
            Circle()
                .fill(dotColor)
                .frame(width: dotSize, height: dotSize)
                // Offset the dot to the top leading corner for classic grid alignment
                .position(x: dotSize / 2, y: dotSize / 2)
        }
        .frame(width: spacing, height: spacing)

        let renderer = ImageRenderer(content: dotView)
        // Ensure standard resolution scale
        renderer.scale = 2.0 
        
        #if os(macOS)
        if let nsImage = renderer.nsImage {
            // Need to set isTemplate if we want to tint it, but we render with the correct color already
            self.tiledImage = Image(nsImage: nsImage)
        }
        #else
        if let uiImage = renderer.uiImage {
            self.tiledImage = Image(uiImage: uiImage)
        }
        #endif
    }
}
