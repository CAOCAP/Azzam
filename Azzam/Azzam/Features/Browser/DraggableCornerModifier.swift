import SwiftUI

struct DraggableCornerModifier: ViewModifier {
    let itemType: FloatingWindowManager.ItemType
    @ObservedObject var manager: FloatingWindowManager
    let containerSize: CGSize
    let itemSize: CGSize
    
    @State private var dragLocation: CGPoint? = nil
    
    var currentCorner: ScreenCorner {
        itemType == .browser ? manager.browserCorner : manager.aiButtonCorner
    }
    
    var isFullScreen: Bool {
        itemType == .browser && manager.browserSizeLevel == .fullScreen
    }
    
    var position: CGPoint {
        if isFullScreen {
            return CGPoint(x: containerSize.width / 2, y: containerSize.height / 2)
        }
        if let dragLocation = dragLocation {
            return dragLocation
        } else {
            return currentCorner.point(in: containerSize, itemSize: itemSize)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(dragLocation != nil ? 1.03 : 1.0)
            .shadow(color: Color.black.opacity(dragLocation != nil ? 0.2 : 0.0), radius: dragLocation != nil ? 30 : 0, x: 0, y: dragLocation != nil ? 15 : 0)
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isFullScreen else { return }
                        if dragLocation == nil {
                            // Initial drag haptic
                            #if os(iOS)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            #endif
                        }
                        withAnimation(.interactiveSpring()) {
                            dragLocation = value.location
                        }
                    }
                    .onEnded { value in
                        guard !isFullScreen else { return }
                        let nearestCorner = ScreenCorner.nearest(to: value.location, in: containerSize)
                        
                        // Haptic feedback
                        #if os(iOS)
                        let impactLight = UIImpactFeedbackGenerator(style: .rigid)
                        impactLight.impactOccurred()
                        #endif
                        
                        // Animate snap to corner and handle potential swap
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            manager.moveItem(itemType, to: nearestCorner)
                            dragLocation = nil
                        }
                    }
            )
            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: currentCorner)
    }
}

extension View {
    func draggableCorner(itemType: FloatingWindowManager.ItemType, manager: FloatingWindowManager, containerSize: CGSize, itemSize: CGSize) -> some View {
        self.modifier(DraggableCornerModifier(itemType: itemType, manager: manager, containerSize: containerSize, itemSize: itemSize))
    }
}
