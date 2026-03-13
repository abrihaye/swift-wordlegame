//
//  PegView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-11.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    let matchState: Match?
    
    let pegShape = RoundedRectangle(cornerRadius: 10)
    
    let matchLUT: [Match: Color] = [.exact: .green, .inexact: .orange, .nomatch: .gray]
    
    var body: some View {
        pegShape
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(peg)
                    .foregroundStyle(Color.primary)
                    .font(.system(size: 30))
                    .minimumScaleFactor(0.1)
            }
            .foregroundStyle(MatchColor())
    }
    
    func MatchColor() -> Color {
        if let matchState {
            return matchLUT[matchState] ?? .clear
        }
        return .clear
    }
}

#Preview {
    PegView(peg: "T", matchState: nil)
}
