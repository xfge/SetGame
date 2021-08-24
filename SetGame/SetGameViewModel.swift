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
    
    var score: Int {
        model.score
    }
    
    var isDealCardsEnabled: Bool {
        model.hasMoreOpenCards
    }
    
    func matchingStatus(for card: Card) -> MatchingStatus {
        if model.matchedCards.contains(where: { $0.id == card.id }) {
            return .matched
        } else if model.mismatchedCards.contains(where: { $0.id == card.id }) {
            return .mismatched
        } else if model.selectedCards.contains(where: { $0.id == card.id }) {
            return .selected
        } else {
            return .none
        }
    }
    
    // MARK: - Intents

    func tap(card: Card) {
        model.tap(card: card)
    }
    
    func restart() {
        model.reset()
        model.dealCards(12)
    }
    
    func dealCards() {
        model.dealCards(3)
    }
    
    enum MatchingStatus {
        case none, selected, matched, mismatched
    }
}

extension Card {
    var color: Color {
        switch self.variant1 {
        case .option1:
            return .green
        case .option2:
            return .purple
        case .option3:
            return .red
        }
    }
    
    enum Shape {
        case diamond, squiggle, oval
    }
    
    var shape: Shape {
        switch self.variant2 {
        case .option1:
            return .diamond
        case .option2:
            return .squiggle
        case .option3:
            return .oval
        }
    }
    
    
    enum Shading {
        case filled, shaded, stroked
    }
    
    var shading: Shading {
        switch self.variant3 {
        case .option1:
            return .filled
        case .option2:
            return .shaded
        case .option3:
            return .stroked
        }
    }

    var symbolCount: Int {
        switch self.variant4 {
        case .option1:
            return 1
        case .option2:
            return 2
        case .option3:
            return 3
        }
    }
}
