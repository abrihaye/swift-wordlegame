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
                .onDelete { offsets in
                    print(offsets)
                    games.remove(atOffsets: offsets)
                }
                .onMove {offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
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
