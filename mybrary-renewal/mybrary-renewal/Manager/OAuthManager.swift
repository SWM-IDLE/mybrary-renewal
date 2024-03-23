//
//  OAuthManager.swift
//  mybrary-renewal
//
//  Created by dongs on 3/18/24.
//

import Foundation
import Alamofire
import Combine
import JWTDecode

class OAuthManager: ObservableObject {
    
    static let shared = OAuthManager()
    
    @Published var isLoggedIn = false
    
    func checkTokenExpiration() {
        // Load access token and refresh token from storage
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        
       
        
        // Check if access token and refresh token exist and access token is not expired
        if let accessToken = accessToken,
           let refreshToken = refreshToken,
           !isTokenExpired(accessToken) {
            
            do {
                let accessJwt = try decode(jwt: accessToken)
                let refreshJwt = try decode(jwt: refreshToken)
                    
                print("OAuthManager - accessToken: \(accessJwt.body)")
                print("OAuthManager - refreshToken: \(refreshJwt.body)")
                
            } catch {
                print("JWT Token Expired Error - \(error)")
            }
            
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        
        print("login - \(isLoggedIn)")
    }
    
    func isTokenExpired(_ token: String) -> Bool {
        
        do {
            let jwt = try decode(jwt: token)
            
            if let expiresAt = jwt.expiresAt {
                let currentTime = Date()
                if currentTime > expiresAt {
                    refreshToken(token)
                    return true
                }
            }
        } catch {
            print("JWT Token Expired Error - \(error)")
        }
        
        return false
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func refreshToken(_ accessToken: String) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("Refresh token not found")
            return
        }

        let parameters: [String: Any] = ["Authorization": accessToken,"Authorization-Refresh": refreshToken]
        let url = "\(ApiClient.BASE_URL)/auth/v1/refresh"

        AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .publishDecodable(type: TokenResponse.self)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to refresh token: \(error)")
                }
            }, receiveValue: { tokenResponse in
                print("재발급 토큰 - \(tokenResponse)")
                UserDefaults.standard.set(tokenResponse.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(tokenResponse.refreshToken, forKey: "refreshToken")
            })
            .store(in: &cancellables)
    }
}
