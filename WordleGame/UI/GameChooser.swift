//
//  GameList.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-27.
//

import SwiftUI
import SwiftData

struct GameChooser: View {
    // MARK: Data OWNED by me
    @Environment(\.modelContext) private var context
    
    @Query private var games: [Wordle] = []
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
        .onChange(of: selection?.attempts.count) {
            if let selection {
                if let index = games.firstIndex(of: selection) {
                    games.remove(at: index)
                    games.insert(selection, at: 0)
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            addSampleGames()
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            context.insert(Wordle(masterCode: Code(kind: .master(isHidden: true), "HELLO")))
            context.insert(Wordle(masterCode: Code(kind: .master(isHidden: true), "BYE")))
        }
    }
}


#Preview(traits: .modifier(WordleDataPreview())) {
    GameChooser()
}
