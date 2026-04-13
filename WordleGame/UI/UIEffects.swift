//
//  UIEffects.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-04-12.
//

import SwiftUI

struct Shake: GeometryEffect {
    var position: CGFloat = 2
    var animatableData: CGFloat {
        get {position}
        set {position = newValue}
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 4 * .pi), y: 0.0))
    }
}

