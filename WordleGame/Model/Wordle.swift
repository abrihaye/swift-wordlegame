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
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    var isOver = false
    var languageCode: String
    
    var pegKeys: [Peg : Match] = [:]
    var timeLastAttempt: Date = Date.now
    
    var startTime: Date? = Date.now
    var elapsedTime: TimeInterval = 0
    var endTime: Date?
    
    var attempts: [Code] {
        get {_attempts.sorted{ $1.timestamp > $0.timestamp}}
        set {_attempts = newValue}
    }
    
    init(masterCode: Code,  attempts: [Code] = [], languageCode language: String = "en_US") {
        self.masterCode = masterCode
        self.languageCode = language
        self.attempts = attempts
    }
    
    func reset() {
        attempts.removeAll()
        pegKeys.removeAll()
        masterCode = Code(kind: .master(isHidden: true), count: masterCode.pegs.count)
        guess = Code(kind: .guess, count: masterCode.pegs.count)
        
        startTime = nil
        endTime = nil
        elapsedTime = 0
    }
    
    func attemptGuess() {
        guard !attempts.contains(where: {$0.pegs == guess.pegs}) else { return }
        let matches = guess.match(against: masterCode)
        let attempt = Code(kind: .attempt(matches), guess._pegs)
    
        print(attempt.matches ?? "No Matches")
        attempts.append(attempt)
        timeLastAttempt = Date.now
        updatePegChoices(for: guess.pegs, matches: matches)
        
        guess.reset()
        
        if attempt.pegs == masterCode.pegs {
            isOver = true
            pauseTimer()
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    func setMaster(masterCode: Code) {
        self.masterCode = masterCode
        print(masterCode._pegs)
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
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = Date.now
        }
    }
}

