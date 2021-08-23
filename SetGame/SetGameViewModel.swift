//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var model: SetGame
    
    init(initialNumberOfCards: Int = 12) {
        model = SetGame(initialNumberOfCards: initialNumberOfCards)
    }
    
    // All active/open cards
    var cards: [Card] {
        model.activeCards
    }
    
    func isSelected(card: Card) -> Bool {
        model.selectedCards.contains(where: { $0.id == card.id })
    }
    
    func isMatched(card: Card) -> Bool {
        model.matchedCards.contains(where: { $0.id == card.id })
    }
    
    // MARK: - Intents

    func tap(card: Card) {
        if !isMatched(card: card) {
            model.tap(card: card)
        }
    }
    
    func restart() {
        model.reset()
        model.dealCards(12)
    }
    
    func dealCards() {
        model.dealCards(3)
    }
}
