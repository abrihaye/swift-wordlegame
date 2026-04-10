//
//  Wordle.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-08.
//

import Foundation
import SwiftData

typealias Peg = String

@Model class Wordle {
    @Relationship(deleteRule: .cascade) var masterCode: Code {
        didSet {
            guess = Code(kind: .guess, count: masterCode.pegs.count)
        }
    }
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade) var attempts: [Code] = []
    var pegKeys: [Peg : Match] = [:]
    var timeLastAttempt: Date = Date.now
    
    var isOver: Bool {
            attempts.last?.pegs == masterCode.pegs
    }
    
    init(masterCode: Code,  attempts: [Code] = []) {
        self.masterCode = masterCode
        self.attempts = attempts
    }
    
    func reset() {
        attempts.removeAll()
        pegKeys.removeAll()
        masterCode = Code(kind: .master(isHidden: true), count: masterCode.pegs.count)
        guess = Code(kind: .guess, count: masterCode.pegs.count)
    }
    
    // Check if the word exists and has the correct size
    func attemptGuess() {
        let matches = guess.match(against: masterCode)
        let attempt = Code(kind: .attempt(matches), guess.word)
        
        // timestamp - Last attempt
        timeLastAttempt = Date.now
        if !attempts.contains(attempt) {
            updatePegChoices(for: guess.pegs, matches: matches)
            attempts.append(attempt)
            
            guess.reset()
            
            if isOver {
                masterCode.kind = .master(isHidden: false)
            }
        }
    }
    
    func setMaster(masterCode: Code) {
        self.masterCode = masterCode
        guess = Code(kind: .guess, count: masterCode.pegs.count)
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func resetGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = Code.missingPeg
    }
    
    func updatePegChoices(for pegs: [Peg], matches: [Match]) {
        for index in 0..<pegs.count {
            let current = pegKeys[pegs[index]] ?? .notTried
            
            if current < matches[index] {
                pegKeys[pegs[index]] = matches[index]
            }
        }
    }
}

