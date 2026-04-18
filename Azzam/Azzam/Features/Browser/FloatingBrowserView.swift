import SwiftUI

struct FloatingBrowserView: View {
    @ObservedObject var manager: FloatingWindowManager
    @EnvironmentObject private var browserState: BrowserWindowState
    let containerSize: CGSize

    // For resizing
    @State private var dragTranslation: CGSize = .zero
    // For full-screen drag-to-dismiss
    @State private var fullScreenDragOffset: CGFloat = 0
    // Cycle direction
    @State private var isExpanding: Bool = true
    
    var currentDimensions: CGSize {
        manager.browserSizeLevel.dimensions(in: containerSize)
    }
    
    var isFullScreen: Bool {
        manager.browserSizeLevel == .fullScreen
    }
    
    var handleCorner: ScreenCorner {
        switch manager.browserCorner {
        case .topLeft: return .bottomRight
        case .topRight: return .bottomLeft
        case .bottomLeft: return .topRight
        case .bottomRight: return .topLeft
        }
    }
    
    var activeWidth: CGFloat {
        let base = currentDimensions.width
        switch handleCorner {
        case .bottomRight, .bottomLeft:
            let multiplier: CGFloat = (handleCorner == .bottomRight || handleCorner == .topRight) ? 1 : -1
            return max(containerSize.width * 0.1, base + dragTranslation.width * multiplier)
        case .topLeft, .topRight:
            let multiplier: CGFloat = (handleCorner == .topLeft || handleCorner == .bottomLeft) ? -1 : 1
            return max(containerSize.width * 0.1, base + dragTranslation.width * multiplier)
        }
    }
    
    private var topBarGesture: AnyGesture<DragGesture.Value> {
        AnyGesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        withAnimation(.interactiveSpring()) {
                            fullScreenDragOffset = value.translation.height
                        }
                    }
                }
                .onEnded { value in
                    if value.translation.height > 120 {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            manager.browserSizeLevel = .medium
                            isExpanding = false
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
    }
    
    var body: some View {
        ZStack {
            // High-end glass background
            RoundedRectangle(cornerRadius: isFullScreen ? (fullScreenDragOffset > 0 ? 32 : 0) : 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(isFullScreen ? (fullScreenDragOffset > 0 ? 0.2 : 0) : 0.2), radius: isFullScreen ? (fullScreenDragOffset > 0 ? 30 : 0) : 30, x: 0, y: isFullScreen ? (fullScreenDragOffset > 0 ? 15 : 0) : 15)
                .overlay(
                    RoundedRectangle(cornerRadius: isFullScreen ? (fullScreenDragOffset > 0 ? 32 : 0) : 32, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .white.opacity(0.1), .black.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            BrowserContentView(
                browserState: browserState,
                showsGrabber: true,
                topBarGesture: isFullScreen ? topBarGesture : nil
            ) {
                if isFullScreen {
                    Button(action: {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                            manager.browserSizeLevel = .medium
                            isExpanding = false
                            playHaptic()
                        }
                    }) {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.secondary)
                            .padding(8)
                            .background(Circle().fill(Color.secondary.opacity(0.1)))
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        browserState.reload()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: isFullScreen ? (fullScreenDragOffset > 0 ? 32 : 0) : 32, style: .continuous))
            
            // Interaction Handles
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
            if handleCorner == .bottomLeft || handleCorner == .bottomRight { Spacer(minLength: 0) }
            HStack {
                if handleCorner == .topRight || handleCorner == .bottomRight { Spacer(minLength: 0) }
                
                Image(systemName: handleIcon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    )
                    .padding(10)
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
            if handleCorner == .topLeft || handleCorner == .topRight { Spacer(minLength: 0) }
        }
    }
    
    private var handleIcon: String {
        switch handleCorner {
        case .topLeft, .bottomRight:
            return isExpanding ? "arrow.up.left.and.arrow.down.right" : "arrow.down.right.and.arrow.up.left"
        case .topRight, .bottomLeft:
            return isExpanding ? "arrow.up.right.and.arrow.down.left" : "arrow.down.left.and.arrow.up.right"
        }
    }
    
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
            nextIndex = isExpanding ? currentIndex + 1 : currentIndex - 1
        }
        
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
        let levels = BrowserSizeLevel.allCases
        let closest = levels.min(by: { abs($0.scale - finalScale) < abs($1.scale - finalScale) }) ?? .medium
        
        if closest == .tiny {
            isExpanding = true
        } else if closest == .fullScreen {
            isExpanding = false
        } else if let currentIdx = levels.firstIndex(of: manager.browserSizeLevel),
                  let targetIdx = levels.firstIndex(of: closest) {
            if targetIdx > currentIdx { isExpanding = true }
            else if targetIdx < currentIdx { isExpanding = false }
        }
        
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
