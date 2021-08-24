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
        
        return eval(card1.variant1, card2.variant1, card3.variant1) &&
            eval(card1.variant2, card2.variant2, card3.variant2) &&
            eval(card1.variant3, card2.variant3, card3.variant3) &&
            eval(card1.variant4, card2.variant4, card3.variant4)
    }
    
    // MARK: - Intents
    
    mutating func dealCards(_ numCards: Int) {        
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
        for variant1 in Card.Variant.allCases {
            for variant2 in Card.Variant.allCases {
                for variant3 in Card.Variant.allCases {
                    for variant4 in Card.Variant.allCases {
                        depot.append(Card(variant1: variant1, variant2: variant2, variant3: variant3, variant4: variant4))
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

