//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var model: SetGame
    
    init() {
        model = SetGame(initialNumberOfCards: 0)
    }
    
    var allCards: [Card] {
        model.allCards
    }
    
    var cards: [Card] {
        model.activeCards
    }
    
    func score(for player: Int) -> Int {
        model.scores[player]
    }
    
    var isDealCardsEnabled: Bool {
        model.hasMoreOpenCards
    }
    
    // MARK: - Intents

    func tap(card: Card) {
        model.tap(card: card)
    }
    
    func restart() {
        model.reset()
    }
    
    func dealCards(_ numberOfCards: Int = 3) -> [Card] {
        model.dealCards(numberOfCards)
    }
    
    func cheat() {
        model.cheat()
    }
    
    func claim(by player: Int?) {
        model.claim(by: player)
    }
    
    enum PlayerStatus {
        case none, blocked, exclusive
    }
    
    enum MatchingStatus {
        case none, selected, matched, mismatched
    }
    
    // MARK: - UI property utils
    
    func status(of player: Int) -> PlayerStatus {
        if let activePlayer = model.activePlayer {
            return player == activePlayer ? .exclusive : .blocked
        } else {
            return .none
        }
    }
    
    func borderWidth(for card: Card) -> CGFloat {
        switch matchingStatus(for: card) {
        case .selected:
            return 4
        case .matched, .mismatched:
            return 2.5
        default:
            return 1.5
        }
    }
    
    func borderColor(for card: Card) -> Color {
        switch matchingStatus(for: card) {
        case .selected:
            return .blue
        case .matched:
            return .green
        case .mismatched:
            return .red
        default:
            return .gray
        }
    }
    
    // MARK: - Private methods
    
    private func matchingStatus(for card: Card) -> MatchingStatus {
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
}

// In any complexity trade-off between View and ViewModel, make your View simpler. The extra UI property/state is calculated here in ViewModel.
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
