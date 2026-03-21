//
//  Code.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-12.
//


import Foundation

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
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
    
    var word: String {
        get { pegs.joined() }
        set { pegs = newValue.map{String($0)} }
    }
    
    init(kind: Kind, _ word: String) {
        self.kind = kind
        self.pegs = word.map { String($0) }
    }
    
    init(kind: Kind, count: Int = 5) {
        self.kind = kind
        self.pegs = Array(repeating: Code.missingPeg, count: count)
    }
    
    mutating func reset() {
        pegs = Array(repeating: Code.missingPeg, count: pegs.count)
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
