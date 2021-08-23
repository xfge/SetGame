//
//  SetGame.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import Foundation

struct SetGame {
    var activeCards: [Card] = []
    var selectedCards: [Card] = []
    var matchedCards: [Card] = []
    
    private var depot: [Card] = []
    
    init(initialNumberOfCards: Int) {
        reset()
        dealCards(initialNumberOfCards)
    }
    
    mutating func dealCards(_ numCards: Int) {
        for _ in 0..<numCards {
            activeCards.append(depot.remove(at: Int.random(in: 0..<depot.count)))
        }
    }
    
    // Match the three selected cards in
    func match(card1: Card, card2: Card, card3: Card) -> Bool {
        func eval(_ v1: Card.Variant, _ v2: Card.Variant, _ v3: Card.Variant) -> Bool {
            return (v1 == v2 && v2 == v3) || (v1 != v2 && v1 != v3 && v2 != v3)
        }
        
        return eval(card1.shape, card2.shape, card3.shape) &&
            eval(card1.shading, card2.shading, card3.shading) &&
            eval(card1.color, card2.color, card3.color) &&
            eval(card1.number, card2.number, card3.number)
    }
    
    // MARK: - Intents
    
    mutating func tap(card: Card) {
        if selectedCards.count == 3 {
            selectedCards.removeAll()
        }
        
        if let selectedCardIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
            selectedCards.remove(at: selectedCardIndex)
        } else {
            selectedCards.append(card)
            if selectedCards.count == 3 {
                if match(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2]) {
//                if true {
                    selectedCards.forEach { card in
                        matchedCards.append(card)
                    }
                }
            }
        }
    }
    
    mutating func reset() {
        depot = []
        for shape in Card.Variant.allCases {
            for color in Card.Variant.allCases {
                for shading in Card.Variant.allCases {
                    for number in Card.Variant.allCases {
                        depot.append(Card(shape: shape, color: color, shading: shading, number: number))
                    }
                }
            }
        }
        depot.shuffle()
        
        activeCards = []
        selectedCards = []
        matchedCards = []
    }
}

