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
            HStack {
                Text("Set")
                Spacer()
                Button(action: {
                    game.restart()
                }, label: {
                    Text("Restart")
                })
            }

            let cardPadding = CGFloat(40 / (game.cards.count + 1) + 3)
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card: card,
                         isSelected: game.isSelected(card: card),
                         isMatched: game.isMatched(card: card))
                    .padding(cardPadding)
                    .onTapGesture {
                        game.tap(card: card)
                    }
            }
            
            Button(action: {
                game.dealCards()
            }, label: {
                Text("Deal cards")
            })
        }
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel(initialNumberOfCards: 20)
        SetGameView(game: game)
    }
}
