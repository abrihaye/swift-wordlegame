//
//  GameList.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-27.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data OWNED by me
    @State private var games: [Wordle] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(games, id : \.id) { game in
                    NavigationLink {
                        WordleView(game: game)
                    } label : {
                        GameSummary(game: game)
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(Wordle(masterCode: Code(kind: .master(isHidden: false), "HELLO")))
            games.append(Wordle(masterCode: Code(kind: .master(isHidden: false), "BYE")))
        }
    }
}

#Preview {
    GameChooser()
}
