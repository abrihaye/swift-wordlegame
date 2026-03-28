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
        List {
            VStack {
                ForEach(games, id : \.id) { game in
                    let lastAttempt = game.attempts.last ?? Code(kind: .attempt([.exact, .exact, .exact, .exact]), "TEST")
                    CodeView(code: lastAttempt)
                        .frame(maxHeight: 50)
                    Text("^[\(game.attempts.count) Attempt](inflect: true)")
                }
            }
            .listRowSeparator(.hidden)
            
        }
        .onAppear {
            games.append(Wordle(masterCode: Code(kind: .master(isHidden: false), "HELLO"),
                                attempts: [Code(kind : .attempt([.exact, .exact, .exact, .exact]), "BANNED")]
                               ))
            games.append(Wordle(masterCode: Code(kind: .master(isHidden: false), "BYE")))
        }
    }
}

#Preview {
    GameList()
}
