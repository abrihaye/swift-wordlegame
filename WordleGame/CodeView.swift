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
            let pegMatch = code.matches?[index]
            RoundedRectangle(cornerRadius: 10)
                .overlay {
                    if peg == Code.missingPeg {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(MatchColor(match: pegMatch, isHidden: code.isHidden))
                .overlay {
                    Text(String(code.pegs[index]))
                        .foregroundStyle(Color.white)
                        .font(.system(size: 30))
                        .minimumScaleFactor(0.1)
                }
        }
    }
    
    func MatchColor(match: Match?, isHidden: Bool = false) -> Color {
        if isHidden {
            return .black
        } else if let match {
            switch match {
            case .exact:
                return .green
            case .inexact:
                return .orange
            default:
                return .gray
            }
        } else {
            return .gray
        }
    }
}


