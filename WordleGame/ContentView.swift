//
//  ContentView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-06.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.words) var words: Words
    @State var wordToGuess: String = "AWAIT"
    let wordToTest: String = "HELLO"
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Array(wordToTest.indices), id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .aspectRatio(1, contentMode: .fit)
                        .padding(1)
                        .foregroundStyle(.clear)
                        .overlay {
                            Text(wordToTest[wordToTest.startIndex(by: index)])
                        }
                }
            }
            Text(wordToGuess)
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button ("Update Master") {
                wordToGuess = words.random(length: 5) ?? "ERROR"
            }
        }
        .padding()
//        .onChange(of: words.count, initial: true) {
//            if words.count == 0 {
//                wordToGuess = "AWAIT"
//            } else {
//                wordToGuess = words.random(length: 5) ?? "ERROR"
//            }
//        }
    }
}

#Preview {
    ContentView()
}
