//
//  GameChooserView.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI
import MediaPlayer

struct GameChooserView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    
    @EnvironmentObject var store: ThemeStore
    
    @State var games: [UUID: EmojiMemoryGame] = [:]
    
    @State var isSoundtrackPlaying = true
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                //The background
            ZStack() {
                Color(red: 251/255, green: 219/255, blue: 101/255)
                    .ignoresSafeArea()
                //the diagonal rectangle on top of it
                Rectangle()
                    .foregroundColor(Color(red: 228/255, green: 195/255, blue: 76/255))
                    .rotationEffect(Angle(degrees: 45))
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 13) {
                    //The title
                    ZStack {
                        Color.white.opacity(0.3)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: geometry.size.width / 2.1, height: 38)
                        HStack {
                            ChooserViewCard(imageName: "owl")
                            Text("  Amagama  ")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            ChooserViewCard(imageName: "panda")
                        }
                        .frame(width: geometry.size.width / 2.2, height: 40)
                    }
                    .scaleEffect(2)
                    .padding(.top)
                    
                    //The Navigationlink Views
                    ScrollView {
                        ForEach(store.themes, id: \.self.id) { theme in
                                if let game = game(for: theme) {
                                    NavLinkView(game: game, geoReader: geometry, themeScore: $store.themes[store.themes.index(matching: theme) ?? 0].score , imageName: theme.imageName, sentence: theme.title, viewOpacity: theme.productId == "19BuyableSentences" ? 0.5 : 1, productId: theme.productId)
                                }
                            }
                    }
                    .padding(.top)
    
                    //The Global score
                    HStack {
                        Button(action: {toggleSoundTrack()}, label: {store.isSoundtrackPlaying ? Image(systemName: "speaker.wave.2").font(.title) : Image(systemName: "speaker.slash").font(.title)})
                            .padding(.leading, 55)
                            .offset(x: -20, y: 0)
            
                     Spacer()
                        Text("Score: \(String(store.sentencesComplete))")
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.all, 10)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(15)
                            .padding(.bottom, 5)
                        
                        Spacer()
                        if store.userPurchases["19BuyableSentences"] ==  nil {
                            HStack {
                                Button(action: {
                                    store.makePurchase(theme: store.themes[1])
                                } , label: {
                                    Text("Buy")
                                        .foregroundColor(.black)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding(.all, 10)
                                        .background(Color.green.opacity(0.7))
                                        .cornerRadius(15)
                                        .padding(.bottom, 5)
                                })
                                .padding(.trailing, 20)
                                
                                Button(action: {
                                    store.restorePurchase(theme: store.themes[1])
                                } , label: {
                                    Text("Restore")
                                        .foregroundColor(.black)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding(.all, 10)
                                        .background(Color.green.opacity(0.7))
                                        .cornerRadius(15)
                                        .padding(.bottom, 5)
                                })
                                .padding(.trailing, 20)
                            }
                        } else {
                            //put code for reset button here that calls a reset score function.
                            Button(action: {
                                store.resetThemeScores()
                            } , label: {
                                Image(systemName: "arrow.clockwise.circle")
                                    .font(.title)
                            })
                            .offset(x: 20, y: 0)
                            .padding(.trailing, 55)
                            
                        }
                    }
                    .animation(.default, value: store.isSoundtrackPlaying)
                }
            }
            .navigationBarHidden(true)
            }
        }
    }
    func game(for theme: Theme) -> EmojiMemoryGame? {
        if games[theme.id] == nil {
            games[theme.id] = EmojiMemoryGame(theme: theme)
        }
        return games[theme.id]
    }
    
    func playFromBeginning() {
        if !store.isSoundtrackPlaying && !store.returningFromDetail {
            let soundTrack = "Amagama track new"
            if let path = Bundle.main.path(forResource: soundTrack, ofType: "mp3") {
                self.audioPlayer = try? AVAudioPlayer(contentsOf:  URL(fileURLWithPath: path))
                self.audioPlayer.play()
                self.audioPlayer.volume = 0.1
                self.audioPlayer.numberOfLoops = 10
            }
            store.isSoundtrackPlaying.toggle()
        } else {
            return
        }
        
    }
    
    
    func toggleSoundTrack() {
        if store.isSoundtrackPlaying {
            //print("we're muting")
            self.audioPlayer.stop()
            store.isSoundtrackPlaying.toggle()
        } else {
            let soundTrack = "Amagama track new"
            if let path = Bundle.main.path(forResource: soundTrack, ofType: "mp3") {
                self.audioPlayer = try? AVAudioPlayer(contentsOf:  URL(fileURLWithPath: path))
                self.audioPlayer.play()
                self.audioPlayer.volume = 0.1
                self.audioPlayer.numberOfLoops = 10
                store.isSoundtrackPlaying.toggle()
            }
        }
    }
}

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}

