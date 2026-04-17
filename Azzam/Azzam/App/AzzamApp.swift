//
//  AzzamApp.swift
//  Azzam
//
//  Created by الشيخ عزام on 16/04/2026.
//

import SwiftUI

@main
struct AzzamApp: App {
    @StateObject private var browserState = BrowserWindowState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(browserState)
        }

        #if os(macOS)
        Window("Browser", id: BrowserWindowState.windowID) {
            BrowserWindowView()
                .environmentObject(browserState)
        }
        .defaultSize(width: 1100, height: 780)
        
        Settings {
            SettingsView()
        }
        #endif
    }
}
