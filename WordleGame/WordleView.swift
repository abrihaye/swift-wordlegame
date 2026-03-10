//
//  WordleView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-06.
//

import SwiftUI

struct WordleView: View {
    @Environment(\.words) var words
    @State var masterWord: String = "AWAIT"
    let attempts: [String] = ["VERRE", "BOIRE", "TASSE"]
    
    let keyboardRows: [String] = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    var body: some View {
        VStack {
            HStack {
                view(for: masterWord, which: .master)
                    .onChange(of: words.count, initial: true) {
                        if words.count == 0 {
                            masterWord = "AWAIT"
                        } else {
                            masterWord = words.random(length: 5) ?? "ERROR"
                        }
                    }
            }
            ForEach(attempts.indices, id: \.self) { index in
                HStack {
                    view(for: attempts[index], which: .guess)
                }
            }
            Spacer()
            keyboard
        }
        .padding(2)
    }
    
    var keyboard: some View {
        VStack {
            ForEach(keyboardRows.indices, id: \.self) { index in
                HStack {
                    let currentRow = keyboardRows[index].map { String($0) }
                    ForEach(currentRow.indices, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 5)
                            .overlay {
                                Button {
                                    print(currentRow[index])
                                } label: {
                                    Text((currentRow[index]))
                                        .font(.system(size: 30.0))
                                        .minimumScaleFactor(2/80.0)
                                        .foregroundStyle(.white)
                                }
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 30.0, height: 30.0)
                    }
                }
            }
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                masterWord = words.random(length: 5) ?? "ERROR"
            }
        }
        .font(.system(size: 80.0))
        .minimumScaleFactor(8/80.0)
    }
    
    @ViewBuilder
    func view(for word: String, which kind: Code.Kind) -> some View {
        let wordArray = Array(word)
        HStack {
            ForEach(wordArray.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(kind == .master ? .black: .gray)
                    .overlay {
                        Text(String(wordArray[index]))
                            .foregroundStyle(Color.white)
                            .font(.system(size: 30))
                            .minimumScaleFactor(0.1)
                    }
            }
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    if (kind == .guess) {
                        guessButton
                    }
                }
        }
    }
    
}

#Preview {
    WordleView()
}
