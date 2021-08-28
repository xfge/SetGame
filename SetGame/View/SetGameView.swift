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
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card: card,
                         borderColor: game.borderColor(for: card),
                         borderWidth: game.borderWidth(for: card))
                    .padding(CGFloat(40 / (game.cards.count + 1) + 3))
                    .onTapGesture {
                        game.tap(card: card)
                    }
            }
            HStack {
                Text("\(game.score(for: 0))")
                    .foregroundColor(Color.playerColor0)
                    .rotationEffect(Angle(degrees: 180))
                Text(":")
                    .padding(2)
                Text("\(game.score(for: 1))")
                    .foregroundColor(Color.playerColor1)
            }
            .font(.title2)
            bottomBar
        }
        .padding(.horizontal)
    }
    
    var headerBar: some View {
        ZStack {
            HStack {
                Button(action: {
                    game.restart()
                }, label: {
                    Text("Restart")
                })
                .foregroundColor(game.isDealCardsEnabled ? .playerColor0 : .secondary)
                .disabled(!game.isDealCardsEnabled)
                Spacer()
            }
            foundButton(for: 0)
        }
        .foregroundColor(Color.playerColor0)
        .rotationEffect(Angle(degrees: 180))
    }
    
    var bottomBar: some View {
        ZStack {
            HStack {
                Button(action: {
                    game.cheat()
                }, label: {
                    Text("Cheat")
                })
                Spacer()
                Button(action: {
                    game.dealCards()
                }, label: {
                    Text("Deal cards")
                })
                .disabled(!game.isDealCardsEnabled)
            }
            foundButton(for: 1)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel(initialNumberOfCards: 20)
        SetGameView(game: game)
    }
}
