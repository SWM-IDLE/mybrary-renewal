//
//  CommonModel.swift
//  mybrary-renewal
//
//  Created by dongs on 3/25/24.
//

import Foundation

struct CommonModel<T: Codable>: Codable {
    let status: String
    let message: String
    let data: T
}
