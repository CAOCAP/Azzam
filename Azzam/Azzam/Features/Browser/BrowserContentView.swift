import SwiftUI

struct BrowserContentView<TrailingActions: View>: View {
    @ObservedObject var browserState: BrowserWindowState
    var showsGrabber = false
    var topBarGesture: AnyGesture<DragGesture.Value>?
    @ViewBuilder let trailingActions: () -> TrailingActions

    var body: some View {
        VStack(spacing: 0) {
            toolbarSection

            WebView(state: browserState)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.02))
        }
    }

    @ViewBuilder
    private var toolbarSection: some View {
        let toolbar = VStack(spacing: 0) {
            if showsGrabber {
                Capsule()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 36, height: 4)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
            }

            HStack(spacing: 12) {
                HStack(spacing: 16) {
                    navButton(systemName: "chevron.left", enabled: browserState.canGoBack) {
                        browserState.goBack()
                    }
                    navButton(systemName: "chevron.right", enabled: browserState.canGoForward) {
                        browserState.goForward()
                    }
                }
                .padding(.leading, 12)

                HStack {
                    if browserState.isLoading {
                        ProgressView()
                            .scaleEffect(0.7)
                            .frame(width: 14, height: 14)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }

                    Text(browserState.pageTitle.isEmpty ? "Search or enter website" : browserState.pageTitle)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.primary.opacity(0.7))
                        .lineLimit(1)

                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.primary.opacity(0.06))
                )

                HStack(spacing: 12) {
                    trailingActions()
                }
                .padding(.trailing, 12)
            }
            .padding(.bottom, 10)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)

                    if browserState.isLoading && browserState.progress < 1.0 {
                        Rectangle()
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: geometry.size.width * browserState.progress, height: 2)
                    }
                }
            }
            .frame(height: 2)
        }
        .contentShape(Rectangle())

        if let topBarGesture {
            toolbar.gesture(topBarGesture)
        } else {
            toolbar
        }
    }

    private func navButton(systemName: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(enabled ? .primary.opacity(0.7) : .primary.opacity(0.2))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!enabled)
    }
}
