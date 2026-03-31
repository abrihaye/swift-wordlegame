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
    
    // MARK: Data Shared with Me
    let game: Wordle
    
    // MARK: Data Owned by Me
    
    //@Binding var game: Wordle
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var checker = UITextChecker()
    @State private var activeRevealIndex: Int = -1
    @State private var masterWordCount: Int?
    
    let pegChoices: [String] = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    // MARK: - Body
    var body: some View {
        VStack {
            if !restarting {
                resetButton
                // Not Restarting
                CodeView(code: game.masterCode)
                    .transaction { transaction in
                        if restarting {
                            transaction.animation = nil
                        }
                    }
                ScrollView {
                    if !game.isOver {
                        CodeView(code: game.guess, selection: $selection) {
                            Button("Guess", action: guess).flexibleFontSystem()
                        }
                        .animation(nil, value: game.attempts.count)
                        .transition(.opacity)
                        .transaction { transaction in
                            if restarting {
                                transaction.animation = nil
                            }
                        }
                        .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                        CodeView(code: game.attempts[index], shouldReveal: index <= activeRevealIndex)
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
            else {
                    HStack {
                        Text("Word Length")
                        TextField("Int between 3 and 6", value: $masterWordCount, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .foregroundStyle(.primary)
                            .onSubmit {
                                if let masterWordCount {
                                    guard masterWordCount >= 3, masterWordCount <= 6 else {
                                        self.masterWordCount = nil
                                        return
                                    }
                                    
                                    let newCode = Code(kind: .master(isHidden: true), words.random(length: masterWordCount) ?? "AWAIT")
                                    game.setMaster(masterCode: newCode)
                                    
                                    withAnimation(.restart) {
                                        restarting = false
                                    }
                                }
                            }
                }
            }
        }
        .onChange(of: words.count, initial: true) {
            getMasterCodeFromWords()
        }
        .onAppear {
            activeRevealIndex = game.attempts.count - 1
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
        Button("Reset", systemImage: "arrow.circlepath") {
            withAnimation(.restart) {
                restarting = true
                activeRevealIndex = -1
                selection = 0
                game.reset()
            }
        }
    }
    
    func getMasterCodeFromWords() {
        print("Hello There")
        var newMasterCode = Code(kind: .master(isHidden: true), "")
        if game.attempts.count == 0 {
            if words.count == 0 {
                newMasterCode.word = "AWAIT"
            } else {
                newMasterCode.word = words.random(length: Int.random(in: 3...6)) ?? "ERROR"
            }
            game.setMaster(masterCode: newMasterCode)
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

#Preview {
    @Previewable @State var game = Wordle(masterCode: Code(kind: .master(isHidden: false), "HELLO"))
    WordleView(game: game)
}
