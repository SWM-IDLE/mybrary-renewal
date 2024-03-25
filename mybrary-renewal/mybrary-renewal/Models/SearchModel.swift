//
//  SearchModel.swift
//  mybrary-renewal
//
//  Created by dongs on 3/25/24.
//

import Foundation

struct RecommendationBooksResponse: Codable {
    let books: [RecommendationBookModel]
}

struct RecommendationBookModel: Codable, Hashable {
    let thumbnailUrl: String
    let isbn13: String
    let title: String
    let authors: String
    let aladinStarRating: Double
}
