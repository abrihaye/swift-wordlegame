//
//  KeyView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-26.
//

import SwiftUI

struct KeyView: View {
    // MARK: Data In
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.settings) var wordleSettings: SettingsSaver
    let key: Peg
    let state: Match?
    
    // MARK: Data Shared with Me
    var action: ((String) -> Void)?
    
    // MARK: Data owned by Me
    var matchLUT: [Match: Color] {
        [.exact: wordleSettings.exactColor,
         .inexact: wordleSettings.inexactColor,
         .nomatch: wordleSettings.nomatchColor,
         .notTried: .primary]
    }
    
    // MARK: - Body
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .foregroundStyle(colorForKey(key))
            .overlay {
                Button {
                    action?(key)
                } label: {
                    Text(key == "_" ? "" : key)
                        .foregroundStyle(Color.keyboardText(for: colorScheme))
                        .flexibleFontSystem()
                }
                //.buttonStyle(.plain)
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 60.0, maxHeight: 60.0)
    }
    
    func colorForKey(_ peg: Peg) -> Color {
        matchLUT[state ?? .notTried] ?? .primary
    }
    
}

#Preview {
    KeyView(key: "s", state: .exact)
}
