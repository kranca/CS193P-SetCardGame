//
//  SetGame.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 15/03/22.
//

import Foundation

struct SetGame<CardContent> where CardContent: Hashable {
    private(set) var cards: [Card]
    
    init(createCardContent: () -> Set<CardContent>) {
        cards = Array<Card>()
        let content = createCardContent()
        for card in content {
            cards.append(Card(content: card))
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[chosenIndex].isSelected = true
        }
    }
    
    struct Card: Identifiable {
        let id = UUID()
        let content: CardContent
        var isSelected = false
    }
}
