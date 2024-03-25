//
//  BaseInterceptor.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [Request] = []
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
           let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"){
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization-Refresh")
        }
        
        // 헤더 삽입
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (Bool) -> Void) {
        lock.lock(); defer { lock.unlock() }
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(false)
            return
        }
        
        if !isRefreshing {
            isRefreshing = true
            
            // TODO: Refresh token
            let accessToken = UserDefaults.standard.string(forKey: "accessToken")
            if let accessToken = accessToken{
                OAuthManager.shared.fetchRefreshToken(accessToken)
            }
            isRefreshing = false
            
            requestsToRetry.forEach { $0.resume() }
            requestsToRetry.removeAll()
        }
        
        requestsToRetry.append(request)
        completion(true)
    }
}
