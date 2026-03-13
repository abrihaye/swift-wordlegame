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
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: - BODY
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            // Peg View
            PegView(peg: code.pegs[index], matchState: checkMatch(for: index))
                .padding(Selection.border)
                .background {
                    if selection == index, code.kind == .guess {
                        Selection.shape
                            .foregroundStyle(Selection.color)
                    }
                }
                .overlay {
                    Selection.shape
                        .foregroundStyle(code.isHidden ? Color.black : .clear)
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
            }
        }
    }
    
    func checkMatch(for index: Int) -> Match? {
        if let matches = code.matches {
            return matches[index]
        } else {
            return nil
        }
    }
}

struct Selection {
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    //static let color: Color = Color.gray(0.85)
    static let color: Color = .gray
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}
