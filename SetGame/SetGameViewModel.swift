//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var model: SetGame = SetGame()
    
    init() {
        model.dealCards(12)
    }
    
    init(initialNumberOfCards: Int) {
        model.dealCards(initialNumberOfCards)
    }
    
    // All active/open cards
    var cards: [Card] {
        model.activeCards
    }
    
    func isSelected(card: Card) -> Bool {
        model.selectedCards.contains(where: { $0.id == card.id })
    }
    
    // MARK: - Intents

    func tap(card: Card) {
        model.tap(card: card)
    }

}
