//
//  AmagamaApp.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
// this is the RevenueCat branch

import SwiftUI
import RevenueCat



@main
struct AmagamaApp: App {
    //Initialise RevenueCat
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_fxkizrkkedMKxSnKQMxhhbogmVk")
    }
    
        @StateObject var themeStore = ThemeStore()
         
         var body: some Scene {
             WindowGroup {
                 GameChooserView()
                     .environmentObject(themeStore)
             }
         }
}
