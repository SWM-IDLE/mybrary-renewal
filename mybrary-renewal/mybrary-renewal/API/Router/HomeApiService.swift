//
//  HomeApiService.swift
//  mybrary-renewal
//
//  Created by dongs on 3/25/24.
//

import Foundation
import Alamofire
import Combine

// 인증 관련 api 호출
enum HomeApiService {
    
    static func fetchRecommendationBooks(page: Int, type: String, categoryId: Int) -> AnyPublisher<CommonModel<RecommendationBooksResponse>, AFError> {
        print("HomeApiService - fetchRecommendationBooks() called")
        
        return ApiClient.shared.session
            .request(HomeRouter.fetchRecommendationBooks(page: page, type: type, categoryId: categoryId))
            .validate(statusCode: 200..<300)
            .response(completionHandler: { response in
                switch response.result {
                case .success:
                    print("fetchRecommendationBooks request finished")
                case .failure(let error):
                    print("fetchRecommendationBooks errorCode: \(String(describing: error.responseCode))")
                    
                    if let data = response.data {
                        let responseBody = String(data: data, encoding: .utf8)
                        print("fetchRecommendationBooks responseBody: \(responseBody ?? "No data")")
                    }
                }
            })
            .publishDecodable(type: CommonModel<RecommendationBooksResponse>.self)
            .value()
            .eraseToAnyPublisher()
    }
}

