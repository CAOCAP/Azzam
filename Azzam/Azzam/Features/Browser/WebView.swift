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
    let url: URL
    @Binding var isLoading: Bool
    @Binding var progress: Double
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var title: String
    @Binding var command: WebCommand
    
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
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        #if canImport(UIKit)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        #endif
        
        context.coordinator.setupObservers(for: webView)
        return webView
    }
    
    private func updateWebView(_ webView: WKWebView, context: Context) {
        if webView.url == nil {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        if command != .none {
            switch command {
            case .goBack: webView.goBack()
            case .goForward: webView.goForward()
            case .reload: webView.reload()
            case .none: break
            }
            
            DispatchQueue.main.async {
                command = .none
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var observers: [NSKeyValueObservation] = []
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func setupObservers(for webView: WKWebView) {
            observers = [
                webView.observe(\.estimatedProgress, options: .new) { webView, change in
                    DispatchQueue.main.async { self.parent.progress = change.newValue ?? 0 }
                },
                webView.observe(\.isLoading, options: .new) { webView, change in
                    DispatchQueue.main.async { self.parent.isLoading = change.newValue ?? false }
                },
                webView.observe(\.canGoBack, options: .new) { webView, change in
                    DispatchQueue.main.async { self.parent.canGoBack = change.newValue ?? false }
                },
                webView.observe(\.canGoForward, options: .new) { webView, change in
                    DispatchQueue.main.async { self.parent.canGoForward = change.newValue ?? false }
                },
                webView.observe(\.title, options: .new) { webView, change in
                    let newTitle = webView.title ?? ""
                    DispatchQueue.main.async { self.parent.title = newTitle }
                }
            ]
        }
        
        deinit {
            observers.forEach { $0.invalidate() }
        }
    }
}
