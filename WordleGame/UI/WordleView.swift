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
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: Data Shared with Me
    let game: Wordle
    
    // MARK: Data Owned by Me
    
    //@Binding var game: Wordle
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var checker = UITextChecker()
    @State private var activeRevealIndex: Int = -1
    @State private var masterWordCount: Int?
    
    @State private var attemptFailed: Int = 0
    
    let pegChoices: [String] = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    
    // MARK: - Body
    var body: some View {
        VStack {
            if !restarting {
                CodeView(code: game.masterCode)
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                ScrollView {
                    if !game.isOver {
                        CodeView(code: game.guess, selection: $selection) {
                            Button("Guess", action: guess).flexibleFontSystem()
                        }
                        .modifier(ShakeEffect(animatableData: CGFloat(attemptFailed)))
                        .animation(nil, value: game.attempts.count)
                        .transition(.opacity)
                        .transaction { transaction in
                            if restarting {
                                transaction.animation = nil
                            }
                        }
                        .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts.reversed(), id: \.pegs) { attempt in
                        if let index = game.attempts.firstIndex(of: attempt) {
                            CodeView(code: attempt, shouldReveal: index <= activeRevealIndex)
                                .transition(AnyTransition.asymmetric(
                                    insertion: game.isOver ? .opacity : .move(edge: .top),
                                    removal: .move(edge: .trailing))
                                )
                        }
                        
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
                                
                                setMasterFromWords(masterWordCount)
                                withAnimation(.restart) {
                                    restarting = false
                                    game.startTimer()
                                }
                            }
                        }
                }
            }
        }
        .onChange(of: words.count, initial: true) {
            setMasterFromWords()
        }
        .onAppear {
            activeRevealIndex = game.attempts.count - 1
            game.startTimer()
        }
        .onDisappear {
            game.pauseTimer()
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active: game.startTimer()
            case .background: game.pauseTimer()
            default: break
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(game.language.code)")
            }
            ToolbarItem(placement: .topBarTrailing) {
                resetButton
            }
            ToolbarItem(placement: .topBarTrailing) {
                ElapsedTimeView(startTime: game.startTime,
                                endTime: game.endTime,
                                elapsedTime: game.elapsedTime)
                .monospaced(true)
                .lineLimit(1)
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
        Button("Reset", systemImage: "arrow.circlepath") {
            withAnimation(.restart) {
                activeRevealIndex = -1
                selection = 0
                game.reset()
            } completion: {
                withAnimation(.restart) {
                    restarting = true
                }
            }
        }
    }
    
    func setMasterFromWords(_ count: Int? = nil) {
        let currentWord = game.masterCode._pegs
        
        print(words.language.code, game.language)
        if currentWord.contains("_") || currentWord == "AWAIT" {
            let newMasterCode = Code(kind: .master(isHidden: true), "")
            if game.attempts.count == 0 {
                if words.count == 0 {
                    newMasterCode._pegs = "AWAIT"
                } else {
                    if let count {
                        newMasterCode._pegs = words.random(length: count, in: game.language) ?? "ERROR"
                    } else {
                        newMasterCode._pegs = words.random(length: Int.random(in: 3...6), in: game.language) ?? "ERROR"
                    }
                }
                print(newMasterCode)
                game.setMaster(masterCode: newMasterCode)
            }
        } else {
            print("MasterCode already set")
        }
    }
    
    func guess() {
        if !game.guess.pegs.contains(Code.missingPeg),
//        checker.isAWord(game.guess._pegs.lowercased(), in: game.language.code) ||
         words.contains(game.guess._pegs.lowercased(), in: game.language)
        {
            withAnimation(Animation.guess) {
                selection = 0
                game.attemptGuess()
            } completion : {
                withAnimation {
                    activeRevealIndex = game.attempts.count - 1
                }
            }
        } else {
            withAnimation(.default) {
                attemptFailed = 1
            } completion: {
                attemptFailed = 0
            }
        }
    }
            
    
}

#Preview(traits: .modifier(WordleDataPreview())) {
    @Previewable @State var game = Wordle(masterCode: Code(kind: .master(isHidden: false), "HELLO"))
    NavigationStack {
        WordleView(game: game)
    }
}
