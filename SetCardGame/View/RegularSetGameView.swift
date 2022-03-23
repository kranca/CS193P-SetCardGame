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
            Text("\(game.deck.count) cards left on deck")
            
            gameBody
            Spacer()
            bottomBody
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
            
            if !game.deck.isEmpty {
                Button("Deal 3 more cards") {
                    game.deal()
                }
            }
        }
    }
    
    @ViewBuilder
    func cardView(for card: SetGame<RegularSetGame.CardContent>.Card) -> some View {
        if card.isSelected {
            CardView(card: card).cardify(.blue)
        } else {
            CardView(card: card).cardify(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegularSetGameView()
    }
}
