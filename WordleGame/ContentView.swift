//
//  ContentView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-06.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.words) var words: Words
    
    var body: some View {
        VStack {
            Text(words.random(length: 4) ?? "None")
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
        .onChange(of: words.count) {
            
        }
    }
}

#Preview {
    ContentView()
}
