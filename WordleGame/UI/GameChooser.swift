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
    @State private var selection: Wordle? = nil
    @State private var sortOption: GameList.SortOption = .recent
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Sort By", selection: $sortOption) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            GameList(selection: $selection)
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
    }
}


#Preview(traits: .swiftData) {
    GameChooser()
}
