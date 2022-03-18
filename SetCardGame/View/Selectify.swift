//
//  Selectify.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 18/03/22.
//

import SwiftUI

struct Selectify: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            cardShape
                .fill()
                .foregroundColor(.white)
            cardShape
                .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                .foregroundColor(.red)
            content
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func selectify() -> some View {
        self.modifier(Selectify())
    }
}
