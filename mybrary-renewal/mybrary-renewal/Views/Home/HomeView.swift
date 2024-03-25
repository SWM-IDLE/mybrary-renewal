//
//  HomeView.swift
//  mybrary-renewal
//
//  Created by dongs on 3/17/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeVM()
    
    @State private var imgIndex = 0
    
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0){
            homeHeader
            
            ScrollView {
                if homeVM.recommendationBooksResponse == nil {
                    VStack{
                        Spacer().frame(height: 50)
                        ProgressView()
                            .controlSize(.large)
                            .progressViewStyle(CircularProgressViewStyle(tint: CommonStyle.MAIN_COLOR))
                    }
                } else {
                    if let recommendationBooks = homeVM.recommendationBooksResponse?.books{
                        VStack{
                            VStack(alignment: .leading){
                                HStack{
                                    Text("이주의")
                                        .font(.system(size: 24))
                                    Text("베스트 셀러 📚")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                }.padding(.horizontal, 24)
                                
                                Spacer().frame(height: 16)
                                
                                TabView(selection: $imgIndex) {
                                    ForEach(recommendationBooks.indices, id: \.self) { index in
                                        VStack{
                                            HStack{
                                                VStack(alignment: .leading, spacing: 8){
                                                    Text(recommendationBooks[index].title)
                                                        .lineLimit(2)
                                                        .font(.system(size: 18))
                                                        .fontWeight(.bold)
                                                    Text(recommendationBooks[index].authors)
                                                        .font(.system(size: 16))
                                                    Text("⭐️ \(String(format: "%.1f", recommendationBooks[index].aladinStarRating))")
                                                        .font(.system(size: 14))
                                                }
                                                .frame(width: UIScreen.main.bounds.width - 180)
                                                Spacer()
                                                AsyncImage(url: URL(string: recommendationBooks[index].thumbnailUrl)) { image in
                                                    image.resizable()
                                                        .scaledToFill()
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .frame(width: 105, height: 150)
                                                .cornerRadius(10)
                                                .shadow(radius: 4)
                                            }
                                        }
                                        
                                    }
                                    .padding(.horizontal, 24)
                                    .padding(.bottom, 40)
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
                                .onReceive(timer) { _ in
                                    withAnimation {
                                        imgIndex = (imgIndex + 1) % recommendationBooks.count
                                    }
                                }
                            }
                            .foregroundStyle(CommonStyle.WHITE_COLOR)
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            .background(CommonStyle.MAIN_COLOR)
                            
                            Spacer().frame(height: 30)
                            
                            VStack(spacing: 12) {
                                Divider()
                                    .background(CommonStyle.DIVIDER_COLOR)
                                
                                HStack {
                                    Text("오늘 마이브러리에 등록된 책!")
                                    Spacer()
                                    Text("17 권")
                                }.font(.system(size: 12))
                                
                                Divider()
                                    .background(CommonStyle.DIVIDER_COLOR)
                            }.padding(.horizontal, 24)
                            
                            Spacer().frame(height: 30)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear{
            homeVM.fetchRecommendationBooks(type: "Bestseller")
        }
    }
    
    private var homeHeader: some View {
        HStack{
            Text("My")
            
            Spacer()
            
            Button(action: {
            }, label: {
                Image(systemName: "barcode.viewfinder")
            })
        }
        .font(.system(size: 24))
        .fontWeight(.bold)
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .foregroundStyle(CommonStyle.WHITE_COLOR)
        .background(CommonStyle.MAIN_COLOR)
    }
}

#Preview {
    HomeView()
}
