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
    var mismatchedCards: [Card] = []
    
    private var depot: [Card] = []
    
    init(initialNumberOfCards: Int) {
        reset()
        dealCards(initialNumberOfCards)
    }
    
    var hasNoOpenCards: Bool {
        depot.isEmpty
    }
    
    // check whether the 3 selected cards are matched or not
    private func match(card1: Card, card2: Card, card3: Card) -> Bool {
        func eval(_ v1: Card.Variant, _ v2: Card.Variant, _ v3: Card.Variant) -> Bool {
            return (v1 == v2 && v2 == v3) || (v1 != v2 && v1 != v3 && v2 != v3)
        }
        
        return eval(card1.shape, card2.shape, card3.shape) &&
            eval(card1.shading, card2.shading, card3.shading) &&
            eval(card1.color, card2.color, card3.color) &&
            eval(card1.number, card2.number, card3.number)
    }
    
    // MARK: - Intents
    
    mutating func dealCards(_ numCards: Int) {
        selectedCards.removeAll()
        mismatchedCards.removeAll()
        
        for _ in 0..<numCards {
            let newCard = depot.remove(at: Int.random(in: 0..<depot.count))
            if let hiddenCardIndex = activeCards.firstIndex(where: { card in
                matchedCards.contains(where: { $0.id == card.id })
            }) {
                activeCards[hiddenCardIndex] = newCard
            } else {
                activeCards.append(newCard)
            }
        }
    }
    
    mutating func tap(card: Card) {
        if selectedCards.count == 3 {
            selectedCards.removeAll()
        }
        
        if mismatchedCards.count == 3 {
            mismatchedCards.removeAll()
        }
        
        if let selectedCardIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
            selectedCards.remove(at: selectedCardIndex)
        } else {
            selectedCards.append(card)
            if selectedCards.count == 3 {
                if match(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2]) {
//                if true {
                    selectedCards.forEach { matchedCards.append($0) }
                } else {
                    selectedCards.forEach { mismatchedCards.append($0) }
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
        mismatchedCards = []
    }
}

