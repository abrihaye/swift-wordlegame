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
    @State private var restarting = false
    @State private var checker = UITextChecker()
    @State private var activeRevealIndex: Int?
    
    let pegChoices: [String] = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    // MARK: - Body
    var body: some View {
        VStack {
            resetButton
                .onChange(of: words.count, initial: true) {
                    game.updateMaster(words: words)
                }
            CodeView(code: game.masterCode)
                .transaction { transaction in
                    if restarting {
                        transaction.animation = nil
                    }
                }
            ScrollView {
                if !game.isOver || restarting {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess)
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                    .transaction { transaction in
                        if restarting {
                            transaction.animation = nil
                        }
                    }
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index], shouldReveal: index == activeRevealIndex)
                        .transition(AnyTransition.asymmetric(
                            insertion: game.isOver ? .opacity : .move(edge: .top),
                            removal: .move(edge: .trailing))
                        )
                }
            }
            if !game.isOver {
                keyboard
                    .transition(AnyTransition.keyboard)
            }
        }
        .animation(Animation.bouncy, value: selection)
        .padding()
    }
        
    var keyboard: some View {
        KeyboardChooser(for: pegChoices, dict: game.pegKeys) { peg in
            game.setGuessPeg(peg, at: selection)
            selection = (selection + 1) % game.masterCode.pegs.count
        } deleteCb: {
            selection = selection == 0 ? game.masterCode.pegs.count - 1 : selection - 1
            game.resetGuessPeg(at: selection)
        }
    }
    
    var resetButton: some View {
        Button("Reset") {
            withAnimation(.restart) {
                restarting = true
                game.reset(words: words)
            } completion: {
                withAnimation (.restart) {
                    restarting = false
                }
            }
        }
    }
    
    func guess() {
        withAnimation(Animation.guess) {
            if !game.guess.pegs.contains(""), checker.isAWord(game.guess.word.lowercased()) {
                selection = 0
                game.attemptGuess()
            }
        } completion: {
            withAnimation {
                activeRevealIndex = game.attempts.count - 1
            }
        }
    }
    
}

extension Animation {
    static let wordle = Animation.bouncy(duration: 3)
    static let guess = Animation.wordle
    static let selection = Animation.wordle
    static let restart = Animation.wordle
}

extension AnyTransition {
    static let keyboard = AnyTransition.offset(x: 0, y:200)
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    WordleView()
}
