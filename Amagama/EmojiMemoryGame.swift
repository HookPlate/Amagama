//
//  EmojiMemoryGame.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

//This is your ViewModel

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
//    init(sentenceNum: Int) {
//        self.sentenceNum = sentenceNum
//    }
    
    
    init(theme: Theme) {
        self.currentTheme = theme
        model = EmojiMemoryGame.createMemoryGame(theme)
        
        //print(EmojiMemoryGame.currentTheme)
    }
    @EnvironmentObject var store: ThemeStore
   // @Binding var theme: Theme
    
    typealias Card = MemoryGame<String>.Card

    static func createMemoryGame(_ theme: Theme) -> MemoryGame<String> {
        //Our Model is a struct so a fresh one is made here, <String> sets the generic which is in turn used in the init.
        //for the below look at the init on the Model. pairIndex catches the int passed back into the function, then passes back some content for it, in this case a String.
        
        return MemoryGame<String>(numberOfPairsOfCards: theme.emojis.count ) { pairIndex in
            theme.emojis[pairIndex]}
    }
    //any changes to this are published
    @Published private var model: MemoryGame<String>
    
//    static private var myThemes: [Theme] = [
//            Theme(title:  "I like to see people", emojis:  ["I", "like", "to", "see", "people"]),
//            Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"]),
//            Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"])
//        ]
    
    var currentTheme: Theme
    //= myThemes.randomElement() ?? Theme(title: "Test", emojis: ["Hello"])
   
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var mainTitle: [String] {
        return model.mainTitle
    }
    
    var matchedCards: [String] {
        return model.matchedCards
    }
    
    var matchedCardCount: Int {
        return model.matchCardCount
    }
    
    
    var wordJustMatched: Bool {
        return model.wordJustMatched
    }
    
    
    // MARK: - Intent(s)
    //all these functions in the model must be labelled @mutating
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle () {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame(currentTheme)
        }
    
    func gameCompleted() {
        model.gameCompleted()
    }
    
    func flip(_ card: Card) {
        model.flipCards(card)
        
    }
}

