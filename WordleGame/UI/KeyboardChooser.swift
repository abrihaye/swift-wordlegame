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
    
    // MARK: Data Out function
    var onChoose: ((Peg) -> Void)?
    
    var body: some View {
        VStack {
            ForEach(keyboard, id: \.self) { keyboardRow in
                HStack {
                    ForEach(keyboardRow, id: \.self) { peg in
                        RoundedRectangle(cornerRadius: 5)
                            .overlay {
                                Button {
                                    onChoose?(peg)
                                } label: {
                                    Text(peg)
                                        .font(.system(size: 30.0))
                                        .minimumScaleFactor(2/80.0)
                                        .foregroundStyle(.primary)
                                }
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 30.0, height: 30.0)
                    }
                }
            }
        }
    }
    
    init(for keyArray: [String], cb onChoose: ((Peg) -> Void)?) {
        self.keyboard = keyArray.map{ $0.map{ String($0) } }
        self.onChoose = onChoose
    }
}

#Preview {
    KeyboardChooser(for: ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]) { peg in
        print("chose \(peg)")
    }
}
