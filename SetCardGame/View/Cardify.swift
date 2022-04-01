//
//  Cardify.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 17/03/22.
//

import SwiftUI

struct Cardify: ViewModifier {
    let color: Color
    var contentOn = true
    
    func body(content: Content) -> some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if contentOn {
                cardShape
                    .fill()
                    .foregroundColor(.white)
                cardShape
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    .foregroundColor(color)
                content
            } else {
                cardShape
                    .fill()
                    .foregroundColor(.black)
            }
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(_ color: Color, contentOn: Bool = true) -> some View {
        self.modifier(Cardify(color: color, contentOn: contentOn))
    }
}
