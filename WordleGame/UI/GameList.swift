//
//  GameList.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-04-01.
//

import SwiftUI

struct GameList: View {
    @Binding var selection: Wordle?
    @Binding var games: [Wordle]
    
    @State private var matchColorPicker: [Color] = [.green, .orange, .gray]
    @State private var showSettings: Bool = false
    @Environment(\.settings) var mySettings
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    deleteButton(for: game)
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
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .navigationTitle("Wordle Games")
        .listStyle(.plain)
        .toolbar {
            AddButton()
            EditButton()
            Button("Settings", systemImage: "gear") {
                showSettings = true
            }
        }
        .sheet(isPresented: $showSettings) {
            @Bindable var settings = mySettings
            NavigationStack {
                Form {
                    Section("Match Color") {
                        ColorPicker("Exact Match", selection: $settings.exactColor)
                        ColorPicker("Inexact Match", selection: $settings.inexactColor)
                        ColorPicker("No Match", selection: $settings.nomatchColor)
                    }
                }
                Button("Reset to Default") {
                    mySettings.setToDefaults()
                }
                .navigationTitle("Settings")
                .toolbar {
                    Button("Done", systemImage: "checkmark") {
                        showSettings = false
                    }
                }
            }
        }
    }
    
    func AddButton() -> some View {
        Button("Add", systemImage: "plus") {
            let newGame = Wordle(masterCode: Code(kind: .master(isHidden: true)))
            games.append(newGame)
        }
    }
    
    func deleteButton(for game: Wordle) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll {$0 == game}
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: Wordle?
    @Previewable @State var games: [Wordle] = [Wordle(masterCode: Code(kind: .master(isHidden: true), "HELLO")),
                                               Wordle(masterCode: Code(kind: .master(isHidden: true), "BYE"))]
    GameList(selection: $selection, games: $games)
}
