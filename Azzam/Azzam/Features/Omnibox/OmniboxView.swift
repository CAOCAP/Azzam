//
//  OmniboxView.swift
//  Azzam
//
//  Created by App on 16/04/2026.
//

import SwiftUI

struct OmniboxView: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    // Placeholder suggestions
    let suggestions = [
        "Create a new component...",
        "Explain the selected code...",
        "Refactor this function...",
        "Search files..."
    ]
    
    var body: some View {
        ZStack {
            // Invisible background to dismiss on tap
            Color.black.opacity(0.01)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isPresented = false
                    }
                }
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "sparkle.magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 20))
                    
                    TextField("What do you want to build?", text: $searchText)
                        .focused($isTextFieldFocused)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .submitLabel(.search)
                        .onSubmit {
                            // Handle submission here later
                            print("Submitted: \(searchText)")
                            withAnimation { isPresented = false }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Suggestions List
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(action: {
                                searchText = suggestion
                                // Handle suggestion tap
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.circle")
                                        .foregroundColor(.secondary)
                                    Text(suggestion)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding()
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            .onHover { isHovered in
                                // Add hover effect if needed on macOS
                            }
                        }
                    }
                }
                .frame(maxHeight: 250)
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 30, x: 0, y: 15)
            .frame(maxWidth: 600)
            .padding(.horizontal, 24)
            // Push slightly towards the top
            .padding(.bottom, 200)
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        OmniboxView(isPresented: .constant(true))
    }
}
