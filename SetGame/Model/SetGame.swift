//
//  SetGame.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import Foundation

struct SetGame {
    private(set) var allCards: [Card] = []
    private(set) var deck: [Card] = []
    private(set) var discardedCards: [Card] = []
    
    private(set) var openCards: [Card] = []
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
                        lastMatchedAt = Date()
                    }
                } else {
                    mismatchedCards = selectedCards
                    if let player = activePlayer {
                        scores[player] -= 1
                    }
                }
                selectedCards = []
                activePlayer = nil
            }
        }
    }
    
    private var lastMatchedAt = Date()
    
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
    
    @discardableResult
    mutating func dealCards(_ numCards: Int) -> [Card] {
        // Extra credit 5: penalize players who chose Deal 3 More Cards when a Set was actually available to be chosen
        if firstThreeMatchingCard != nil {
            // With two players introduced, we regard "deal cards" a shared action between players without penalty.
            // score -= 1
        }
        
        var dealtCards: [Card] = []
        for _ in 0..<numCards {
            if hasMoreOpenCards {
                dealtCards.append(deck.remove(at: 0))
            }
        }
        openCards.append(contentsOf: dealtCards)
        
        return dealtCards
    }
    
    mutating func tap(card: Card) {
        if mismatchedCards.count == 3 {
            mismatchedCards = []
        }

        if activePlayer != nil {
            if let selectedCardIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
                selectedCards.remove(at: selectedCardIndex)
            } else {
                selectedCards.append(card)
            }
        }
    }

    mutating func remove(_ cards: [Card]) {
        for card in cards {
            if let index = openCards.firstIndex(where: { $0.id == card.id }) {
                openCards.remove(at: index)
            }
            if let index = matchedCards.firstIndex(where: { $0.id == card.id }) {
                matchedCards.remove(at: index)
            }
        }
    }
    
    mutating func discard(_ cards: [Card]) {
        for card in cards {
            discardedCards.append(card)
        }
    }
    
    mutating func reset() {
        allCards = []
        var id = 0
        for variant1 in Card.Variant.allCases {
            for variant2 in Card.Variant.allCases {
                for variant3 in Card.Variant.allCases {
                    for variant4 in Card.Variant.allCases {
                        allCards.append(Card(variant1: variant1, variant2: variant2, variant3: variant3, variant4: variant4, id: id))
                        id += 1
                    }
                }
            }
        }
        
        allCards.shuffle()
        deck = allCards
        
        openCards = []
        discardedCards = []
        selectedCards = []
        matchedCards = []
        mismatchedCards = []
        scores = [0, 0]
    }
    
    // Extra credit 6: Add a “cheat” button to your UI.
    mutating func cheat() {
        if let (card1, card2, card3) = firstThreeMatchingCard {
            matchedCards = [card1, card2, card3]
            selectedCards = []
            mismatchedCards = []
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
        for card1 in openCards {
            for card2 in openCards {
                for card3 in openCards {
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

