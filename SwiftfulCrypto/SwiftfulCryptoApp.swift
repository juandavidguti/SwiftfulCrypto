//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 10/08/25.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    // change colors of navigation titles
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]

    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Fondo maestro de TODA la app
                Color.theme.background   // o .black mientras pruebas
                    .ignoresSafeArea()

                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                }
                .environmentObject(vm)
                if showLaunchView {
                    LaunchView(showLaunchView: $showLaunchView)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }
            }
        }
    }
}
