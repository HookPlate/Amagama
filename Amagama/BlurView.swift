//
//  BlurView.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
  //  typealias UIViewType = UIView
    
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        //do nothing
    }
}
