//
//  SetGame.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 15/03/22.
//

import Foundation

struct SetGame<CardContent> where CardContent: Hashable {
    private(set) var cards: [Card]
    private(set) var cardsOnBoard = [Card]()
    private(set) var deck = [Card]()
    private(set) var potentialSet = [Card]()
    
    init(createCardContent: () -> Set<CardContent>) {
        cards = Array<Card>()
        let content = createCardContent()
        for card in content {
            cards.append(Card(content: card))
        }
    }
    
    mutating func choose(_ card: Card) {
        if potentialSet.count < 3 {
            if let chosenIndex = cardsOnBoard.firstIndex(where: { $0.id == card.id }) {
                cardsOnBoard[chosenIndex].isSelected.toggle()
                
                if cardsOnBoard[chosenIndex].isSelected {
                    potentialSet.append(cardsOnBoard[chosenIndex])
                } else {
                    if let removeIndex = potentialSet.firstIndex(where: { $0.id == card.id }) {
                        potentialSet.remove(at: removeIndex)
                    }
                }
            }
        } else {
            
        }
    }
    
    mutating func areMatched(potentialMatch: [Card], checkForMatch: (_ potentialMatch: [Card]) -> Bool) {
        if checkForMatch(potentialMatch) {
            for card in potentialMatch {
                if let index = cardsOnBoard.firstIndex(where: { $0.id == card.id }) {
                    cardsOnBoard[index].isMatched = true
                }
            }
        }
    }
    
    struct Card: Identifiable {
        let id = UUID()
        let content: CardContent
        var isSelected = false
        var isMatched = false
    }
    
    mutating func deal() {
        if deck.isEmpty && cardsOnBoard.isEmpty {
            for index in 0...11 {
                cardsOnBoard.append(cards[index])
            }
            for index in 12...cards.count-1 {
                deck.append(cards[index])
            }
        } else if !deck.isEmpty {
            for index in 0...(min(2, deck.count-1)) {
                cardsOnBoard.append(deck[index])
            }
            deck.remove(at: 0)
            deck.remove(at: 0)
            deck.remove(at: 0)
        }
    }
}
