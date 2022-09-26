//
//  CardView.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI

struct CardView: View {
    
    let card: EmojiMemoryGame.Card

    let shuffledAnimals: Animals
//    @State private var animationAmount: CGFloat = 1
   // @Binding var isPastFirstSentnce: Bool
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                //Color.green
                Text(card.content)
//                    .scaleEffect(animationAmount)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.interpolatingSpring(stiffness: 10, damping: 4, initialVelocity: 8))
                    .font(.custom("MarkerFelt", size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                    
            }
            .cardify(isFaceUp: card.isFaceUp, animal: shuffledAnimals.animalImageNames[card.backOfCardIndex] )
         //   .cardify(isFaceUp: card.isFaceUp, animal: animalForCard)
            .foregroundColor(card.isMatched ? Color.green : Color.red)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        return min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}


