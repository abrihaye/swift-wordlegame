//
//  KeyboardView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-11.
//

import SwiftUI

struct KeyboardChooser: View {
    // MARK: Data In
    let keyboard: [[Peg]]
    let deleteSymbol = Image(systemName: "delete.backward")
    let matchLUT: [Match: Color] = [.exact: .green, .inexact: .orange, .nomatch: .gray, .notTried: .black]
    
    let keyMatches: [Peg: Match]
    
    // MARK: Data Out function
    var onChoose: ((Peg) -> Void)?
    var onDelete: (() -> Void)?
    
    
    var body: some View {
        VStack {
            ForEach(keyboard, id: \.self) { keyboardRow in
                HStack {
                    ForEach(keyboardRow, id: \.self) { peg in
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(colorForKey(peg))
                            .overlay {
                                Button {
                                    onChoose?(peg)
                                } label: {
                                    Text(peg)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 30.0))
                                        .minimumScaleFactor(2/80.0)
                                }

                            }
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 30.0, height: 30.0)
                        
                    }
                    if keyboardRow == keyboard.last {
                        Button {
                            onDelete?()
                        } label: {
                            deleteSymbol
                                .frame(width: 30.0, height: 30.0)
                        }
                    }
                }
               
            }
        }
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
