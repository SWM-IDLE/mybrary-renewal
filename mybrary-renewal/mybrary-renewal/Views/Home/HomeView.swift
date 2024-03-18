//
//  HomeView.swift
//  mybrary-renewal
//
//  Created by dongs on 3/17/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            Text("홈 화면 입니다.")
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    HomeView()
}
