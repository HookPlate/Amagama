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
    
    
    //    private let game = EmojiMemoryGame(theme: Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"]))
        //private let themes = ThemeStore()
        @StateObject var themeStore = ThemeStore()
         
         var body: some Scene {
             WindowGroup {
                // EmojiMemoryGameView(game: game)
                 GameChooserView()
                     .environmentObject(themeStore)
             }
         }
}
