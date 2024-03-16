//
//  OAuthButton.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import SwiftUI

struct OAuthButton: View {
    
    var authAction: () -> Void
    var authText: String
    var authTextColor: Color
    var authBackColor: Color
    
    var body: some View {
        Button(action: authAction, label: {
            HStack{
                Spacer()
                Text(authText)
                    .foregroundStyle(authTextColor)
                Spacer()
            }
        })
        .padding(.vertical, 20)
        .background(authBackColor)
        .cornerRadius(4)
        .padding(.horizontal, 16)
    }
}

#Preview {
    OAuthButton(authAction: {
        print("로그인")
    }, authText: "Apple로 로그인", authTextColor: .white, authBackColor: .black)
}
