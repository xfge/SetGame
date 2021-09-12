//
//  SetGameView.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    @State private var dealt: [Int] = []
    @Namespace private var dealingNamespace

    private func dealAnimation(forIndex index: Int, inTotalOf total: Int) -> Animation {
        let delay = Double(index) / Double(total) * (total <= 3 ?  CardConstants.totalDealDurationFast : CardConstants.totalDealDurationSlow)
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func deal(_ card: Card) {
        dealt.append(card.id)
    }
    
    private func isUndealt(_ card: Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    var body: some View {
        VStack {
            headerBar
            AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
                if isUndealt(card) {
                    Color.clear
                } else {
                    CardView(card: card,
                             borderColor: game.borderColor(for: card),
                             borderWidth: game.borderWidth(for: card))
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .padding(CGFloat(40 / (game.cards.count + 1) + 3))
                        .onTapGesture {
                            game.tap(card: card)
                        }
                }
            }
            deckBar
            bottomBar
        }
        .padding(.horizontal)
    }
    
    var deckBar: some View {
        HStack {
            deckCards
                .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
            Spacer()
            Rectangle()
                .cornerRadius(10)
                .foregroundColor(.clear)
                .aspectRatio(2/3, contentMode: .fit)
                .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        }
        .padding(.horizontal, 4)
    }
    
    var deckCards: some View {
        ZStack {
            ForEach(game.allCards.filter(isUndealt)) { card in
                Rectangle()
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .cornerRadius(10)
                    .aspectRatio(CardConstants.aspectRatio, contentMode: .fit)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        if game.isDealCardsEnabled {
                            let dealtCards = game.dealCards(game.cards.count == 0 ? 12 : 3)
                            for (index, card) in dealtCards.enumerated() {
                                withAnimation(dealAnimation(forIndex: index, inTotalOf: dealtCards.count)) {
                                    deal(card)
                                }
                            }
                        }
                    }
            }
        }
    }
    
//    var discardedCards: some View {
//        ZStack {
//            ForEach(game.allCards) { card in
//                CardView(card: card, borderColor: .gray, borderWidth: 1)
//                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
//            }
//        }
//    }
    
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
                Button(action: {
                    withAnimation {
                        dealt = []
                        game.restart()
                    }
                }, label: {
                    Text("Restart")
                })
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
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDurationFast: Double = 1
        static let totalDealDurationSlow: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}
