//
//  WordleView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-06.
//

import SwiftUI

struct WordleView: View {
    @Environment(\.words) var words: Words
    @State var masterWord: String = "AWAIT"
    
    var body: some View {
        VStack {
            HStack {
                view(for: masterWord)
            }
            Button ("Update Master") {
                masterWord = words.random(length: 5) ?? "ERROR"
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
    
    @ViewBuilder
    func view(for word: String) -> some View {
        let wordArray = Array(word)
        HStack {
            ForEach(wordArray.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(1)
                    .foregroundStyle(.black)
                    .overlay {
                        Text(String(wordArray[index]))
                            .foregroundStyle(Color.white)
                    }
            }
        }
    }
}

#Preview {
    WordleView()
}
