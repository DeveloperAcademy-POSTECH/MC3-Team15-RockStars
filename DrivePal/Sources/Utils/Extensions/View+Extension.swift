//
//  View+Extension.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/25.
//

import SwiftUI

// MARK: - ResultAnalysisView 내 텍스트
struct ResultTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(.resultTextColor)
            
    }
}

extension View {
    func resultTextModifier() -> some View {
        modifier(ResultTextModifier())
    }
}
