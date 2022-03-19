//
//  RegularSetGameView.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 15/03/22.
//

import SwiftUI

struct RegularSetGameView: View {
    @ObservedObject var game = RegularSetGame()
    var body: some View {
        VStack {
            Text("Test")
            
            gameBody
            Spacer()
            bottomBody
        }
    }
    
    var gameBody: some View {
        VStack {
//            let grid = [GridItem(), GridItem()]
//            ScrollView {
//                LazyVGrid(columns: grid) {
//                    ForEach(game.cards, id: \.self.id) { card in
//                        VStack {
//                            CardView(card: card)
//                                .aspectRatio(2/3, contentMode: .fill)
//                        }
//                    }
//                }
//            }
            AspectRatioVGrid(items: game.cardsOnBoard, aspectRatio: 2/3, content: { card in
                cardView(for: card)
                    .onTapGesture {
                        game.choose(card)
                    }
            })
        }
    }
    
    var bottomBody: some View {
        HStack(alignment: .center) {
            Button("Deal") {
                game.deal()
            }
        }
    }
    
    @ViewBuilder
    func cardView(for card: SetGame<RegularSetGame.CardContent>.Card) -> some View {
        if card.isSelected {
            CardView(card: card).selectify()
        } else {
            CardView(card: card).cardify()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegularSetGameView()
    }
}
