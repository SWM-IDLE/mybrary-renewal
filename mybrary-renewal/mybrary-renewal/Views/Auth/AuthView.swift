//
//  AuthView.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import SwiftUI

struct AuthView: View {
    
    @EnvironmentObject var oauthVM: OAuthVM
    
    @State private var accessToken: String?
    @State private var refreshToken: String?
    
    @State var showGoogleWK = false
    @State var showNaverWK = false
    @State var showKakaoWK = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("auth-background")
                    .resizable()
                
                VStack(alignment: .leading){
                    
                    Spacer().frame(height: 16)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("도서의 가치를 발견할")
                        Text("당신만의 도서관")
                        Text("마이브러리")
                    }
                    .padding(.horizontal, 20)
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundStyle(CommonStyle.WHITE_COLOR)
                    
                    Spacer()
                    
                    VStack(spacing: 10){
                        
                        OAuthButton(authAction: {
                            print("로그인")
                        }, authText: "Apple로 로그인", authTextColor: .white, authBackColor: CommonStyle.BLACK_COLOR)
                        
                        OAuthButton(authAction: {
                            showGoogleWK.toggle()
                        }, authText: "Google로 로그인", authTextColor: .black, authBackColor: CommonStyle.WHITE_COLOR).sheet(isPresented: $showGoogleWK, content: {
                            
                            AuthApiService(url: URL(string: "\(ApiClient.BASE_URL)/user-service/oauth2/authorization/google")!, onRedirect: { googleRedirectedURL in
                                if let accessToken = oauthVM.getParameterValue(from: googleRedirectedURL, key: "Authorization"),
                                   let refreshToken = oauthVM.getParameterValue(from: googleRedirectedURL, key: "Authorization-Refresh"){
                                    self.accessToken = accessToken
                                    self.refreshToken = refreshToken
                                    
                                    oauthVM.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                                    
                                    showGoogleWK = false
                                }
                            })
                        })
                        
                        
                        OAuthButton(authAction: {
                            showNaverWK.toggle()
                        }, authText: "네이버로 로그인", authTextColor: .white, authBackColor: CommonStyle.NAVER_COLOR).sheet(isPresented: $showNaverWK, content: {
                            
                            AuthApiService(url: URL(string: "\(ApiClient.BASE_URL)/user-service/oauth2/authorization/naver")!, onRedirect: { naverRedirectedURL in
                                if let accessToken = oauthVM.getParameterValue(from: naverRedirectedURL, key: "Authorization"),
                                   let refreshToken = oauthVM.getParameterValue(from: naverRedirectedURL, key: "Authorization-Refresh"){
                                    self.accessToken = accessToken
                                    self.refreshToken = refreshToken
                                    
                                    oauthVM.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                                    
                                    showNaverWK = false
                                }
                            })
                        })
                        
                        OAuthButton(authAction: {
                            showKakaoWK.toggle()
                        }, authText: "카카오로 로그인", authTextColor: .black, authBackColor: CommonStyle.KAKAO_COLOR).sheet(isPresented: $showKakaoWK, content: {
                            
                            AuthApiService(url: URL(string: "\(ApiClient.BASE_URL)/user-service/oauth2/authorization/kakao")!, onRedirect: { kakaoRedirectedURL in
                                if let accessToken = oauthVM.getParameterValue(from: kakaoRedirectedURL, key: "Authorization"),
                                   let refreshToken = oauthVM.getParameterValue(from: kakaoRedirectedURL, key: "Authorization-Refresh"){
                                    self.accessToken = accessToken
                                    self.refreshToken = refreshToken
                                    
                                    oauthVM.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                                    
                                    showKakaoWK = false
                                }
                            })
                        })
                    }
                }
                .padding(.vertical, 70)
                .navigationDestination(isPresented: $oauthVM.isLoggedIn) {
                    HomeView()
                }
            }
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    AuthView()
}
