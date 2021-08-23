//
//  SetGameView.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        VStack {
            headerBar
            let cardPadding = CGFloat(40 / (game.cards.count + 1) + 3)
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                let matchingStatus = game.matchingStatus(for: card)
                CardView(card: card, matchingStatus: matchingStatus)
                    .padding(cardPadding)
                    .opacity(matchingStatus == .hidden ? 0 : 1)
                    .onTapGesture {
                        game.tap(card: card)
                    }
            }
            bottomBar
        }
        .padding(.horizontal)
    }
    
    var headerBar: some View {
        HStack {
            Text("Set").font(.title)
            Spacer()
            Button(action: {
                game.restart()
            }, label: {
                Text("Restart")
            })
        }
    }
    
    var bottomBar: some View {
        Button(action: {
            game.dealCards()
        }, label: {
            Text("Deal cards")
        })
        .disabled(game.isDealCardsDisabled)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel(initialNumberOfCards: 20)
        SetGameView(game: game)
    }
}
