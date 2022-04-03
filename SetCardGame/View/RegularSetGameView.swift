//
//  RegularSetGameView.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 15/03/22.
//

import SwiftUI

struct RegularSetGameView: View {
    typealias Card = SetGame<RegularSetGame.CardContent>.Card
    
    @ObservedObject var game = RegularSetGame()
    @Namespace private var dealingNamespace
    
    @State private var deckDealt = Set<UUID>()
    
    private func deal(_ card: Card) {
        deckDealt.insert(card.id)
    }
    
//    private func isUndealt(_ card: Card) -> Bool {
//        !deckDealt.contains(card.id)
//    }
    
    private func dealAnimation(for card: Card) -> Animation {
        var delay = 0.0
        if let index = game.cardsOnBoard.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (3 / Double(game.cardsOnBoard.count))
        }
        return Animation.easeInOut(duration: 1).delay(delay)
    }
    
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
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
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
            for card in game.cardsOnBoard {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
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
    
    private func zIndex(of card: Card) -> Double {
        -Double(game.deck.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    @ViewBuilder
    func cardView(for card: Card) -> some View {
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
