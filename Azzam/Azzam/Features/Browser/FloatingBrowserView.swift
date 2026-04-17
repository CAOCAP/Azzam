import SwiftUI
import WebKit

struct FloatingBrowserView: View {
    @ObservedObject var manager: FloatingWindowManager
    let containerSize: CGSize
    
    // Web State
    @State private var isLoading: Bool = false
    @State private var progress: Double = 0
    @State private var canGoBack: Bool = false
    @State private var canGoForward: Bool = false
    @State private var pageTitle: String = ""
    @State private var webCommand: WebCommand = .none
    
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
    
    private var topBarGesture: some Gesture {
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
            
            VStack(spacing: 0) {
                // Navigation Bar Area
                VStack(spacing: 0) {
                    // Top Grab/Pill
                    Capsule()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(width: 36, height: 4)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    HStack(spacing: 12) {
                        // Navigation Controls
                        HStack(spacing: 16) {
                            navButton(systemName: "chevron.left", enabled: canGoBack) {
                                webCommand = .goBack
                            }
                            navButton(systemName: "chevron.right", enabled: canGoForward) {
                                webCommand = .goForward
                            }
                        }
                        .padding(.leading, 12)
                        
                        // Address/Title Field
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.7)
                                    .frame(width: 14, height: 14)
                            } else {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(pageTitle.isEmpty ? "Search or enter website" : pageTitle)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.primary.opacity(0.7))
                                .lineLimit(1)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.primary.opacity(0.06))
                        )
                        
                        // Action Buttons
                        HStack(spacing: 12) {
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
                            } else {
                                Button(action: {
                                    webCommand = .reload
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.trailing, 12)
                    }
                    .padding(.bottom, 10)
                    
                    // Progress Indicator Line
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 2)
                        
                        if isLoading && progress < 1.0 {
                            Rectangle()
                                .fill(Color.blue.opacity(0.8))
                                .frame(width: activeWidth * CGFloat(progress), height: 2)
                        }
                    }
                }
                .contentShape(Rectangle())
                .gesture(isFullScreen ? topBarGesture : nil)
                
                // Web Content View
                WebView(
                    url: URL(string: "https://www.google.com")!,
                    isLoading: $isLoading,
                    progress: $progress,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    title: $pageTitle,
                    command: $webCommand
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.02))
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
    
    private func navButton(systemName: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(enabled ? .primary.opacity(0.7) : .primary.opacity(0.2))
        }
        .disabled(!enabled)
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
