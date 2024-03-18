//
//  AuthRouter.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
    
    case naverLogin
    case kakaoLogin
    case googleLogin
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .naverLogin: return "/user-service/oauth2/authorization/naver"
        case .kakaoLogin: return "/user-service/oauth2/authorization/kakao"
        case .googleLogin: return "/user-service/oauth2/authorization/google"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .naverLogin: return .get
        case .kakaoLogin: return .get
        case .googleLogin: return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        request.httpBody = try JSONEncoding.default.encode(request).httpBody
        
        return request
    }
    
}
