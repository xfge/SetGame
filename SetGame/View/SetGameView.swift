//
//  SetGameView.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    @State private var isRepositioningDelay = false
    
    @State private var dealt: [Int] = []
    @Namespace private var dealingNamespace

    @State private var discarded: [Int] = []
    @Namespace private var discardingNamespace
    
    private var repositionDelay: Double {
        isRepositioningDelay ? CardConstants.totalDiscardDuration : 0
    }
    
    private func dealAnimation(forIndex index: Int, inTotalOf total: Int, duration: Double, extraDelay: Double = 0) -> Animation {
        let delay = Double(index) / Double(total) * duration + extraDelay
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func deal(_ card: Card) {
        dealt.append(card.id)
    }
    
    private func isUndealt(_ card: Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func discard(_ card: Card) {
        discarded.append(card.id)
    }
    
    private func isDiscarded(_ card: Card) -> Bool {
        discarded.contains(card.id)
    }

    private func zIndex(of card: Card) -> Double {
        if game.discardedCards.contains(where: { $0.id == card.id }) {
            return Double(game.discardedCards.firstIndex(where: { $0.id == card.id }) ?? 0)
        } else {
            return -Double(game.allCards.firstIndex(where: { $0.id == card.id }) ?? 0)
        }
    }
    
    var body: some View {
        VStack {
            headerBar
            openCards
            deckBar
            bottomBar
        }
        .padding(.horizontal)
    }
    
    var openCards: some View {
        GeometryReader { geometry in
            AspectVGrid(items: game.openCards, aspectRatio: CardConstants.aspectRatio) { card in
                if isUndealt(card) {
                    Color.clear
                } else {
                    let status = game.matchingStatus(for: card)
                    CardView(card: card,
                             borderColor: game.borderColor(for: card),
                             borderWidth: game.borderWidth(for: card))
                        .zIndex(zIndex(of: card))
                        .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace, isSource: false)
                        .padding(CGFloat(40 / (game.openCards.count + 1) + 3))
                        .rotationEffect(Angle.degrees(status == .matched || status == .pendingDiscard ? 360 : 0))
                        .animation(.easeInOut(duration: CardConstants.matchingAnimationDuration), value: status)
                        .scaleEffect(status == .mismatched ? CardConstants.mismatchingAnimationScale : 1)
                        .animation(.easeInOut(duration: CardConstants.mismatchingAnimationDuration), value: status)
                        .onTapGesture {
                            withAnimation {
                                discardMatchedCards()
                                game.tap(card: card)
                            }
                        }
                }
            }
            .animation(.default.delay(repositionDelay), value: game.openCards)
        }
    }
    
    var deckBar: some View {
        HStack {
            deckCards
                .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
            Spacer()
            discardedCards
                .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        }
        .padding(.horizontal, 4)
    }
    
    var deckCards: some View {
        ZStack {
            ForEach(game.allCards.filter(isUndealt)) { card in
                CardView(card: card, isFaceUp: false)
                    .rotationEffect(Angle.degrees(game.rotation(for: card) ?? 0.0))
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .onTapGesture {
                        if game.isDealCardsEnabled {
                            withAnimation {
                                discardMatchedCards()
                                dealCards()
                            }
                        }
                    }
                    .onLongPressGesture {
                        withAnimation {
                            dealt = []
                            game.restart()
                        }
                    }
            }
        }
    }
    
    var discardedCards: some View {
        ZStack {
            ForEach(game.discardedCards.filter(isDiscarded)) { card in
                CardView(card: card)
                    .rotationEffect(Angle.degrees(game.rotation(for: card) ?? 0.0))
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
            }
        }
    }
    
    var scoreBar: some View {
        HStack {
            Text("\(game.score(for: 1))")
                .foregroundColor(Color.playerColor1)
                .rotationEffect(Angle(degrees: 180))
            Text(":")
                .padding(2)
            Text("\(game.score(for: 0))")
                .foregroundColor(Color.playerColor0)
        }
        .font(.title3)
    }
    
    var headerBar: some View {
        ZStack {
            HStack {
                Spacer()
                foundButton(for: 0)
            }
            scoreBar
        }
        .foregroundColor(Color.playerColor0)
        .rotationEffect(Angle(degrees: 180))
    }
    
    var bottomBar: some View {
        ZStack {
            HStack {
                Spacer()
                foundButton(for: 1)
            }
            Button(action: {
                game.cheat()
            }, label: {
                Text("Cheat")
            })
        }
        .foregroundColor(Color.playerColor1)
    }
    
    func foundButton(for player: Int) -> some View {
        let disabled = game.status(of: player) == .blocked
        let playerColor: Color = player == 0 ? .playerColor0 : .playerColor1
        let color: Color = disabled ? .secondary : playerColor
        let text = game.status(of: player) == .exclusive ? "Your turn." : "Found!"
        
        return Button(action: {
            game.claim(by: player)
        }, label: {
            Text(text)
        })
        .foregroundColor(color)
        .disabled(disabled)
    }
    
    private func discardMatchedCards() {
        isRepositioningDelay = game.matchedCardsPendingDiscard != nil
        if let pendingDiscardCards = game.matchedCardsPendingDiscard {
            game.discard(pendingDiscardCards)
            for (index, card) in pendingDiscardCards.enumerated() {
                withAnimation(dealAnimation(forIndex: index, inTotalOf: pendingDiscardCards.count, duration: CardConstants.totalDiscardDuration)) {
                    discard(card)
                }
            }
            game.remove(pendingDiscardCards)
        }
    }
    
    private func dealCards() {
        let dealtCards = game.deal(game.openCards.count == 0 ? 12 : 3)
        let duration = dealtCards.count <= 3 ? CardConstants.totalDealDurationFast : CardConstants.totalDealDurationSlow
        for (index, card) in dealtCards.enumerated() {
            withAnimation(dealAnimation(forIndex: index, inTotalOf: dealtCards.count, duration: duration, extraDelay: repositionDelay)) {
                deal(card)
            }
        }
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDurationFast: Double = 0.75
        static let totalDealDurationSlow: Double = 1.5
        static let totalDiscardDuration: Double = 1.0
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
        static let matchingAnimationDuration: Double = 1
        static let mismatchingAnimationDuration: Double = 0.5
        static let mismatchingAnimationScale: CGFloat = 0.9
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}
