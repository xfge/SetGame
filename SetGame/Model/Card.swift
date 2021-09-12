//
//  Card.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import Foundation

struct Card: Identifiable {
    let variant1: Variant
    let variant2: Variant
    let variant3: Variant
    let variant4: Variant
    
    let id: Int
    
    enum Variant: CaseIterable {
        case option1, option2, option3
    }
}
