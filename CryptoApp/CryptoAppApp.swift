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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }.environmentObject(homeVm)
            
        }
    }
}
