//
//  Code.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-12.
//


import Foundation
import SwiftData

@Model class Code {
    var _kind: String = Kind.unknown.description
    var pegs: [Peg]
    
    var kind: Kind {
        get { return Kind(_kind) }
        set { _kind = newValue.description}
    }
    
    static let missingPeg: Peg = ""
    
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
        var finalKind: Kind
        if case .attempt(let matches) = kind, word.count != matches.count {
            finalKind = .attempt(Array(repeating: Match.notTried, count: word.count))
        } else {
            finalKind = kind
        }
        self.pegs = word.map { String($0) }
        self.kind = finalKind
    }
    
    init(kind: Kind, count: Int = 5) {
        self.pegs = Array(repeating: Code.missingPeg, count: count)
        self.kind = kind
    }
    
    
    func reset() {
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

enum Match : String, Comparable, Hashable, Codable {
    case notTried
    case nomatch
    case inexact
    case exact
    
    private var comparisonIndex: Int {
        switch self {
        case .notTried: return 0
        case .nomatch: return 1
        case .inexact: return 2
        case .exact: return 3
        }
    }
    static func < (lhs: Match, rhs: Match) -> Bool {
        return lhs.comparisonIndex < rhs.comparisonIndex
    }
}

