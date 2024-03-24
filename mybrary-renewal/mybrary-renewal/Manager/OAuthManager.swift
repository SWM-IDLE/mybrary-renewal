//
//  OAuthManager.swift
//  mybrary-renewal
//
//  Created by dongs on 3/18/24.
//

import SwiftUI
import Alamofire
import Combine
import JWTDecode

class OAuthManager: ObservableObject {
    
    static let shared = OAuthManager()
    
    @Published var isLoggedIn = false
    
    func checkTokenExpiration() {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        
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
            if let accessToken = accessToken {
                fetchRefreshToken(accessToken)
            }
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
                    fetchRefreshToken(token)
                    return true
                }
            }
        } catch {
            print("OAuthManager - JWT Token Expired Error: \(error)")
        }
        
        return false
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchRefreshToken(_ accessToken: String) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("OAuthManager - Refresh token not found")
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)","Authorization-Refresh": "Bearer \(refreshToken)"]
        let url = "\(ApiClient.BASE_URL)/user-service/auth/v1/refresh"
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .response{response in
                switch response.result {
                case .success:
                    print("Token Refresh Success")
                    if let url = response.response?.url{
                        
                        if let accessToken = self.getParameterValue(from: url, key: "Authorization"),
                           let refreshToken = self.getParameterValue(from: url, key: "Authorization-Refresh"){
                            
                            UserDefaults.standard.set(accessToken, forKey: "accessToken")
                            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                            self.isLoggedIn = true
                        }
                    }
                case .failure(let error):
                    print("Token Refresh failure: \(error)")
                    print("errorCode \(String(describing: error.responseCode))" )
                    print("errorCode", error.localizedDescription)
                }
            }
    }
    
    func resetUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    func getParameterValue(from url: URL, key: String) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == key })?.value
    }
}
