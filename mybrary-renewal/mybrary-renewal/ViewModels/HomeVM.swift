//
//  HomeVM.swift
//  mybrary-renewal
//
//  Created by dongs on 3/25/24.
//

import Foundation
import Alamofire
import Combine

class HomeVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var recommendationBooksResponse: RecommendationBooksResponse? = nil
    
    var fetchingRecommendationBooks = PassthroughSubject<(), Never>()
    
    func fetchRecommendationBooks(page: Int? = 1, type: String, categoryId: Int? = 0){
        print("HomeVM: fetchRecommendationBooks() called")
        HomeApiService.fetchRecommendationBooks(page: page!, type: type, categoryId: categoryId!)
            .sink { (completion: Subscribers.Completion<AFError>) in
                switch completion {
                case .finished:
                    print("fetchRecommendationBooks request finished")
                case .failure(let error):
                    print("fetchRecommendationBooks errorCode: \(String(describing: error.responseCode))")
                    
                    // TODO: fetchRecommendationBooks 관련 에러 처리
                    //                    if let errorCode = error.responseCode {
                    //                        if errorCode == 401{
                    //                        }
                    //                    }
                }
            } receiveValue: { [weak self] receivedData in
                print("fetchRecommendationBooks Data: \(receivedData)")
                self?.recommendationBooksResponse = receivedData.data
            }.store(in: &subscription)
    }
}

