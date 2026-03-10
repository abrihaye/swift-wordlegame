//
//  CodeView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-10.
//
import SwiftUI

struct CodeView: View {
    // MARK: Data In
    let code: Code
    
    // MARK: - BODY
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            // Peg View
            let peg: String = code.pegs[index]
            let matchColor = code.matches?[index] 
            if let matches = code.matches {
                switch matches[index] {
                case .nomatch:
                case .exact:
                case .inexact:
                }
            }
            
            RoundedRectangle(cornerRadius: 10)
                .overlay {
                    if peg == Code.missingPeg {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(code.isHidden ? .black: .gray)
                .overlay {
                    Text(String(code.pegs[index]))
                        .foregroundStyle(Color.white)
                        .font(.system(size: 30))
                        .minimumScaleFactor(0.1)
                }
        }
    }
    
}


