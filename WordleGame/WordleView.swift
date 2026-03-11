//
//  WordleView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-06.
//

import SwiftUI

struct WordleView: View {
    // MARK: Data IN
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var game: Wordle = Wordle(masterCode: Code(kind: .master(isHidden: true), pegs: "HELLO".map{String($0)}))
    
    @State var masterWord: String = "AWAIT"
    
    let guess: Code = Code(kind: .guess, pegs: "HOTEL".map{String($0)})
    
//  let attempts: [Code] = [Code(kind: .attempt([.nomatch, .exact, .exact, .nomatch, .inexact]), pegs: "TESTE".map{String($0)})]
    
    let keyboardRows: [String] = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    // MARK: - Body
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: guess)
                ForEach(game.attempts.indices, id: \.self) { index in
                        view(for: game.attempts[index])
                }
            }
            keyboard
        }
        .padding()
        .onChange(of: words.count, initial: true) {
            if words.count == 0 {
                masterWord = "AWAIT"
            } else {
                masterWord = words.random(length: 5) ?? "ERROR"
            }
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.guess = guess
                game.attemptGuess()
            }
        }
        .font(.system(size: 80.0))
        .minimumScaleFactor(8/80.0)
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
    
    
    
    @ViewBuilder
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code)
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
//                    if let matches = code.matches {
//                        print("Match")
//                    } else
                    if (code.kind == .guess) {
                        guessButton
                    }
                }
        }
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    WordleView()
}
