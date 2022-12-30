//
//  Cardify.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    var animal = String()
    
    @State private var animationAmount: CGFloat = 1

    init(isFaceUp: Bool, animal: String) {
        rotation = isFaceUp ? 0 : 180
        self.animal = animal
    }
   var isPastFirstSentence = false 
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                Image(animal)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true))
                   // .clipShape(shape)
                   // .frame(width: 30, height: 30)
                    //.scaleEffect(0.5)
                    
            }
            
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.62
    }
}

extension View {
    func cardify(isFaceUp: Bool, animal: String) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, animal: animal))
    }
}
