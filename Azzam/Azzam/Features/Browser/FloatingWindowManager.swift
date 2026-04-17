//
//  FloatingWindowManager.swift
//  Azzam
//

import SwiftUI

enum ScreenCorner: CaseIterable {
    case topLeft, topRight, bottomLeft, bottomRight
    
    // Convert corner to a point given a container size and item size
    func point(in containerSize: CGSize, itemSize: CGSize, padding: CGFloat = 24) -> CGPoint {
        let x: CGFloat
        let y: CGFloat
        
        switch self {
        case .topLeft:
            x = padding + itemSize.width / 2
            y = padding + itemSize.height / 2
        case .topRight:
            x = containerSize.width - padding - itemSize.width / 2
            y = padding + itemSize.height / 2
        case .bottomLeft:
            x = padding + itemSize.width / 2
            y = containerSize.height - padding - itemSize.height / 2
        case .bottomRight:
            x = containerSize.width - padding - itemSize.width / 2
            y = containerSize.height - padding - itemSize.height / 2
        }
        
        return CGPoint(x: x, y: y)
    }
    
    // Find the nearest corner to a given point
    static func nearest(to point: CGPoint, in containerSize: CGSize) -> ScreenCorner {
        let isLeft = point.x < containerSize.width / 2
        let isTop = point.y < containerSize.height / 2
        
        switch (isLeft, isTop) {
        case (true, true): return .topLeft
        case (false, true): return .topRight
        case (true, false): return .bottomLeft
        case (false, false): return .bottomRight
        }
    }
}

enum BrowserSizeLevel: Int, CaseIterable, Comparable {
    case superSmall = 0
    case small
    case medium
    case large
    case almostFullScreen
    case fullScreen
    
    static func < (lhs: BrowserSizeLevel, rhs: BrowserSizeLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    // Returns relative size multipliers (width, height)
    func dimensions(in containerSize: CGSize) -> CGSize {
        // We use a scaling factor to perfectly respect the device's aspect ratio.
        // This ensures the browser is never wider or taller than the device itself.
        let scale: CGFloat
        
        switch self {
        case .superSmall:
            scale = 0.35
        case .small:
            scale = 0.50
        case .medium:
            scale = 0.65
        case .large:
            scale = 0.80
        case .almostFullScreen:
            scale = 0.95
        case .fullScreen:
            scale = 1.0
        }
        
        let width = containerSize.width * scale
        let height = containerSize.height * scale
        
        return CGSize(width: width, height: height)
    }
}

class FloatingWindowManager: ObservableObject {
    @Published var browserCorner: ScreenCorner = .topLeft
    @Published var aiButtonCorner: ScreenCorner = .bottomRight
    @Published var browserSizeLevel: BrowserSizeLevel = .medium
    
    // Move an item to a new corner, handling the swap logic
    func moveItem(_ item: ItemType, to corner: ScreenCorner) {
        switch item {
        case .browser:
            if corner == aiButtonCorner {
                // Swap
                aiButtonCorner = browserCorner
            }
            browserCorner = corner
        case .aiButton:
            if corner == browserCorner {
                // Swap
                browserCorner = aiButtonCorner
            }
            aiButtonCorner = corner
        }
    }
    
    enum ItemType {
        case browser, aiButton
    }
}
