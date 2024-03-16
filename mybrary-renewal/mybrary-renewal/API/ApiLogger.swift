//
//  ApiLogger.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import Foundation
import Alamofire

final class ApiLogger: EventMonitor {
    let queue = DispatchQueue(label: "mybrary_ApiLogger")
    
    func requestDidResume(_ request: Request) {
        print("ApiLogger - Resuming: \(request)")
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        debugPrint("Finished: \(response)")
    }
}
