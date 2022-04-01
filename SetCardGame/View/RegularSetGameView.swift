//
//  RegularSetGameView.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 15/03/22.
//

import SwiftUI

struct RegularSetGameView: View {
    @ObservedObject var game = RegularSetGame()
    @Namespace private var dealingNamespace
    
    @State private var deckDealt = Set<UUID>()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                Spacer()
                bottomBody.padding(.horizontal)
            }
            HStack {
                deckBody
                Spacer()
                discardedDeckBody
            }
            .padding(.horizontal)
        }
    }
    
    var gameBody: some View {
        VStack {
            AspectRatioVGrid(items: game.cardsOnBoard, aspectRatio: 2/3, content: { card in
                cardView(for: card)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            game.choose(card)
                        }
                    }
            })
        }
    }
    
    var bottomBody: some View {
        HStack(alignment: .center) {
            Spacer()
            Button("New Game") {
                game.startNewGame()
            }
            Spacer()
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .cardify(.black, contentOn: false)
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: 60, height: 90)
        .onTapGesture {
            game.deal()
        }
    }
    
    var discardedDeckBody: some View {
        ZStack {
            ForEach(game.discardedCards) { card in
                CardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .cardify(.black, contentOn: true)
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: 60, height: 90)
        
    }
    
    private func zIndex(of card: SetGame<RegularSetGame.CardContent>.Card) -> Double {
        -Double(game.deck.firstIndex(where: { $0.id == card.id }) ?? 0)
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
