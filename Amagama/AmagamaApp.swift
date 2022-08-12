//
//  AmagamaApp.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI



@main
struct AmagamaApp: App {
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
