//
//  GameList.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-27.
//

import SwiftUI

struct GameList: View {
    @State private var games: [Wordle] = []
    
    var body: some View {
        List(games, id: \.id) { game in
            let lastAttempt = game.attempts.last ?? Code(kind: .attempt([.exact, .exact, .exact, .exact]), "ATTEMPT")
            CodeView(code: lastAttempt)
        }
        .onAppear {
            games.append(Wordle(masterCode: Code(kind: .master(isHidden: false), "HELLO")))
            games.append(Wordle(masterCode: Code(kind: .master(isHidden: false), "BYE")))
        }
    }
}

#Preview {
    //GameList()
}
