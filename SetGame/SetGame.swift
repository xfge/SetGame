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
    
    var score = 0

    init(initialNumberOfCards: Int) {
        reset()
        dealCards(initialNumberOfCards)
    }
    
    var hasMoreOpenCards: Bool {
        !depot.isEmpty
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
            if hasMoreOpenCards {
                activeCards.append(depot.remove(at: Int.random(in: 0..<depot.count)))
            }
        }
    }
    
    mutating func tap(card: Card) {
        if mismatchedCards.count == 3 {
            mismatchedCards.removeAll()
        }
        
        // If already 3 matched cards, deal 3 more cards to replace them.
        if matchedCards.count == 3 {
            let isTappingAMatchedCard = matchedCards.contains(where: { $0.id == card.id })
            matchedCards.forEach { card in
                if let cardIndex = activeCards.firstIndex(where: { $0.id == card.id }) {
                    if hasMoreOpenCards {
                        // R8: Replace those 3 matching Set cards with new ones.
                        activeCards[cardIndex] = depot.remove(at: Int.random(in: 0..<depot.count))
                    } else {
                        // R8: If the deck is empty, the space of the matched cards will be released to the remaining cards.
                        activeCards.remove(at: cardIndex)
                    }
                }
            }
            matchedCards.removeAll()

            // R8: If the touched card was part of a matching Set, then select no card
            if isTappingAMatchedCard {
                return
            }
        }
        
        if let selectedCardIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
            selectedCards.remove(at: selectedCardIndex)
        } else {
            selectedCards.append(card)
            if selectedCards.count == 3 {
                if match(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2]) {
//                if true {
                    selectedCards.forEach { matchedCards.append($0) }
                    score += 3
                } else {
                    selectedCards.forEach { mismatchedCards.append($0) }
                }
                selectedCards.removeAll()
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

