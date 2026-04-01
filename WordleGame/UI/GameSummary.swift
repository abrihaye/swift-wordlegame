//
//  GameSummary.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-28.
//

import SwiftUI

struct GameSummary: View {
    let game: Wordle
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if let lastAttempt = game.attempts.last {
                    CodeView(code: lastAttempt, shouldReveal: true)
                } else {
                    CodeView(code: Code(kind: .master(isHidden: true), count: game.masterCode.pegs.count))
                }
            }
            .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) Attempt](inflect: true)")
        }
    }
}

#Preview {
    List {
        GameSummary(game: Wordle(masterCode: Code(kind: .master(isHidden: false), "HELLO"),
                                 attempts: [Code(kind : .attempt([.exact, .exact, .exact, .exact]), "BANNED")]))
    }
    List {
        GameSummary(game: Wordle(masterCode: Code(kind: .master(isHidden: false), "BYE"),
                                 attempts: [Code(kind : .attempt([.exact, .exact, .exact, .exact]), "TESTED")]))
    }
    .listStyle(.plain)
}
