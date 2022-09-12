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
    
    let slider = MPVolumeView().subviews.first(where: { $0 is UISlider }) as? UISlider
    
    let restartableSentenceScores = [5, 15, 25, 35, 45, 55]
    
    @State private var isMuted = false
    
    @ObservedObject var game: EmojiMemoryGame
    
    @State private var audioPlayer: AVAudioPlayer!
    
    @State private var audioPlayer1: AVAudioPlayer!
    
    @State private var sentenceComplete = false
    
    @State private var wordscaleAmount: CGFloat = 1
    
    @Namespace private var dealingNamespace
    
    @State private var showTitle = false
    
    let myShuffledAnimals = Animals()
    
    @Binding var score: Int
    
    @State private var animateScore = false
    
    @State private var animateWholeScore = false
    
    @State private var sentencesDone = 0
    
    @State private var blurAmount = 0
    
    @State private var showScore = false
    
    var body: some View {
        ZStack(alignment: .center) {
//            Color(red: 228/255, green: 195/255, blue: 76/255)
//                .ignoresSafeArea()
            GeometryReader { geo in
            VStack(spacing: 15) {
                    TopTargetSentence(sentenceComplete: sentenceComplete, wordscaleAmount: wordscaleAmount, showTitle: showTitle, geo: geo, game: game)
                    
                    gameBody
                    .blur(radius: CGFloat(blurAmount))
               // }
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
              //  .navigationTitle("Match the Words")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: showScore ? MyScore(animateWholeScore: animateWholeScore, animateScore: animateScore, score: score) : nil)
                .navigationBarItems(trailing: Button(action: {muteAudio()}, label: {isMuted ? Image(systemName: "speaker.slash").font(.title) : Image(systemName: "speaker.wave.2").font(.title)}))
                Spacer(minLength: 0)
            }
            
            if sentenceComplete {
               // BlurView(style: .systemMaterialLight)
                SuccessTickView()
            }
        }
        .onAppear(perform: flip )
        .onAppear(perform: autoDeal)
        .onDisappear(perform: game.restart)
        .onDisappear(perform: stopSound)
        .onDisappear(perform: game.gameCompleted)
        .padding()
    }
    

    private func flip () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            for card in game.cards {
                withAnimation {
                    game.flip(card)
                }
            }
        }
    }
    
    private func muteAudio() {
        if !isMuted {
            slider?.setValue(0.0, animated: false)
            isMuted = true
        } else {
            slider?.setValue(0.5, animated: false)
            isMuted = false
        }
    }
    
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
       // score = 0
        dealt.insert(card.id)
        //clean this code up so it uses a timer and one completion (of in this case the above code) triggers another
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                game.shuffle()
            }
        }
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
                            wordScaleAndSoundTrigger(card: card)
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
//        .onTapGesture {
//            //deal cards
//            for card in game.cards {
//                withAnimation(dealAnimation(for: card)) {
//                    deal(card)
//                }
//            }
//        }
    }
    //run this if there's been a succesful match:
    func wordScaleAndSoundTrigger(card: EmojiMemoryGame.Card) {
        let celebrationAudio = Bundle.main.path(forResource: "CarlaYeahs", ofType: "mp3")
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        if game.wordJustMatched {
            //makes the score pop out if the user has succesfully completed the sentence once
            if sentencesDone >= 1 {
                withAnimation {
                    animateScore = true
                }
                
                score += 1
            }
            //makes sound for the word and scales the word in and out
            makeSound(for: card.content)
            wordscaleAmount = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                wordscaleAmount = 1
                withAnimation {
                    animateScore = false
                }
            }
            //run this if the game has been completed.
            if game.matchedCards.count == game.mainTitle.count {
                    sentencesDone += 1
               

                //animate the whole sentence
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    sentenceComplete = true
                    makeAnotherSound(for: "SuccessTickSound1")
                    withAnimation {
                        blurAmount = 8
                    }
                    
                    wordscaleAmount = 1.3
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        wordscaleAmount = 1
                        
                    }
                    //read the whole sentence
                    makeSound(for: game.mainTitle.joined(separator: " "))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showScore = true
                                sentenceComplete = false
                                blurAmount = 0
                            }
                            
                            game.gameCompleted()
                            
                            print(score)
                            
                            if restartableSentenceScores.contains(score) {
                                restart()
                            }
                    }
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        
                        withAnimation {
                            animateWholeScore = true
                            game.shuffle()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            animateWholeScore = false
                        }
                    }
                }
            }
        } else {
            print("No Sound Here")
        }
    }
    
    func makeSound(for sound: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
            self.audioPlayer = try? AVAudioPlayer(contentsOf:  URL(fileURLWithPath: path))
            self.audioPlayer.play()
        }
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    flip()
                }

            }
        }
        showTheTitle()
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
                game.restart()
                game.gameCompleted()
                flip()
                autoDeal()
                showTheTitle()
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
    var animalImageNames = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "duck", "dog", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    
//    init() {
//        //animalImageNames.shuffle()
//    }
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
    var animateWholeScore: Bool
    var animateScore: Bool
    var score: Int
    var body: some View {
        HStack {
            Text("Score:")
            Text("\(score)")
                .scaleEffect(animateScore ? 1.5 : 1 )
        }
        .padding(.horizontal, 3)
        .foregroundColor(.black)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(color: Color.gray.opacity(0.5), radius: 2, x: CGFloat(3),y: CGFloat(4))
        .scaleEffect(animateWholeScore ? 1.3 : 1 )
    }
}


    

