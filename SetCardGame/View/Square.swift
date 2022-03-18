//
//  Square.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 17/03/22.
//

import SwiftUI

struct Square: Shape {
    func path(in rect: CGRect) -> Path {
        let side = min(rect.width, rect.height)
        
        let upperLeftCorner = CGPoint(x: rect.midX - side/2, y: rect.midY - side/2)
        let lowerLeftCorner = CGPoint(x: rect.midX - side/2, y: rect.midY + side/2)
        let lowerRighrCorner = CGPoint(x: rect.midX + side/2, y: rect.midY + side/2)
        let upperRightCorner = CGPoint(x: rect.midX + side/2, y: rect.midY - side/2)
        var p = Path()
        p.move(to: upperLeftCorner)
        p.addLine(to: lowerLeftCorner)
        p.addLine(to: lowerRighrCorner)
        p.addLine(to: upperRightCorner)
        p.addLine(to: upperLeftCorner)
        return p
    }
}
