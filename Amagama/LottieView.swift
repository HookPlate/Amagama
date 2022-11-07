//
//  LottieView.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI
import Lottie
import AVKit

struct LottieView: UIViewRepresentable {
    
    typealias UIViewType = UIView
    var fileName: String
    
    var audioPlayer2: AVAudioPlayer!
    
    init(fileName: String) {
        self.fileName = fileName
        makeAnotherSound(for: "SuccessTickSound1")
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimationView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play(completion: { finished in
            print("this is after the tick")
            //just call the makeSound function from here.
        })
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        
        return view
    }
    
    
    mutating func makeAnotherSound(for sound: String) {
            if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
                self.audioPlayer2 = try? AVAudioPlayer(contentsOf:  URL(fileURLWithPath: path))
                self.audioPlayer2.play()
            }
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
}

//struct LottieView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottieView()
//    }
//}

