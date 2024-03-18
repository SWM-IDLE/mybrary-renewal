//
//  mybrary_renewalApp.swift
//  mybrary-renewal
//
//  Created by dongs on 3/16/24.
//

import SwiftUI

@main
struct mybrary_renewalApp: App {
    
    @StateObject var oauthManager = OAuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(OAuthVM())
                .onAppear {
                    oauthManager.checkTokenExpiration()
                }
        }
    }
}
