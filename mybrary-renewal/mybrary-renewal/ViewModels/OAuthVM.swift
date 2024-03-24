//
//  OAuthVM.swift
//  mybrary-renewal
//
//  Created by dongs on 3/17/24.
//

import SwiftUI
import WebKit

class OAuthVM: ObservableObject {
    @Published var isWebViewPresented = false
    @Published var accessToken: String?
    @Published var refreshToken: String?
    
    @Published var isLoggedIn = false
    
    func openWebView() {
        isWebViewPresented = true
    }
    
    func handleRedirectedURL(_ url: URL) {
        if let accessToken = getParameterValue(from: url, key: "Authorization"),
           let refreshToken = getParameterValue(from: url, key: "Authorization-Refresh"){
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            
            isWebViewPresented = false
        }
    }
    
    func getParameterValue(from url: URL, key: String) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == key })?.value
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(accessToken, forKey: "accessToken")
        userDefaults.set(refreshToken, forKey: "refreshToken")
        print("userDefaults - \(userDefaults)")
        self.isLoggedIn = true
        self.isWebViewPresented = false
    }
}
