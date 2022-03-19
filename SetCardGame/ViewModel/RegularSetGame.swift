//
//  RegularSetGame.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 15/03/22.
//

import SwiftUI

class RegularSetGame: ObservableObject {
    typealias Card = SetGame<CardContent>.Card
    
    private static func createGame() -> SetGame<CardContent> {
        SetGame {
            var cardContentSet = Set<CardContent>()

            for num in 1...3 {
                for shapeOption in ShapeType.allCases {
                    for colorOption in ShapeColor.allCases {
                        for shadingOption in ShapeShading.allCases {
                            let content = CardContent(number: num, shape: shapeOption, color: colorOption, shading: shadingOption)
                            cardContentSet.insert(content)
                        }
                    }
                }
            }
            return cardContentSet
        }
    }
    
    @Published private var model: SetGame<CardContent>
    
    var cardsOnBoard: [Card] {
        model.cardsOnBoard
    }
    
    init() {
        self.model = RegularSetGame.createGame()
    }
    
    enum ShapeType: CaseIterable {
        case circle
        case diamond
        case rectangle
    }
    
    enum ShapeColor: CaseIterable {
        case green
        case purple
        case red
    }
    
    enum ShapeShading: String, CaseIterable {
        case solid
        case striped
        case open
    }
    
    var cards: Array<Card> {
        model.cards
    }
    
    struct CardContent: Equatable, Hashable {
        var number: Int
        var shape: ShapeType
        var color: ShapeColor
        var shading: ShapeShading
    }
    
    static func selectColor(for card: Card) -> Color {
        switch card.content.color {
        case .green:
            return .green
        case .purple:
            return .purple
        case .red:
            return .red
        }
    }
    
    // MARK: - Intents
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func deal() {
        model.deal()
    }
    
    func areMatched(potentialMatch: [Card]) -> Bool {
        if potentialMatch[0].content.color == potentialMatch[1].content.color && potentialMatch[1].content.color == potentialMatch[2].content.color {
            return true
        } else if potentialMatch[0].content.number == potentialMatch[1].content.number && potentialMatch[1].content.number == potentialMatch[2].content.number {
            return true
        } else if potentialMatch[0].content.shading == potentialMatch[1].content.shading && potentialMatch[1].content.shading == potentialMatch[2].content.shading {
            return true
        } else if potentialMatch[0].content.shape == potentialMatch[1].content.shape && potentialMatch[1].content.shape == potentialMatch[2].content.shape {
            return true
        } else {
            return false
        }
    }
}

