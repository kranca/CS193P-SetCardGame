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
    
    var deck: Array<Card> {
        model.deck
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
        if model.potentialSet.count > 2 {
            areMatched()
        }
    }
    
    func deal() {
        model.deal()
    }
    
    func areMatched() {
        model.areMatched {
            if model.potentialSet[0].content.color == model.potentialSet[1].content.color && model.potentialSet[1].content.color == model.potentialSet[2].content.color {
                return true
            } else if model.potentialSet[0].content.number == model.potentialSet[1].content.number && model.potentialSet[1].content.number == model.potentialSet[2].content.number {
                return true
            } else if model.potentialSet[0].content.shading == model.potentialSet[1].content.shading && model.potentialSet[1].content.shading == model.potentialSet[2].content.shading {
                return true
            } else if model.potentialSet[0].content.shape == model.potentialSet[1].content.shape && model.potentialSet[1].content.shape == model.potentialSet[2].content.shape {
                return true
            } else {
                return false
            }
        }
    }
}

