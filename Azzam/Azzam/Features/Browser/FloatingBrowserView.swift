import SwiftUI

struct FloatingBrowserView: View {
    @ObservedObject var manager: FloatingWindowManager
    let containerSize: CGSize
    
    // For resizing
    @State private var dragOffset: CGSize = .zero
    
    var currentDimensions: CGSize {
        manager.browserSizeLevel.dimensions(in: containerSize)
    }
    
    var isFullScreen: Bool {
        manager.browserSizeLevel == .fullScreen
    }
    
    var body: some View {
        ZStack {
            // Glassmorphism background
            RoundedRectangle(cornerRadius: isFullScreen ? 0 : 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(isFullScreen ? 0 : 0.15), radius: isFullScreen ? 0 : 20, x: 0, y: isFullScreen ? 0 : 10)
                .overlay(
                    RoundedRectangle(cornerRadius: isFullScreen ? 0 : 24, style: .continuous)
                        .stroke(Color.white.opacity(isFullScreen ? 0 : 0.2), lineWidth: 1)
                )
            
            VStack(spacing: 0) {
                // Top bar / Drag Handle
                ZStack {
                    HStack {
                        Spacer()
                        if !isFullScreen {
                            Capsule()
                                .fill(Color.secondary.opacity(0.5))
                                .frame(width: 40, height: 5)
                                .padding(.top, 12)
                                .padding(.bottom, 8)
                        }
                        Spacer()
                    }
                    
                    if isFullScreen {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    manager.browserSizeLevel = .almostFullScreen
                                    playHaptic()
                                }
                            }) {
                                Image(systemName: "arrow.down.right.and.arrow.up.left")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .padding(16)
                                    .contentShape(Rectangle())
                            }
                        }
                    }
                }
                
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "safari")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("Browser")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .clipShape(RoundedRectangle(cornerRadius: isFullScreen ? 0 : 24, style: .continuous))
            
            // Resize Handle (Bottom Right)
            if !isFullScreen {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
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
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        handleResizeEnded(translation: value.translation)
                                        dragOffset = .zero
                                    }
                            )
                    }
                }
            }
        }
        .frame(
            width: max(100, currentDimensions.width + dragOffset.width),
            height: max(100, currentDimensions.height + dragOffset.height)
        )
        // Disable corner dragging when in fullscreen mode
        .allowsHitTesting(true)
    }
    
    private func handleResizeEnded(translation: CGSize) {
        // Simple logic: if dragged outwards significantly, increase size.
        // If dragged inwards significantly, decrease size.
        let delta = max(translation.width, translation.height)
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            if delta > 40 {
                // Increase size
                increaseSize()
            } else if delta < -40 {
                // Decrease size
                decreaseSize()
            }
        }
    }
    
    private func increaseSize() {
        let allCases = BrowserSizeLevel.allCases
        guard let currentIndex = allCases.firstIndex(of: manager.browserSizeLevel),
              currentIndex < allCases.count - 1 else { return }
        manager.browserSizeLevel = allCases[currentIndex + 1]
        playHaptic()
    }
    
    private func decreaseSize() {
        let allCases = BrowserSizeLevel.allCases
        guard let currentIndex = allCases.firstIndex(of: manager.browserSizeLevel),
              currentIndex > 0 else { return }
        manager.browserSizeLevel = allCases[currentIndex - 1]
        playHaptic()
    }
    
    private func playHaptic() {
        #if os(iOS)
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        #endif
    }
}
