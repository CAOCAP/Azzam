//
//  ContentView.swift
//  Azzam
//
//  Created by الشيخ عزام on 16/04/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("CAOCAP Azzam: Intent-Driven IDE")
                .font(.headline)
            Text("Development Day 1 Foundation")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
    }
}

#Preview {
    ContentView()
}
