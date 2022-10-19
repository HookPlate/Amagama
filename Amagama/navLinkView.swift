//
//  navLinkView.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI

struct NavLinkView: View {
    @EnvironmentObject var store: ThemeStore
    @ObservedObject var game: EmojiMemoryGame
  //  @ObservedObject var themeStore: ThemeStore
  //  @Binding var sentencesDone: Int
    var geoReader: GeometryProxy
    @Binding var themeScore: Int
    var imageName: String
    var hasScoredTen = true
    var sentence: String
    @State var viewOpacity: Double
    var productId: String?
    var body: some View {
        NavigationLink {
            EmojiMemoryGameView(game: game, score: $themeScore)
        } label: {
            ZStack(alignment: .leading) {
                    HStack(spacing: 5) {
                            ChooserViewCard(imageName: imageName)
                                .scaleEffect(1.5)
                                .padding()
            
                            Text(sentence)
                                .font(.custom("SF Pro", size: 24, relativeTo: .headline))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                              //  .blur(radius: store.userPurchases["19BuyableSentences"] == nil ? 5 : 0)
                             
                        Spacer()
                            Image(systemName: "\(themeScore).circle.fill")
                                .padding(.trailing, 5)
                                .font(.title)
                                .foregroundColor(themeScore < 10 ? Color.black.opacity(0.2) : Color("darkGreen"))
                              
                                
                        if viewOpacity == 0.5 && store.userPurchases["19BuyableSentences"] == nil  {
                            Image(systemName: "lock")
                            .font(.headline)
                            .padding(.trailing)
                        }
                    }
                    .frame(maxWidth: geoReader.size.width * 0.95, alignment: .leading)
                    .foregroundColor(.black)
                    .background( RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white.opacity(0.5)))
                }
            .opacity(store.userPurchases["19BuyableSentences"] == true ? 1 : viewOpacity)
            .blur(radius: store.userPurchases["19BuyableSentences"] == nil && productId != "FreeSentence" ? 5 : 0)
        }
        //simply disables the view, doesn't affect its appearance.
        .disabled(store.userPurchases[productId ?? "nothing"] == nil)
    }
}

//struct navLinkHView_Previews: PreviewProvider {
//    static var previews: some View {
//        navLinkHView()
//    }
//}

