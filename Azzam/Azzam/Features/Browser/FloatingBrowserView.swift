import SwiftUI

struct FloatingBrowserView: View {
    @ObservedObject var manager: FloatingWindowManager
    let containerSize: CGSize
    
    // For resizing
    @State private var dragTranslation: CGSize = .zero
    // For full-screen drag-to-dismiss
    @State private var fullScreenDragOffset: CGFloat = 0
    
    var currentDimensions: CGSize {
        manager.browserSizeLevel.dimensions(in: containerSize)
    }
    
    var isFullScreen: Bool {
        manager.browserSizeLevel == .fullScreen
    }
    
    // The handle should always be in the corner opposite to where the window is anchored
    var handleCorner: ScreenCorner {
        switch manager.browserCorner {
        case .topLeft: return .bottomRight
        case .topRight: return .bottomLeft
        case .bottomLeft: return .topRight
        case .bottomRight: return .topLeft
        }
    }
    
    // Calculate the width during an active drag
    var activeWidth: CGFloat {
        let base = currentDimensions.width
        switch handleCorner {
        case .bottomRight, .bottomLeft:
            // Growing right or left from bottom
            let multiplier: CGFloat = (handleCorner == .bottomRight || handleCorner == .topRight) ? 1 : -1
            return max(containerSize.width * 0.1, base + dragTranslation.width * multiplier)
        case .topLeft, .topRight:
            // Growing up/left or up/right
            let multiplier: CGFloat = (handleCorner == .topLeft || handleCorner == .bottomLeft) ? -1 : 1
            return max(containerSize.width * 0.1, base + dragTranslation.width * multiplier)
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: isFullScreen ? (fullScreenDragOffset > 0 ? 24 : 0) : 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(isFullScreen ? (fullScreenDragOffset > 0 ? 0.15 : 0) : 0.15), radius: isFullScreen ? (fullScreenDragOffset > 0 ? 20 : 0) : 20, x: 0, y: isFullScreen ? (fullScreenDragOffset > 0 ? 10 : 0) : 10)
                .overlay(
                    RoundedRectangle(cornerRadius: isFullScreen ? (fullScreenDragOffset > 0 ? 24 : 0) : 24, style: .continuous)
                        .stroke(Color.white.opacity(isFullScreen ? (fullScreenDragOffset > 0 ? 0.1 : 0) : 0.2), lineWidth: 1)
                )
            
            VStack(spacing: 0) {
                // Top Bar / Grab Area
                ZStack {
                    Capsule()
                        .fill(Color.secondary.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .padding(.vertical, 12)
                    
                    if isFullScreen {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                    manager.browserSizeLevel = .medium
                                    playHaptic()
                                }
                            }) {
                                Image(systemName: "arrow.down.right.and.arrow.up.left")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .padding(16)
                                    .background(Circle().fill(Color.secondary.opacity(0.1)))
                                    .padding(8)
                            }
                        }
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard isFullScreen else { return }
                            if value.translation.height > 0 {
                                withAnimation(.interactiveSpring()) {
                                    fullScreenDragOffset = value.translation.height
                                }
                            }
                        }
                        .onEnded { value in
                            guard isFullScreen else { return }
                            if value.translation.height > 120 {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    manager.browserSizeLevel = .medium
                                    fullScreenDragOffset = 0
                                    playHaptic()
                                }
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    fullScreenDragOffset = 0
                                }
                            }
                        }
                )
                
                WebView(url: URL(string: "https://www.google.com")!)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.05))
            }
            .clipShape(RoundedRectangle(cornerRadius: isFullScreen ? (fullScreenDragOffset > 0 ? 24 : 0) : 24, style: .continuous))
            
            // Resize Handle Placement
            if !isFullScreen {
                resizeHandleOverlay
            }
        }
        .frame(width: activeWidth, height: activeWidth * (containerSize.height / containerSize.width))
        .offset(y: fullScreenDragOffset)
        .allowsHitTesting(true)
    }
    
    private var resizeHandleOverlay: some View {
        VStack {
            if handleCorner == .topLeft || handleCorner == .topRight { Spacer(minLength: 0) }
            HStack {
                if handleCorner == .topRight || handleCorner == .bottomRight { Spacer(minLength: 0) }
                
                Image(systemName: handleIcon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding(14)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .padding(8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        cycleSize()
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.interactiveSpring()) {
                                    dragTranslation = value.translation
                                }
                            }
                            .onEnded { value in
                                finalizeResize(translation: value.translation)
                                dragTranslation = .zero
                            }
                    )
                
                if handleCorner == .topLeft || handleCorner == .bottomLeft { Spacer(minLength: 0) }
            }
            if handleCorner == .bottomLeft || handleCorner == .bottomRight { Spacer(minLength: 0) }
        }
    }
    
    private var handleIcon: String {
        switch handleCorner {
        case .topLeft, .bottomRight: return "arrow.up.left.and.arrow.down.right"
        case .topRight, .bottomLeft: return "arrow.up.right.and.arrow.down.left"
        }
    }
    
    @State private var isExpanding: Bool = true
    
    private func cycleSize() {
        let allCases = BrowserSizeLevel.allCases
        guard let currentIndex = allCases.firstIndex(of: manager.browserSizeLevel) else { return }
        
        var nextIndex: Int
        
        if manager.browserSizeLevel == .tiny {
            isExpanding = true
            nextIndex = 1
        } else if manager.browserSizeLevel == .fullScreen {
            isExpanding = false
            nextIndex = currentIndex - 1
        } else {
            // In between tiny and fullScreen, follow the current direction
            nextIndex = isExpanding ? currentIndex + 1 : currentIndex - 1
        }
        
        // Final safety check and direction flip at bounds
        if nextIndex >= allCases.count - 1 {
            isExpanding = false
        } else if nextIndex <= 0 {
            isExpanding = true
        }
        
        let nextLevel = allCases[nextIndex]
        
        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
            manager.browserSizeLevel = nextLevel
            playHaptic()
        }
    }
    
    private func finalizeResize(translation: CGSize) {
        let finalWidth = activeWidth
        let finalScale = finalWidth / containerSize.width
        
        // Find the closest scale level
        let levels = BrowserSizeLevel.allCases
        let closest = levels.min(by: { abs($0.scale - finalScale) < abs($1.scale - finalScale) }) ?? .medium
        
        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
            manager.browserSizeLevel = closest
            playHaptic()
        }
    }
    
    private func playHaptic() {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        #endif
    }
}
