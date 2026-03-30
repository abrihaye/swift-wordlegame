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
    let isRevealed: Bool
    
    let pegShape = RoundedRectangle(cornerRadius: 10)
    
    @State private var angle: Double = 0
    
    let matchLUT: [Match: Color] = [.exact: .green, .inexact: .orange, .nomatch: .gray]
    
    var body: some View {
        ZStack {
              face(color: Color.gray(0.7))
                  .opacity(angle < 90 ? 1 : 0)
              face(color: MatchColor())
                  .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                  .opacity(angle >= 90 ? 1 : 0)
          }
          .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
          .onChange(of: isRevealed) {
              guard isRevealed else { return }
              withAnimation(.easeInOut(duration: 0.5)) {
                  angle = 180
              }
          }
          .onAppear {
              if isRevealed {
                  // Use a slight delay or just set it to 180
                  // depending on if you want it to "pop" or "slide" in
                  angle = 180
              }
          }
    }

    func face(color: Color) -> some View {
        pegShape
            .overlay {
                if peg == Code.missingPeg {
                    pegShape.strokeBorder(Color.gray)
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
            .foregroundStyle(color)
    }
    
    
    func MatchColor() -> Color {
        if let matchState {
            return matchLUT[matchState] ?? .clear
        }
        return .clear
    }
}

#Preview {
    PegView(peg: "T", matchState: .exact, isRevealed: true)
}

//pegShape
//    .overlay {
//        if peg == Code.missingPeg {
//            pegShape
//                .strokeBorder(Color.gray)
//        }
//    }
//    .contentShape(pegShape)
//    .aspectRatio(1, contentMode: .fit)
//    
//    .overlay {
//        Text(peg)
//            .foregroundStyle(Color.primary)
//            .font(.system(size: 30))
//            .minimumScaleFactor(0.1)
//    }
//    .foregroundStyle(showFront ? .clear : match)
//
