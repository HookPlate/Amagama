//
//  EmojiMemoryGameView.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//
//This is your view

import SwiftUI
import AVKit
import MediaPlayer


struct EmojiMemoryGameView: View {
    
    @EnvironmentObject var store: ThemeStore
    
//    let restartableSentenceScores = [5, 15, 25, 35, 45, 55]
    @State private var showBlurAndTick = false
    
    @State private var isMuted = false
    
    @ObservedObject var game: EmojiMemoryGame
    
    @State private var audioPlayer: AVAudioPlayer!
    
    @State private var audioPlayer1: AVAudioPlayer!
    
    @Namespace private var dealingNamespace
    
    @State private var showTitle = false
    
    let myShuffledAnimals = Animals()
    
    @Binding var score: Int
    
    @State private var sentencesDone = 0
    
    @State private var blurAmount = 0

    
    var body: some View {
        ZStack(alignment: .center) {
//            Color(red: 228/255, green: 195/255, blue: 76/255)
//                .ignoresSafeArea()
            GeometryReader { geo in
            VStack(spacing: 15) {
                    TopTargetSentence(showTitle: showTitle, geo: geo, game: game)
                    
                    gameBody
                    .blur(radius: CGFloat(blurAmount))
                
                    //shows either progress bar or deck of cards
                  if showTitle {
                    ProgressBar(
                        width: geo.size.width, height: 15, percent: CGFloat(Double(score) * 10), color1: Color(#colorLiteral(red: 0, green: 0.2657890916, blue: 0, alpha: 1)) , color2: Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)), showTitle: showTitle
                    )
                        .animation(.easeInOut(duration: 1))
                } else {
                    deckBody                }
                    
                }
            .frame(width: geo.size.width, height: geo.size.height / 1.05)
            .navigationTitle("Match the words")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: MyScore(score: score))
                .navigationBarItems(trailing: Button(action: {isMuted.toggle()}, label: {isMuted ? Image(systemName: "speaker.slash").font(.footnote) : Image(systemName: "speaker.wave.2").font(.callout)}))
                Spacer(minLength: 0)
            }
            
            if showBlurAndTick {
                BlurView(style: .systemMaterialLight)
                
                SuccessTickView()
               
                
            }
        }
      //  .onAppear(perform: flip )
        .onAppear(perform: autoDeal)
        .onDisappear(perform: game.restart)
        .onDisappear(perform: stopSound)
        .onDisappear(perform: game.gameCompleted)
        .onDisappear(perform: toggleReturningFromDetail)
        .padding()
    }
    
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt (_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * CardConstants.totalDealDuration / Double(game.cards.count)
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) ->  Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    private func showBlurView() {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("This is just before the tick")
            makeAnotherSound(for: "SuccessTickSound1")
            withAnimation {
                showBlurAndTick = true
                blurAmount = 8
            }
        
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                blurAmount = 0
                showBlurAndTick = false
            }
                
  
        }
    }
    
    
    var gameBody: some View {//the below passes each card into its arg with { card in, it's the content arg of
        AspectVGrid(items:game.cards, aspectRatio: 2.5/3) { card in
            if isUnDealt(card) || (card.isMatched && !card.isFaceUp) {
                //this is the empty space for when a card has been matched.
                Color.clear
            } else {
                CardView(card: card, shuffledAnimals: myShuffledAnimals)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(){
                            game.choose(card)
                            if game.alreadyMatchedWordJustTapped {
                                alreadyMatchedVibration()
                            } else {
                                wordScaleAndSoundTrigger(card: card)
                            }
                            
                        }
                    }
            }
        }
        
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUnDealt)) { card in
                CardView(card: card, shuffledAnimals: myShuffledAnimals)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
    }
    
//    func cardForView(card: EmojiMemoryGame.Card) -> CardView {
//        var i = 0
//        return CardView(card: card, animalForCard: store.animals[i])
//    }
    
    //run this if there's been a succesful match:
    func wordScaleAndSoundTrigger(card: EmojiMemoryGame.Card) {
        
        if game.wordJustMatched {
            if sentencesDone >= 1 {
                score += 1
            }
            //makes sound for the word and scale the word in and out
            makeSound(for: card.content, afterDelay: 0)
            
            //run this if the sentence has been completed.
            if game.matchedCards.count == game.mainTitle.count {
                sentencesDone += 1
                showBlurView()
                
            //read the whole sentence
                makeSound(for: game.mainTitle.joined(separator: " "), afterDelay: 1.5)
                game.gameCompleted()
                
            // after the first sentence shuffle the cards
                withAnimation {
                    if game.cards.allSatisfy({ $0.isMatched == true }) {
                    } else {
                        game.shuffle()
                    }
                }
                
            //if all the cards in the game restart the game
                if game.cards.allSatisfy({ $0.isMatched == true }) {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        dealt = Set<Int>()
                        showTheTitle()
                    }
                    restart()
                }
            }
        } else {
            print("No Sound Here")
        }
    }
    
    
     func makeSound(for sound: String, afterDelay: Double) {
        if !isMuted {
            DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) {
                if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
                    self.audioPlayer = try? AVAudioPlayer(contentsOf:  URL(fileURLWithPath: path))
                    self.audioPlayer.play()
                }
            }
        }
    }
    
    func toggleReturningFromDetail() {
        store.returningFromDetail = true
    }
    
    func stopSound() {
        if let myAudioPlayer = audioPlayer {
            myAudioPlayer.stop()
        }
    }
    
    func makeAnotherSound(for sound: String) {
            if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
                self.audioPlayer1 = try? AVAudioPlayer(contentsOf:  URL(fileURLWithPath: path))
                self.audioPlayer1.play()
            }
    }
    
    func autoDeal() {
        for card in game.cards {
            withAnimation(dealAnimation(for: card)) {
                deal(card)
            }
        }
        if sentencesDone < 1 {
            showTheTitle()
        }
    }
    
    func alreadyMatchedVibration() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func showTheTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showTitle.toggle()
            }
        }
    }
    
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    func restart() {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showTitle = false
            }
            game.restart()
            autoDeal()
            game.gameCompleted()
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct Animals {
    var animalImageNames = ["panda", "bear", "chick", "bear","chicken", "crocodile", "cow", "elephant", "duck", "giraffe", "hippo", "gorilla", "sloth", "goat", "narwhal", "parrot", "owl", "penguin", "moose", "pig", "snake", "rhino", "walrus", "penguin", "whale", "rabbit", "zebra", "sloth", "snake", "walrus", "whale", "zebra"]
//   these are the sentences she wants: var animalImageNames = ["buffalo", "chick", "chicken", "cow", "crocodile", "elephant", "giraffe", "gorilla", "hippo", "horse", "narwhal", "owl", "parrot", "penguin", "pig", "rhino", "snake", "walrus", "whale", "zebra"]
}
    


struct DrawingConstants {
    static let fontScale: CGFloat = 0.25
    static let fontSize:  CGFloat = 20
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = EmojiMemoryGame()
//        game.choose(game.cards.first!)
//        return EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.light)
//    }
//}

struct MyScore: View {
    var score: Int
    @State private var change = false
    var body: some View {
        HStack {
            Text("Score:")
            Text("\(score)")
        }
        .padding(.horizontal, 3)
        .foregroundColor(.black)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(color: Color.gray.opacity(0.5), radius: 2, x: CGFloat(3),y: CGFloat(4))
      //  .animation(.easeInOut(duration: 3))
    }
}


    

