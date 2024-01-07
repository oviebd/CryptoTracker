//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 5/1/24.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject var homeVm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }.environmentObject(homeVm)
            
        }
    }
}
