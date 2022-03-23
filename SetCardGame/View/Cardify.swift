//
//  Cardify.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 17/03/22.
//

import SwiftUI

struct Cardify: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            cardShape
                .fill()
                .foregroundColor(.white)
            cardShape
                .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                .foregroundColor(color)
            content
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(_ color: Color) -> some View {
        self.modifier(Cardify(color: color))
    }
}
