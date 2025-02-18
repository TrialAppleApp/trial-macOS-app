//
//  UpdateLogView.swift
//  TrialMacAppGUI
//
//  Created by TrialMacApp on 12/12/24.
//

import SwiftUI
import WebKit

// 自定义窗口视图，用于显示更新日志
struct UpdateLogWindow: View {
    let htmlURL = "https://raw.githubusercontent.com/TrialAppleApp/trial-macOS-app/refs/heads/master/app.update_log"

    @State private var isLoading = true // 添加加载状态

    var body: some View {
        ZStack {
            WebView(htmlURL: htmlURL, isLoading: $isLoading) // 使用 WebView 加载远程 HTML

            // 加载指示器
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .padding()
    }
}

// WebView 包装器，用于加载 HTML 字符串
struct WebView: NSViewRepresentable {
    var htmlURL: String
    @Binding var isLoading: Bool // 绑定加载状态

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // 设置代理
        loadHTMLContent(webView) // 加载 HTML 内容
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // 不需要在这里更新视图
    }

    private func loadHTMLContent(_ webView: WKWebView) {
        guard let url = URL(string: htmlURL) else { return }
        // 下载 HTML 内容
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            if let htmlString = String(data: data, encoding: .utf8) {
                // 在主线程上加载 HTML 字符串
                DispatchQueue.main.async {
                    webView.loadHTMLString(htmlString, baseURL: url)
                }
            }
        }.resume()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool

        init(isLoading: Binding<Bool>) {
            _isLoading = isLoading
        }

        // 网页开始加载
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }

        // 网页加载完成
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }

        // 网页加载失败
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }
    }
}

// 自定义窗口控制器，用于管理更新日志窗口的显示
class UpdateLogWindowController: NSWindowController {
    init() {
        let contentView = NSHostingView(rootView: UpdateLogWindow()) // 加载 UpdateLogWindow 视图
        let window = NSWindow(
            contentViewController: NSViewController()
        )
        window.contentView = contentView
        window.title = "Update Logs"
        window.setContentSize(NSSize(width: 800, height: 600))
        super.init(window: window)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 显示窗口
    func show() {
        window?.makeKeyAndOrderFront(nil)
    }
}
