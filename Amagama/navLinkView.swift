//
//  navLinkView.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI

struct NavLinkView: View {
    @ObservedObject var game: EmojiMemoryGame
  //  @Binding var sentencesDone: Int
    var geoReader: GeometryProxy
    @Binding var themeScore: Int
    var imageName: String
    var hasScoredTen = true
    var sentence: String
    var body: some View {
        NavigationLink {
            EmojiMemoryGameView(game: game, score: $themeScore)
        } label: {
            ZStack(alignment: .leading) {
                    HStack(spacing: 5) {
                            ChooserViewCard(imageName: imageName)
                                .scaleEffect(1.5)
                                .padding()
                              //  .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
                            Text(sentence)
                                .font(.custom("SF Pro", size: 24, relativeTo: .headline))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        Spacer()
                            Image(systemName: "\(themeScore).circle.fill")
                                .padding(.trailing, 5)
                                .font(.title)
                                .foregroundColor(themeScore < 10 ? Color.black.opacity(0.2) : Color("darkGreen"))
                                //.symbolRenderingMode(.multicolor)
                                
                    }
                    .frame(maxWidth: geoReader.size.width * 0.95, alignment: .leading)
                    .foregroundColor(.black)
                    .background( RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white.opacity(0.5)))
                }
        }
    }
}

//struct navLinkHView_Previews: PreviewProvider {
//    static var previews: some View {
//        navLinkHView()
//    }
//}

