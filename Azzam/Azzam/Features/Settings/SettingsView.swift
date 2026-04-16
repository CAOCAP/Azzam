//
//  SettingsView.swift
//  Azzam
//
//  Created by Assistant on 16/04/2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("canvasDotColor") private var dotColor: Color = .gray
    
    var body: some View {
        TabView {
            Form {
                Section {
                    ColorPicker("Grid Dot Color", selection: $dotColor, supportsOpacity: true)
                }
            }
            .padding()
            .tabItem {
                Label("Editor", systemImage: "macwindow.badge.plus")
            }
        }
        .frame(width: 400, height: 200)
    }
}
