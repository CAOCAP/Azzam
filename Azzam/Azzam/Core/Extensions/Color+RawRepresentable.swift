//
//  Color+RawRepresentable.swift
//  Azzam
//
//  Created by Assistant on 16/04/2026.
//

import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Color: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .gray
            return
        }
        do {
            #if os(macOS)
            if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) {
                self = Color(nsColor: color)
                return
            }
            #else
            if let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
                self = Color(uiColor: color)
                return
            }
            #endif
        } catch {
            print("Failed to unarchive color: \(error)")
        }
        self = .gray
    }

    public var rawValue: String {
        do {
            #if os(macOS)
            let platformColor = NSColor(self)
            let data = try NSKeyedArchiver.archivedData(withRootObject: platformColor, requiringSecureCoding: false)
            #else
            let platformColor = UIColor(self)
            let data = try NSKeyedArchiver.archivedData(withRootObject: platformColor, requiringSecureCoding: false)
            #endif
            return data.base64EncodedString()
        } catch {
            print("Failed to archive color: \(error)")
            return ""
        }
    }
}
