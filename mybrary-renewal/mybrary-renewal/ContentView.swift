//
//  ContentView.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var oauthManager = OAuthManager.shared
    
    var body: some View {
        if oauthManager.isLoggedIn {
            HomeView()
        } else {
            AuthView()
        }
    }
}

#Preview {
    ContentView()
}
