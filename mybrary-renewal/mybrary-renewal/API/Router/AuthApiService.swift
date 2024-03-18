//
//  AuthApiService.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import SwiftUI
import WebKit

struct AuthApiService: UIViewControllerRepresentable {
    let url: URL
    let onRedirect: ((URL) -> Void)?
    
    func makeUIViewController(context: Context) -> AuthApiServiceController {
        let controller = AuthApiServiceController()
        controller.url = url
        controller.onRedirect = onRedirect
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AuthApiServiceController, context: Context) {
        // Update the view controller if needed
    }
}

class AuthApiServiceController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: URL!
    var onRedirect: ((URL) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (Linux; Android 8.0; Pixel 2 Build/OPD3.170816.012) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Mobile Safari/537.36"
        
        view = webView
        
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, navigationAction.navigationType == .other {
            if let accessToken = getParameterValue(from: url, key: "Authorization"),
               let refreshToken = getParameterValue(from: url, key: "Authorization-Refresh") {
                
                print("Access Token: \(accessToken)")
                print("Refresh Token: \(refreshToken)")
                onRedirect?(url)
            }
        }
        decisionHandler(.allow)
    }
    
    private func getParameterValue(from url: URL, key: String) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == key })?.value
    }
}
