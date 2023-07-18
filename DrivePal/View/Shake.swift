//
//  Shake.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/13.
//

import SwiftUI

struct Shake: GeometryEffect {
    private let amount: CGFloat = 10
    private let shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
