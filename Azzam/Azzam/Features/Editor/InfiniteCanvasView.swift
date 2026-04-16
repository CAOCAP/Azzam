//
//  InfiniteCanvasView.swift
//  Azzam
//
//  Created by Assistant on 16/04/2026.
//

import SwiftUI

struct InfiniteCanvasView: View {
    // A massive size to simulate an infinite canvas.
    // CoreAnimation handles tiling efficiently so this won't blow up memory.
    private let canvasSize: CGFloat = 100_000
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ScrollViewReader { proxy in
                ZStack {
                    // The tiling dot pattern
                    CanvasGridPattern()
                        .frame(width: canvasSize, height: canvasSize)
                    
                    // Invisible center anchor to scroll to on appear
                    Color.clear
                        .frame(width: 1, height: 1)
                        .id("CenterAnchor")
                        .position(x: canvasSize / 2, y: canvasSize / 2)
                    
                    // Our interactive node
                    PlaceholderNodeView()
                        .position(x: canvasSize / 2, y: canvasSize / 2)
                }
                .frame(width: canvasSize, height: canvasSize)
                .onAppear {
                    // Snap to the center of the massive canvas immediately
                    proxy.scrollTo("CenterAnchor", anchor: .center)
                }
            }
        }
        // Give the scroll view a background so it captures drag events everywhere
        #if os(macOS)
        .background(Color(nsColor: .windowBackgroundColor))
        #else
        .background(Color(uiColor: .systemBackground))
        #endif
    }
}

#Preview {
    InfiniteCanvasView()
}
