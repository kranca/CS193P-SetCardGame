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
    @Namespace private var clearingNamespace
    
    private func dealAnimation(for index: Int) -> Animation {
        var delay = 0.0
        
        delay = Double(index) * (GameConstants.totalDealDuration / Double(game.cardsOnBoard.count))
        
        return Animation.easeInOut(duration: GameConstants.dealDuration).delay(delay)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                Spacer()
                bottomBody.padding(.horizontal)
            }//.zIndex(1)
            HStack {
                deckBody//.zIndex(-1)
                Spacer()
                discardedDeckBody//.zIndex(2)
            }
            .padding(.horizontal)
        }
    }
    
    var gameBody: some View {
        VStack {
            AspectRatioVGrid(items: game.cardsOnBoard, aspectRatio: GameConstants.aspectRatio, content: { card in
                cardView(for: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            game.choose(card)
                        }
                    }.transition(.identity)
                    .matchedGeometryEffect(id: card.id, in: clearingNamespace)
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
                    .aspectRatio(GameConstants.aspectRatio, contentMode: .fill)
                    .cardify(.black, contentOn: false)
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: GameConstants.deckWidth, height: GameConstants.deckHeight)
        .onTapGesture {
            for index in 1...3 {
                withAnimation(dealAnimation(for: index)) {
                    game.deal()
                }
            }
        }
    }
    
    var discardedDeckBody: some View {
        ZStack {
            ForEach(game.discardedCards) { card in
                CardView(card: card)
                    .aspectRatio(GameConstants.aspectRatio, contentMode: .fill)
                    .cardify(.black, contentOn: true)
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: clearingNamespace)
                    .transition(.identity)
            }
        }
        .frame(width: GameConstants.deckWidth, height: GameConstants.deckHeight)
        
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
        .padding(GameConstants.cardPadding)
    }
    
    private struct GameConstants {
        static let totalDealDuration: Double = 3
        static let dealDuration: Double = 1
        static let aspectRatio: CGFloat = 2/3
        static let deckHeight: CGFloat = 90
        static let deckWidth = deckHeight * aspectRatio
        static let cardPadding: CGFloat = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegularSetGameView()
    }
}
