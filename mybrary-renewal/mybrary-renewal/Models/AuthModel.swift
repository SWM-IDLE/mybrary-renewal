//
//  AuthModel.swift
//  mybrary-renewal
//
//  Created by dongs on 3/23/24.
//

import Foundation

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
