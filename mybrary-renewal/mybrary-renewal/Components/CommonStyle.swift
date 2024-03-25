//
//  CommonStyle.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import SwiftUI

struct CommonStyle {
    // Common Color
    static var MAIN_COLOR = Color(hex: "19C568")
    static var BLACK_COLOR = Color(hex: "000000")
    static var WHITE_COLOR = Color(hex: "FFFFFF")
    
    // Auth Color
    static var NAVER_COLOR = Color(hex: "0AC75A")
    static var KAKAO_COLOR = Color(hex: "FEE500")
    
    // Home Color
    static var BANNER_BG_COLOR = Color(hex: "15BF81")
}

// #이 있으면 제거 후 문자열로 RGB 추출
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
      }
}

