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
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
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
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock(); defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            // 토큰이 만료되었을 때만 재시도를 시도합니다.
            guard !isRefreshing else {
                // 현재 토큰을 refresh하고 있으면 대기열에 요청을 추가합니다.
                requestsToRetry.append(completion)
                return
            }
            
            isRefreshing = true
            
            // 여기에서 AccessToken을 재발급하고, 성공하면 재시도 대기열의 요청들을 재시도합니다.
            refreshAccessToken { [weak self] success in
                guard let self = self else { return }
                
                self.lock.lock(); defer { self.lock.unlock() }
                
                if success {
                    self.requestsToRetry.forEach { $0(.retry) }
                    self.requestsToRetry.removeAll()
                } else {
                    self.requestsToRetry.forEach { $0(.doNotRetry) }
                    self.requestsToRetry.removeAll()
                }
                
                self.isRefreshing = false
            }
        } else {
            completion(.doNotRetry) // 다른 이유로 인한 실패인 경우 재시도하지 않습니다.
        }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        
        let url = "\(ApiClient.BASE_URL)/auth/v1/refresh"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)","Authorization-Refresh": "Bearer \(refreshToken)"]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .response{response in
                switch response.result {
                case .success:
                    print("BaseInterceptor - Token Refresh Success")
                    if let url = response.response?.url{
                        
                        if let accessToken = self.getParameterValue(from: url, key: "Authorization"),
                           let refreshToken = self.getParameterValue(from: url, key: "Authorization-Refresh"){
                            
                            UserDefaults.standard.set(accessToken, forKey: "accessToken")
                            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                            OAuthManager.shared.isLoggedIn = true
                        }
                    }
                case .failure(let error):
                    print("BaseInterceptor - Token Refresh failure: \(error)")
                    print("errorCode \(String(describing: error.responseCode))" )
                    
                    if let data = response.data {
                        let responseBody = String(data: data, encoding: .utf8)
                        print("BaseInterceptor - Token Refresh fail Body: \(responseBody ?? "No data")")
                    }
                    
                    OAuthManager.shared.isLoggedIn = false
                }
            }
    }
    
    private func getParameterValue(from url: URL, key: String) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == key })?.value
    }
}
