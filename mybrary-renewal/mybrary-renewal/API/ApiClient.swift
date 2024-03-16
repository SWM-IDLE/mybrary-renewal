//
//  ApiClient.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire

// API 호출 부분
final class ApiClient {
    static let shared = ApiClient()
    
    static let BASE_URL = "https://mybrary.kr"
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor() // application/json 요청
    ])
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    var session: Session
    
    init() {
        print("ApiClient - init() called")
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
