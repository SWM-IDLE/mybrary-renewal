//
//  OAuthManager.swift
//  mybrary-renewal
//
//  Created by dongs on 3/18/24.
//

import Foundation

class OAuthManager: ObservableObject {
    
    static let shared = OAuthManager()
    
    @Published var isLoggedIn = false
    
    func checkTokenExpiration() {
        // Load access token and refresh token from storage
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        
        print("OAuthManager - accessToken: \(String(describing: accessToken))")
        print("OAuthManager - accessToken: \(String(describing: refreshToken))")
        
        // Check if access token and refresh token exist and access token is not expired
        if let accessToken = accessToken,
            let refreshToken = refreshToken, !isTokenExpired(accessToken) {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        
        print("login - \(isLoggedIn)")
    }
    
    func isTokenExpired(_ token: String) -> Bool {
        // Check if token is expired
        // You need to implement logic to check token expiration based on your token format and server logic
        // For example, you can compare the expiration date/time with the current date/time
        return false // Placeholder, replace with actual logic
    }
}
