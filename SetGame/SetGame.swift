//
//  SetGame.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import Foundation

struct SetGame {
    var activeCards = [Card]()
    var selectedCards = [Card]()
    
    private var depot: [Card]
    
    init() {
        depot = [Card]()
        for shape in Variant.allCases {
            for color in Variant.allCases {
                for shading in Variant.allCases {
                    for number in Variant.allCases {
                        depot.append(Card(shape: shape, color: color, shading: shading, number: number))
                    }
                }
            }
        }
        depot.shuffle()
    }
    
    mutating func dealCards(_ numCards: Int) {
        for _ in 0..<numCards {
            activeCards.append(depot.remove(at: Int.random(in: 0..<depot.count)))
        }
    }
    
    // MARK: - Intents
    
    mutating func tap(card: Card) {
        if let selectedCardIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
            selectedCards.remove(at: selectedCardIndex)
        } else {
            selectedCards.append(card)
        }
    }
}

