import SwiftUI

struct BrowserWindowView: View {
    @EnvironmentObject private var browserState: BrowserWindowState

    var body: some View {
        ZStack {
            #if os(macOS)
            LinearGradient(
                colors: [
                    Color(nsColor: .underPageBackgroundColor),
                    Color(nsColor: .windowBackgroundColor)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            #endif

            BrowserContentView(browserState: browserState) {
                Button(action: {
                    browserState.reload()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.4), .white.opacity(0.1), .black.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: 12)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(16)
        }
        .frame(minWidth: 900, minHeight: 650)
    }
}
