//
//  TopTargetSentence.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI

struct TopTargetSentence: View {
    
    var wordscaleAmount = 1.4
    var showTitle : Bool
    var geo : GeometryProxy
    var game: EmojiMemoryGame
    
    var body: some View {
        if showTitle {
            ZStack {
                Rectangle()
                    .cornerRadius(20)
                    .foregroundColor(Color.yellow)
                    .frame(height: geo.size.height / 10)
                    .shadow(color: Color.gray.opacity(0.5), radius: 2, x: CGFloat(3),y: CGFloat(4))
                HStack(spacing: 5) {
                    ForEach(game.mainTitle, id: \.self) { word in
                        Text(word)
                            .font(.title)
                            .fontWeight(.semibold)
                            .scaledToFit()
                            
                            .scaleEffect(game.matchedCards.last == word ? wordscaleAmount : 1)
                           // .scaleEffect(sentenceComplete ? wordscaleAmount : 0.7)
                            .animation(.spring(response: 1, dampingFraction: 0.3), value: game.wordJustMatched)
                            .foregroundColor(game.matchedCards.contains(word) ? Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)) : Color.black)
                            .minimumScaleFactor(0.5)
                    }
                }
                .padding(3)
            }
        }
    }
}

//struct TopTargetSentence_Previews: PreviewProvider {
//
//    static var previews: some View {
//        TopTargetSentence(sentenceComplete: false, wordscaleAmount: 1, showTitle: true, geo: geo, game: EmojiMemoryGame())
//    }
//}

