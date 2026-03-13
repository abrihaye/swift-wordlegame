//
//  WordleView 2.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-11.
//


import SwiftUI

struct WordleView: View {
    // MARK: Data IN
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var game: Wordle = Wordle(masterCode: Code(kind: .master(isHidden: true), "HELLO"))
    @State private var selection: Int = 0
    @State private var checker = UITextChecker()
    
    let keyboard: [String] = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    // MARK: - Body
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        view(for: game.attempts[index])
                }
            }
            KeyboardChooser(for: keyboard) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            } deleteCb: {
                selection = selection == 0 ? game.masterCode.pegs.count - 1: selection - 1
                game.resetGuessPeg(at: selection)
            }
        }
        .padding(1)
        .onChange(of: words.count, initial: true) {
            if words.count == 0 {
                game.masterCode = Code(kind: .master(isHidden: true), "AWAIT")
            } else {
                game.masterCode = Code(kind: .master(isHidden: true), (words.random(length: 5) ?? "ERROR"))
            }
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                if checker.isAWord(game.guess.word) {
                    game.attemptGuess()
                }
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    @ViewBuilder
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code, selection: $selection)
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    if (code.kind == .guess) {
                        guessButton
                    }
                }
        }
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
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
