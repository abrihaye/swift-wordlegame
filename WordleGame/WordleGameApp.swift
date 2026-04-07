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
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: Wordle.self)
        }
    }
}
