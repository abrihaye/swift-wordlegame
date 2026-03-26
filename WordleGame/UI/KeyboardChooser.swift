//
//  KeyboardView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-11.
//

import SwiftUI

struct KeyboardChooser: View {
    // MARK: Data In
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let keyboard: [[Peg]]
    let matchLUT: [Match: Color] = [.exact: .green, .inexact: .orange, .nomatch: .gray, .notTried: .primary]
    let keyMatches: [Peg: Match]
    
    // MARK: Data Out function
    var onChoose: ((Peg) -> Void)?
    var onDelete: (() -> Void)?
    
    var body: some View {
        VStack {
            ForEach(keyboard, id: \.self) { keyboardRow in
                let pegCount = 10 - keyboardRow.count - (keyboardRow == keyboard.last ? 1 : 0)
                HStack(alignment: .center) {
                    if pegCount > 0 {
                        Color.clear
                            .aspectRatio(Double(pegCount) / 2.0, contentMode: .fit)
                    }
                    ForEach(keyboardRow, id: \.self) { peg in
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(colorForKey(peg))
                            .overlay {
                                Button {
                                    onChoose?(peg)
                                } label: {
                                    Text(peg)
                                        .foregroundStyle(Color.keyboardText(for: colorScheme))
                                        .flexibleFontSystem()
                                }
                                //.buttonStyle(.plain)
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: 60.0, maxHeight: 60.0)
                    }
                    if pegCount > 0 {
                        Color.clear
                            .aspectRatio(Double(pegCount) / 2.0, contentMode: .fit)
                    }
                    if keyboardRow == keyboard.last {
                        Button("Delete", systemImage: "delete.backward") {
                            onDelete?()
                        }
                    }
                }
            }
        }
        .aspectRatio(10/3, contentMode: .fit)
    }
    
    func colorForKey(_ peg: Peg) -> Color {
        matchLUT[keyMatches[peg] ?? .notTried] ?? .black
    }
    
    init(for keyArray: [String],
         dict keysToMatch: [Peg: Match],
         cb onChoose: ((Peg) -> Void)?,
         deleteCb onDelete: (() -> Void)?)
    {
        self.keyboard = keyArray.map { $0.map { String($0) } }
        self.onChoose = onChoose
        self.onDelete = onDelete
        self.keyMatches = keysToMatch
    }
}

//#Preview {
//    KeyboardChooser(for: ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]) { peg in
//        print("chose \(peg)")
//    } deleteCb: {
//        print("delete")
//    }
//}
