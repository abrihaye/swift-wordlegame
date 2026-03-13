//
//  Wordle.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-08.
//

import Foundation

typealias Peg = String

struct Wordle {
    var masterCode: Code
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    
    // Check if the word exists and has the correct size
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func resetGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = Code.missingPeg
    }
}

enum Match {
    case nomatch
    case exact
    case inexact
}


