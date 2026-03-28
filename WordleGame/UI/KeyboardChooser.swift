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
    let keyMatches: [Peg: Match]
    
    // MARK: Data Out function
    var onChoose: ((Peg) -> Void)?
    var onDelete: (() -> Void)?
    
    var body: some View {
        VStack {
            ForEach(keyboard.indices, id: \.self) { index in
                let keyboardRow = keyboard[index]
                HStack(alignment: .center) {
                    emptyFiller(at: index)
                    ForEach(keyboardRow, id: \.self) { key in
                        KeyView(key: key, state: keyMatches[key], action: onChoose)
                    }
                    emptyFiller(at: index)
                    if index == keyboard.count - 1 {
                        Button("Delete", systemImage: "delete.backward") {
                            onDelete?()
                        }
                    }
                }
            }
        }
        .aspectRatio(10/3, contentMode: .fit)
    }
    
    @ViewBuilder
    func emptyFiller(at index: Int) -> some View {
        let count = keyboard[index].count
        let isLast = index == keyboard.count - 1
        let pegCount = Double(10 - count - (isLast ? 1 : 0)) / 2
        if pegCount > 0 {
            Color.clear
                .aspectRatio(pegCount, contentMode: .fit)
        } else {
            EmptyView()
        }
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
