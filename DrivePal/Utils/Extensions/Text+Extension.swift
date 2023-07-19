//
//  Text+Extension.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/19.
//

import SwiftUI

extension Text {
    // MARK: - ResultAnalysisView 내 텍스트
    func resultContentsText() -> some View {
        self
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(Color(hex: "#0C205A"))
    }
}
