//
//  CardShape.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

// Using this shape struct for simplicity instead of the strokedSymbol, filledSymbol and shadedSymbol vars/funcs recommended by the materials.
struct CardShape: Shape {
    var shape: Card.Shape
    
    func path(in rect: CGRect) -> Path {
        switch shape {
        case .diamond:
            return Diamond().path(in: rect)
        case .squiggle:
            return Squiggle().path(in: rect)
        case .oval:
            return Capsule().path(in: rect)
        }
    }
    
    @ViewBuilder
    func shaded(by shading: Card.Shading, with color: Color) -> some View {
        switch shading {
        case .filled:
            self.foregroundColor(color)
        case .stroked:
            self.stroke(color, lineWidth: 2.0)
        case .shaded:
            StripView(shape: self, color: color)
        }
    }
}
