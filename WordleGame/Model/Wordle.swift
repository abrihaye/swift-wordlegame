//
//  Wordle.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-08.
//

import Foundation

typealias Peg = String

@Observable
class Wordle {
    var name: String
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
    
    init(name: String = "Wordle", masterCode: Code,  attempts: [Code] = []) {
        self.name = name
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
        var attempt = guess
        let matches = guess.match(against: masterCode)
        
        attempt.kind = .attempt(matches)
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

extension Wordle: Identifiable, Hashable, Equatable {
    static func == (lhs: Wordle, rhs: Wordle) -> Bool {
        return lhs.id == rhs.id
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

