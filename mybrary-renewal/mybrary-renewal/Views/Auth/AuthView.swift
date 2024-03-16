//
//  AuthView.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        ZStack{
            Image("auth-background")
                .resizable()
            
            VStack(alignment: .leading){
                
                Spacer().frame(height: 20)
                
                VStack(alignment: .leading, spacing: 8){
                    Text("도서의 가치를 발견할")
                    Text("당신만의 도서관")
                    Text("마이브러리")
                }
                .padding(.horizontal, 16)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundStyle(CommonStyle.WHITE_COLOR)
                
                Spacer()
                
                OAuthButton(authAction: {
                    print("로그인")
                }, authText: "Apple로 로그인", authTextColor: .white, authBackColor: CommonStyle.BLACK_COLOR)
                
                OAuthButton(authAction: {
                    print("로그인")
                }, authText: "Google로 로그인", authTextColor: .black, authBackColor: CommonStyle.WHITE_COLOR)
                
                OAuthButton(authAction: {
                    print("로그인")
                }, authText: "네이버로 로그인", authTextColor: .white, authBackColor: CommonStyle.NAVER_COLOR)
                
                OAuthButton(authAction: {
                    print("로그인")
                }, authText: "카카오로 로그인", authTextColor: .black, authBackColor: CommonStyle.KAKAO_COLOR)
            }
            .padding(.vertical, 80)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    AuthView()
}
