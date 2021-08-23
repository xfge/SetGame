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
    
    enum Variant: CaseIterable {
        case option1, option2, option3
    }
}
