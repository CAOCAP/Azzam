import SwiftUI
import WebKit

@MainActor
final class BrowserWindowState: ObservableObject {
    nonisolated static let windowID = "browser"
    nonisolated static let defaultURL = URL(string: "https://www.google.com")!

    let webView: WKWebView

    @Published var currentURL: URL
    @Published var isLoading = false
    @Published var progress: Double = 0
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var pageTitle = ""
    @Published var command: WebCommand = .none
    @Published var hasOpenedInitialWindow = false

    init(initialURL: URL = BrowserWindowState.defaultURL) {
        currentURL = initialURL

        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true

        #if canImport(UIKit)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        #endif
    }

    func goBack() {
        command = .goBack
    }

    func goForward() {
        command = .goForward
    }

    func reload() {
        command = .reload
    }
}
