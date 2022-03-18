//
//  Diamond.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 17/03/22.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let upperCorner = CGPoint(x: rect.midX, y: rect.midY - (rect.height/2)*0.8)
        let leftCorner = CGPoint(x: rect.minX, y: rect.midY)
        let lowerCorner = CGPoint(x: rect.midX, y: rect.midY + (rect.height/2)*0.8)
        let rightCorner = CGPoint(x: rect.maxX, y: rect.midY)
        var p = Path()
        p.move(to: upperCorner)
        p.addLine(to: leftCorner)
        p.addLine(to: lowerCorner)
        p.addLine(to: rightCorner)
        p.addLine(to: upperCorner)
        return p
    }
}
