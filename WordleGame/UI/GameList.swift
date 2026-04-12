//
//  GameList.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-04-01.
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Environment(\.settings) var mySettings
    @Query(sort: \Wordle.timeLastAttempt, order: .reverse) var games: [Wordle]
    @Binding var selection: Wordle?
    
    // MARK: Data Owned by Me
    @State private var matchColorPicker: [Color] = [.green, .orange, .gray]
    @State private var showSettings: Bool = false
    @State private var language: String = "English"
    
    // Look into local
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
                for offset in offsets {
                    modelContext.delete(games[offset])
                }
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
            addButton
            EditButton()
            settingsButton
            
        }
        .onAppear { addSampleGames() }
    }
    
    var settingsButton: some View {
        Button("Settings", systemImage: "gear") {
            showSettings = true
        }
        .sheet(isPresented: $showSettings) {
            @Bindable var settings = mySettings
            NavigationStack {
                Form {
                    Section("Match Color") {
                        ColorPicker("Exact Match", selection: $settings.exactColor)
                        ColorPicker("Inexact Match", selection: $settings.inexactColor)
                        ColorPicker("No Match", selection: $settings.nomatchColor)
                        Button("Reset to Default") {
                            mySettings.setToDefaults()
                        }
                    }
                    Section {
                        Picker("Language", selection: $settings.language) {
                            Text("French").tag("French")
                            Text("English").tag("English")
                        }
                    }
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
    
    var addButton: some View {
        Button("Add", systemImage: "plus") {
            let newGame = Wordle(masterCode: Code(kind: .master(isHidden: true)))
            modelContext.insert(newGame)
        }
    }
    
    func deleteButton(for game: Wordle) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<Wordle>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0 {
            modelContext.insert(Wordle(masterCode: Code(kind: .master(isHidden: true), "HELLO")))
            modelContext.insert(Wordle(masterCode: Code(kind: .master(isHidden: true), "BYE")))
        }
    }
    
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: Wordle?
    NavigationStack {
        GameList(selection: $selection)
    }
}
