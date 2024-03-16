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
    
}
