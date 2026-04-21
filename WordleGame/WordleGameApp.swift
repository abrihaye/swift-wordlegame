//
//  WordleGameApp.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-06.
//

import SwiftUI
import SwiftData

@main
struct WordleGameApp: App {
    @Environment(\.words) var words
    @Environment(\.settings) var settings
    
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: Wordle.self)
                .onAppear {
                    Task {
                        await words.load(settings.language)
                        await words.reloadAll()
                    }
                }
                .onChange(of: settings.language) { _, newValue in
                    Task {
                        await words.load(newValue)
                    }
                }
        }
    }
}
