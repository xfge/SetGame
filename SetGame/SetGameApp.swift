//
//  SetGameApp.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

@main
struct SetGameApp: App {
    var game = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
