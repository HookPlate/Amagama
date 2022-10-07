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
    
    @State private var audioPlayer: AVAudioPlayer!
    
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
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
}

//struct LottieView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottieView()
//    }
//}

