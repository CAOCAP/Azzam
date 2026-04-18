//
//  WebView.swift
//  Azzam
//

import SwiftUI
import WebKit

#if canImport(UIKit)
import UIKit
typealias PlatformViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
import AppKit
typealias PlatformViewRepresentable = NSViewRepresentable
#endif

enum WebCommand: Equatable {
    case none
    case goBack
    case goForward
    case reload
}

struct WebView: PlatformViewRepresentable {
    @ObservedObject var state: BrowserWindowState
    
    // Cross-platform view creation
    #if canImport(UIKit)
    func makeUIView(context: Context) -> WKWebView {
        createWebView(context: context)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        updateWebView(uiView, context: context)
    }
    #else
    func makeNSView(context: Context) -> WKWebView {
        createWebView(context: context)
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        updateWebView(nsView, context: context)
    }
    #endif
    
    private func createWebView(context: Context) -> WKWebView {
        let webView = state.webView
        webView.navigationDelegate = context.coordinator

        context.coordinator.setupObservers(for: webView)
        return webView
    }
    
    private func updateWebView(_ webView: WKWebView, context: Context) {
        let needsInitialLoad = webView.url == nil && context.coordinator.lastLoadedURL == nil
        let urlChangedOutsideWebView = context.coordinator.lastLoadedURL != state.currentURL

        if needsInitialLoad || urlChangedOutsideWebView {
            context.coordinator.lastLoadedURL = state.currentURL

            if webView.url != state.currentURL || needsInitialLoad {
                webView.load(URLRequest(url: state.currentURL))
            }
        }
        
        if state.command != .none {
            switch state.command {
            case .goBack: webView.goBack()
            case .goForward: webView.goForward()
            case .reload: webView.reload()
            case .none: break
            }
            
            DispatchQueue.main.async {
                self.state.command = .none
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(state: state)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let state: BrowserWindowState
        var observers: [NSKeyValueObservation] = []
        var lastLoadedURL: URL?
        private var observedWebViewID: ObjectIdentifier?
        
        init(state: BrowserWindowState) {
            self.state = state
        }
        
        func setupObservers(for webView: WKWebView) {
            let webViewID = ObjectIdentifier(webView)
            guard observedWebViewID != webViewID else { return }

            observers.forEach { $0.invalidate() }
            observers.removeAll()
            observedWebViewID = webViewID
            lastLoadedURL = webView.url

            observers = [
                webView.observe(\.estimatedProgress, options: .new) { [weak self] _, change in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.state.progress = change.newValue ?? 0
                    }
                },
                webView.observe(\.isLoading, options: .new) { [weak self] _, change in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.state.isLoading = change.newValue ?? false
                    }
                },
                webView.observe(\.canGoBack, options: .new) { [weak self] _, change in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.state.canGoBack = change.newValue ?? false
                    }
                },
                webView.observe(\.canGoForward, options: .new) { [weak self] _, change in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.state.canGoForward = change.newValue ?? false
                    }
                },
                webView.observe(\.title, options: .new) { [weak self] webView, _ in
                    guard let self else { return }
                    let newTitle = webView.title ?? ""
                    DispatchQueue.main.async {
                        self.state.pageTitle = newTitle
                    }
                },
                webView.observe(\.url, options: .new) { [weak self] webView, _ in
                    guard let self, let url = webView.url else { return }
                    self.lastLoadedURL = url
                    DispatchQueue.main.async {
                        self.state.currentURL = url
                    }
                }
            ]
        }
        
        deinit {
            observers.forEach { $0.invalidate() }
        }
    }
}
