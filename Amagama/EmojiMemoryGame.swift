//
//  EmojiMemoryGame.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

//This is your ViewModel

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    
    init(theme: Theme) {
        self.currentTheme = theme
        model = EmojiMemoryGame.createMemoryGame(theme)
    }
    @EnvironmentObject var store: ThemeStore
    
    typealias Card = MemoryGame<String>.Card

    static func createMemoryGame(_ theme: Theme) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: theme.emojis.count ) { pairIndex in
            theme.emojis[pairIndex]}
    }
    //any changes to this are published
    @Published private var model: MemoryGame<String>
    
    
    var currentTheme: Theme
   
    
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
    
    var viewScore: Int {
        return model.matchCardCount - 5
    }
    
    
    var wordJustMatched: Bool {
        return model.wordJustMatched
    }
    
    var alreadyMatchedWordJustTapped: Bool {
        return model.alreadyMatchedWordJustMatched
    }
    
    
    // MARK: - Intent(s)
    //all these functions in the model must be labelled @mutating
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle () {
        withAnimation(Animation.easeInOut.delay(3)) {
            model.shuffle()
        }
    }
    
    func restart() {
            model = EmojiMemoryGame.createMemoryGame(currentTheme)
    }
    
    func gameCompleted() {
        withAnimation(Animation.easeInOut.delay(3)) {
                    self.model.gameCompleted()
                }
    }
    
    func flip(_ card: Card) {
        model.flipCards(card)
        
    }
}

