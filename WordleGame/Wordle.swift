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
        print(attempt.matches ?? "none")
        attempts.append(attempt)
        guess.reset()
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
}

enum Match {
    case nomatch
    case exact
    case inexact
}

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missingPeg, count: 5)
    
    static let missingPeg: Peg = ""
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    init(kind: Kind, _ word: String) {
        self.kind = kind
        self.pegs = word.map { String($0) }
    }
    
    init(kind: Kind) {
        self.kind = kind
        print(self.pegs)
    }
    
    mutating func reset() {
        pegs = Array(repeating: Code.missingPeg, count: 5)
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > 0, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        
        let exactMatches = Array(backwardExactMatches.reversed())
        
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
    
}
