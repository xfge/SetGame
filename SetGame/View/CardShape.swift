//
//  CardShape.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

struct CardShape: Shape {
    typealias Variant = Card.Variant
    
    var shape: Variant
    
    func path(in rect: CGRect) -> Path {
        switch shape {
        case .option1:
            return Diamond().path(in: rect)
        case .option2:
            return Capsule().path(in: rect)
        case .option3:
            return Rectangle().path(in: rect)
        }
    }
}

extension CardShape {
    @ViewBuilder
    func shaded(by shading: Variant) -> some View {
        switch shading {
        case .option1:
            self
        case .option2:
            self.stroke(lineWidth: 2.0)
        case .option3:
            self.opacity(0.5)
        }
    }
}
