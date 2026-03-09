//
//  Wordle.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-08.
//

import Foundation

typealias Peg = Character

struct Wordle {
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
}

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt
        case unknown
    }
}
