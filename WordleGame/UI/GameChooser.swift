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
    @State private var selection: Wordle? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection: $selection, games: $games)
                .navigationTitle("Wordle Games")
        } detail: {
            if let selection {
                WordleView(game: selection)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            addSampleGames()
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(Wordle(masterCode: Code(kind: .master(isHidden: true), "HELLO")))
            games.append(Wordle(masterCode: Code(kind: .master(isHidden: true), "BYE")))
        }
    }
}

#Preview {
    GameChooser()
}
