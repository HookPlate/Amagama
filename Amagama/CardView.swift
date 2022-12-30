//
//  CardView.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI

struct CardView: View {
    
    @EnvironmentObject var store: ThemeStore
    
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .font(.custom("MarkerFelt", size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                   // .dynamicTypeSize(...DynamicTypeSize.large)
                
                    
            }
            .cardify(isFaceUp: card.isFaceUp, animal: store.animals[card.backOfCardIndex])
            .foregroundColor(card.isMatched ? Color.green : Color.red)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        return min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
}



