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
            gameBody
            Spacer()
            bottomBody.padding(.horizontal)
        }
    }
    
    var gameBody: some View {
        VStack {
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
            Button("New Game") {
                game.startNewGame()
            }
            Spacer()
            if !game.deck.isEmpty {
                Button("Deal 3 more cards") {
                    game.deal()
                }
            }
        }
    }
    
    @ViewBuilder
    func cardView(for card: SetGame<RegularSetGame.CardContent>.Card) -> some View {
        Group {
            if let match = card.isMatched {
               if match {
                   CardView(card: card).cardify(.green)
               } else {
                   CardView(card: card).cardify(.red)
               }
           } else if card.isSelected {
               CardView(card: card).cardify(.blue)
           } else {
               CardView(card: card).cardify(.black)
           }
        }
        .padding(1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegularSetGameView()
    }
}
