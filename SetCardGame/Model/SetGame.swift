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
    private(set) var discardedCards = [Card]()
    
    init(createCardContent: () -> Set<CardContent>) {
        cards = Array<Card>()
        let content = createCardContent()
        for card in content {
            cards.append(Card(content: card))
        }
        deal()
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
            //replaceCards()
            discardCards()
            
            for index in cardsOnBoard.indices {
                cardsOnBoard[index].isSelected = false
                cardsOnBoard[index].isMatched = nil
            }
            potentialSet.removeAll()
            
            if let chosenIndex = cardsOnBoard.firstIndex(where: { $0.id == card.id }) {
                cardsOnBoard[chosenIndex].isSelected.toggle()
                potentialSet.append(cardsOnBoard[chosenIndex])
            }
        }
    }
    
    mutating func areMatched(checkForMatch: () -> Bool) {
        if checkForMatch() {
            for card in potentialSet {
                if let index = cardsOnBoard.firstIndex(where: { $0.id == card.id }) {
                    cardsOnBoard[index].isMatched = true
                }
            }
            for index in potentialSet.indices {
                potentialSet[index].isMatched = true
            }
            
        } else {
            for card in potentialSet {
                if let index = cardsOnBoard.firstIndex(where: { $0.id == card.id }) {
                    cardsOnBoard[index].isMatched = false
                }
            }
        }
    }
    
    struct Card: Identifiable {
        let id = UUID()
        let content: CardContent
        var isSelected = false
        var isMatched: Bool?
    }
    
    mutating func deal() {
        // case first 12 cards are dealt
        if deck.isEmpty && cardsOnBoard.isEmpty {
            for index in 0...11 {
                cardsOnBoard.append(cards[index])
            }
            for index in 12...cards.count-1 {
                deck.append(cards[index])
            }
        // case 3 cards are matched and highlighted green + closed deck is tapped
        } else if cardsOnBoard.contains(where: { $0.isMatched == true }) {
            replaceCards()
        // case closed deck is tapped without matching cards
        } else {
            if deck.count > 2 {
                    cardsOnBoard.append(deck.first!)
                    deck.removeFirst()
            }
        }
    }
    
    mutating func replaceCards() {
        if potentialSet.contains(where: { $0.isMatched == true }) {
                if let index = cardsOnBoard.firstIndex(where: { $0.isMatched == true }) {
                    discardedCards.append(cardsOnBoard[index])
                    cardsOnBoard.remove(at: index)
                    if deck.count > 0 {
                        cardsOnBoard.insert(deck.first!, at: index)
                        deck.removeFirst()
                    }
                }
            }
    }
    
    mutating func discardCards() {
        for card in potentialSet {
            if let match = card.isMatched {
                if match {
                    if let index = cardsOnBoard.firstIndex(where: { $0.id == card.id }) {
                        discardedCards.append(cardsOnBoard[index])
                        cardsOnBoard.remove(at: index)
                    }
                }
            }
        }
    }
}
