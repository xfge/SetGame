//
//  Card.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import Foundation

struct Card: Identifiable {
    let shape: Variant
    let color: Variant
    let shading: Variant
    let number: Variant
    
    let id = UUID()
    
    var numberOfShapes: Int {
        switch number {
        case .option1:
            return 1
        case .option2:
            return 2
        case .option3:
            return 3
        }
    }
}

enum Variant: CaseIterable {
    case option1, option2, option3
}
