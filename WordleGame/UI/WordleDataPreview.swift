//
//  WordleDataPreview.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-04-08.
//
import SwiftUI
import SwiftData

struct WordleDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> Context {
        let container = try ModelContainer(for: Wordle.self)
        // Possible to add some data here
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}
