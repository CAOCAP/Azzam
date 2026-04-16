//
//  AzzamApp.swift
//  Azzam
//
//  Created by الشيخ عزام on 16/04/2026.
//

import SwiftUI

@main
struct AzzamApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
