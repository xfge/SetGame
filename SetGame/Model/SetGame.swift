//
//  SetGame.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import Foundation

struct SetGame {
    private(set) var activeCards: [Card] = []
    private(set) var matchedCards: [Card] = []
    private(set) var mismatchedCards: [Card] = []
    
    private(set) var selectedCards: [Card] = [] {
        didSet {
            if selectedCards.count == 3 {
                if match(card1: selectedCards[0], card2: selectedCards[1], card3: selectedCards[2]) {
                    matchedCards = selectedCards
                    // Extra credit 4: Give higher scores to players who choose matching Sets faster
                    if let player = activePlayer {
                        scores[player] += max(15 - Int(Date().timeIntervalSince(lastMatchedAt) / 2), 1)
                    }
                } else {
                    mismatchedCards = selectedCards
                    if let player = activePlayer {
                        scores[player] -= 1
                    }
                }
                selectedCards = []
            }
        }
    }
    
    private var lastMatchedAt = Date()
    private var deck: [Card] = []
    
    // Extra credit 3: Keep score somehow in your Set game.
    var scores: [Int] = [0, 0]
    var activePlayer: Int? {
        didSet {
            if activePlayer == nil {
                selectedCards = []
            }
        }
    }

    init(initialNumberOfCards: Int) {
        reset()
        dealCards(initialNumberOfCards)
    }
    
    var hasMoreOpenCards: Bool {
        !deck.isEmpty
    }
    
    // MARK: - Intents
    
    mutating func claim(by player: Int?) {
        activePlayer = player
    }
    
    mutating func dealCards(_ numCards: Int) {
        // Extra credit 5: penalize players who chose Deal 3 More Cards when a Set was actually available to be chosen
        if firstThreeMatchingCard != nil {
            // With two players introduced, we regard "deal cards" a shared action between players without penalty.
            // score -= 1
        }
        
        for _ in 0..<numCards {
            if hasMoreOpenCards {
                activeCards.append(deck.remove(at: Int.random(in: 0..<deck.count)))
            }
        }
    }
    
    mutating func tap(card: Card) {
        if mismatchedCards.count == 3 {
            mismatchedCards = []
        }
        
        // If already 3 matched cards, deal 3 more cards to replace them.
        if matchedCards.count == 3 {
            matchedCards.forEach { card in
                if let cardIndex = activeCards.firstIndex(where: { $0.id == card.id }) {
                    if hasMoreOpenCards {
                        // R8: Replace those 3 matching Set cards with new ones.
                        activeCards[cardIndex] = deck.remove(at: Int.random(in: 0..<deck.count))
                    } else {
                        // R8: If the deck is empty, the space of the matched cards will be released to the remaining cards.
                        activeCards.remove(at: cardIndex)
                    }
                }
            }
            // R8: If the touched card was part of a matching Set, then select no card
            if matchedCards.contains(where: { $0.id == card.id }) {
                matchedCards = []
                return
            } else {
                matchedCards = []
            }
        }
        
        if let selectedCardIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
            selectedCards.remove(at: selectedCardIndex)
        } else {
            selectedCards.append(card)
        }
    }
    
    mutating func reset() {
        deck = []
        for variant1 in Card.Variant.allCases {
            for variant2 in Card.Variant.allCases {
                for variant3 in Card.Variant.allCases {
                    for variant4 in Card.Variant.allCases {
                        deck.append(Card(variant1: variant1, variant2: variant2, variant3: variant3, variant4: variant4))
                    }
                }
            }
        }
        deck.shuffle()
        
        activeCards = []
        selectedCards = []
        matchedCards = []
        mismatchedCards = []
        scores = [0, 0]
    }
    
    // Extra credit 6: Add a “cheat” button to your UI.
    mutating func cheat() {
        selectedCards = []
        mismatchedCards = []
        if let (card1, card2, card3) = firstThreeMatchingCard {
            matchedCards = [card1, card2, card3]
        }
    }
    
    // MARK: - Private methods
    
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
    
    private var firstThreeMatchingCard: (Card, Card, Card)? {
        for card1 in activeCards {
            for card2 in activeCards {
                for card3 in activeCards {
                    if card1.id != card2.id && card1.id != card3.id && card2.id != card3.id &&
                        match(card1: card1, card2: card2, card3: card3) {
                        return (card1, card2, card3)
                    }
                }
            }
        }
        return nil
    }
}

