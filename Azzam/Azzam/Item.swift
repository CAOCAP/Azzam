//
//  Item.swift
//  Azzam
//
//  Created by الشيخ عزام on 16/04/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
