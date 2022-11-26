//
//  ChooserViewCard.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

import SwiftUI
//the animal image card within the navlinkview and the title of gamechooserview
struct ChooserViewCard: View {
    var imageName: String
    var body: some View {
        ZStack {
            Color.white.opacity(0.5)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(width: 30, height: 30)
                .shadow(color: Color.gray, radius: 2, x: 2, y: 2)
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .frame(width: 20, height: 20)
        }
    }
}

struct ChooserViewCard_Previews: PreviewProvider {
    static var previews: some View {
        ChooserViewCard(imageName: "owl")
    }
}
