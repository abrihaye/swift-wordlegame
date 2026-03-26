//
//  UIExtensions.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-03-25.
//

import SwiftUI

extension Animation {
    static let wordle = Animation.bouncy
    static let guess = Animation.wordle
    static let selection = Animation.wordle
    static let restart = Animation.wordle
}

extension AnyTransition {
    static let keyboard = AnyTransition.offset(x: 0, y:200)
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
    static func keyboardText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .black : .white
    }
}

extension View {
    func flexibleFontSystem(maximum: CGFloat = 80, minimum: CGFloat = 8) -> some View {
        self
        // Get the System Font of your system
            .font(.system(size: maximum))
            .minimumScaleFactor(minimum/maximum)
    }
}
