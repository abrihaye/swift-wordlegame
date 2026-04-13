//
//  UIEffects.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-04-12.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var position: CGFloat = 2
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * 4 * .pi), y: 0.0))
    }
}

