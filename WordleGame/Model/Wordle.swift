//
//  Wordle.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-08.
//

import Foundation

typealias Peg = String

struct Wordle {
    let id = UUID()
    
    var masterCode: Code {
        didSet {
            print(masterCode)
            guess = Code(kind: .guess, count: masterCode.pegs.count)
        }
    }
    
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    var pegKeys: [Peg : Match] = [:]
    
    var isOver: Bool {
            attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func reset(words: Words) {
        attempts = []
        pegKeys = [:]
        masterCode = Code(kind: .master(isHidden: true), (words.random(length: Int.random(in: 3...6)) ?? "ERROR"))
        guess = Code(kind: .guess, count: masterCode.pegs.count)
    }
    
    // Check if the word exists and has the correct size
    mutating func attemptGuess() {
        var attempt = guess
        let matches = guess.match(against: masterCode)
        
        attempt.kind = .attempt(matches)
        updatePegChoices(for: guess.pegs, matches: matches)
        attempts.append(attempt)
        
        print(attempts)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func updateMaster(masterCode: Code) {
        self.masterCode = masterCode
        guess = Code(kind: .guess, count: masterCode.pegs.count)
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func resetGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = Code.missingPeg
    }
    
    mutating func updatePegChoices(for pegs: [Peg], matches: [Match]) {
        for index in 0..<pegs.count {
            let current = pegKeys[pegs[index]] ?? .notTried
            
            if current < matches[index] {
                pegKeys[pegs[index]] = matches[index]
            }
        }
    }
}

extension Wordle: Identifiable, Hashable, Equatable {
    static func == (lhs: Wordle, rhs: Wordle) -> Bool {
        return lhs.id == rhs.id && lhs.attempts == rhs.attempts
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum Match : Int, Comparable {
    case notTried = 0
    case nomatch = 1
    case inexact = 2
    case exact = 3
    
    static func < (lhs: Match, rhs: Match) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

