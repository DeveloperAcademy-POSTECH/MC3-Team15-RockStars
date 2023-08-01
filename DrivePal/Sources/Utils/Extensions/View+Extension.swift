//
//  View+Extnesion.swift
//  DrivePal
//
//  Created by 제나 on 2023/08/01.
//
import SwiftUI

extension View {
    func stroke(color: Color = .white, width: CGFloat = 5) -> some View {
        modifier(StrokeModifer(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifer: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat
    var strokeColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }
    
    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { ctx in
                if let resolvedView = context.resolveSymbol(id: id) {
                    ctx.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}
