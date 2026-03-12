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
    
    @Binding var selection: Int
    
    // MARK: - BODY
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            // Peg View
            PegView(peg: code.pegs[index])
                .foregroundStyle(MatchColor(kind: code.kind, at: index))
                .background {
                    if selection == index, code.kind == .guess {
                        RoundedRectangle(cornerRadius: 1)
                            .foregroundStyle(.red)
                    }
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
    }
    
    let matchLUT: [Match: Color] = [.exact: .green, .inexact: .orange, .nomatch: .gray]
    
    func MatchColor(kind: Code.Kind, at index: Int) -> Color {
        switch kind {
        case .attempt(let match):
            return matchLUT[match[index]] ?? .clear
        case .guess:
            return .gray
        case let .master(isHidden):
            return (isHidden ? .black : .clear)
        default:
            return .clear
        }
    }

    struct Selection {
        static let border: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let color: Color = Color.gray(0.85)
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
    }
}


