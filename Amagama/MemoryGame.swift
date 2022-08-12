//
//  MemoryGame.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

//This is your Model

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    
    private(set) var mainTitle: [CardContent]
    
    private(set) var matchedCards: [CardContent]
    
    private(set) var matchCardCount: Int
    
    private(set) var wordJustMatched: Bool
    
   // private(set)  var score : Int
    
   // private(set) var sentenceNumber : Int
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
        set {cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}}
    }
    
    mutating func flipCards (_ card: Card) {
        if let cardIndex = cards.firstIndex(where: {$0.id == card.id}) {
            cards[cardIndex].isFaceUp = false
        }
    }
    
//    mutating func startAgain() {
//            matchedCards = []
//    }
    
    mutating func choose(_ card: Card) {
        wordJustMatched = false
        if let chosenIndex =
            cards.firstIndex(where: {$0.id == card.id}),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched {
            //the below is only made if there a value in the computed optional of indexOfTheOneAndOnlyFaceUpCard (so there's one face up card already)
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                //if it's already in there don't preceed.
                if !matchedCards.contains(cards[chosenIndex].content) {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        wordJustMatched = true
                        
                                
                        if matchedCards.count == 4 || matchedCards.count == 9 {
                            cards[chosenIndex].isFaceUp = false
                            cards[potentialMatchIndex].isFaceUp = false
                            indexOfTheOneAndOnlyFaceUpCard = nil
                        } else {
                           // cards[chosenIndex].isFaceUp = true
                        }
    
                        if mainTitle != matchedCards {
                            matchedCards.append(cards[chosenIndex].content)
                            matchCardCount += 1
                        }
                    }
                }
                
                //so if it skips the above it'll flip but with no match, I had the if statement using matchCardCount before.
                if matchedCards.count != 5 {
                      cards[chosenIndex].isFaceUp = true
                }
              
                //the below makes the above flip the first card thanks to the set block in indexOfTheOneAndOnlyFaceUpCard
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func gameCompleted() {
        matchedCards = []
    }
    
    
    
//don't forget that this is what runs whenever someone creates a MemoryGame, CardContent is the generic in the declaration.
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
            cards = []
            mainTitle = []
            matchedCards = []
            matchCardCount = 0
            wordJustMatched = false
        //    score = 10
          //  gameNumber = sentenceNumber
        for pairIndex in 0..<numberOfPairsOfCards {
            //the above pairIndex int is passed to anyone who makes a MemoryGame (below), which then passes back a string
            let content = createCardContent(pairIndex)
            var myClampedInt = 0
            var magicNumber : Int {
                get { cards.count}
                set {
                    if newValue < 4 {
                        myClampedInt = magicNumber - 1
                    }
                }
                
            }
            //it then makes four cards for each content passed back
            cards.append(Card(content: content, id: pairIndex*5, backOfCardIndex: pairIndex+magicNumber))
          //  print(pairIndex+myClampedInt)
            cards.append(Card(content: content, id: pairIndex*5+1, backOfCardIndex: pairIndex+magicNumber+1))
            cards.append(Card(content: content, id: pairIndex*5+3, backOfCardIndex: pairIndex+magicNumber+2))
            cards.append(Card(content: content, id: pairIndex*5+4, backOfCardIndex: pairIndex+magicNumber+3))
        
        }
        //cards.shuffle()
        let wordIndices = [0, 4, 8, 12, 16]
        
        for i in wordIndices {
            mainTitle.append(cards[i].content)
         
        }

        print(mainTitle)
    }
    
    struct Card: Identifiable {
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
        let id: Int
        let backOfCardIndex: Int
    }
}


extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}


