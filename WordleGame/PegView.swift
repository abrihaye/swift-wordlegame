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
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay {
                if peg == Code.missingPeg {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(peg)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 30))
                    .minimumScaleFactor(0.1)
            }
    }
}

#Preview {
    PegView(peg: "T")
}
