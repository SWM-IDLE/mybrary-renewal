//
//  HomeRouter.swift
//  mybrary-renewal
//
//  Created by dongs on 3/25/24.
//

import Foundation
import Alamofire

enum HomeRouter: URLRequestConvertible {
    
    case fetchRecommendationBooks(page: Int?, type: String, categoryId: Int?)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .fetchRecommendationBooks: return "/book-service/api/v1/books/recommendations"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchRecommendationBooks: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .fetchRecommendationBooks(page, type, categoryId):
            var params = Parameters()
            
            params["type"] = type
            params["page"] = page
            params["categoryId"] = categoryId
            
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.method = method
        
        if method == .post {
            request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        }
        
        return request
    }
}

