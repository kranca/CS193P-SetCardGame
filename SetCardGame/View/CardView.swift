//
//  CardView.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 17/03/22.
//

import SwiftUI

struct CardView: View {
    let card: SetGame<RegularSetGame.CardContent>.Card
    
    var body: some View {
        VStack {
            ForEach(0..<card.content.number, id: \.self) { _ in
                switch card.content.shape {
                case .circle:
                    switch card.content.shading {
                    case .solid:
                        Circle()
                            .fill()
                    case .striped:
                        Circle()
                            .opacity(DrawingConstants.opacity)
                    case .open:
                        Circle()
                            .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    }
                    
                case .diamond:
                    switch card.content.shading {
                    case .solid:
                        Diamond()
                            .fill()
                    case .striped:
                        Diamond()
                            .opacity(DrawingConstants.opacity)
                    case .open:
                        Diamond()
                            .stroke(lineWidth: DrawingConstants.lineWidth)
                    }
                    
                case .rectangle:
                    switch card.content.shading {
                    case .solid:
//                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                        Square()
                            .fill()
                    case .striped:
//                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                        Square()
                            .opacity(DrawingConstants.opacity)
                    case .open:
//                        RoundedRectangle(cornerRadius: 15, style: .circular)
                        Square()
                            .stroke(lineWidth: DrawingConstants.lineWidth)
                    }
                }
            }
            .aspectRatio(2/1, contentMode: .fit)
            .foregroundColor(RegularSetGame.selectColor(for: card))
        }
        .padding(DrawingConstants.padding)
    }
    
    private struct DrawingConstants {
        static let opacity: Double = 0.7
        static let lineWidth: CGFloat = 2
        static let padding: CGFloat = 5
    }
}

struct CardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = RegularSetGame()
        CardView(card: game.deck[1])
    }
}
