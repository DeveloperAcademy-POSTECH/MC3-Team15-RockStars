//
//  Color+Extension.swift
//  DrivePal
//
//  Created by jaelyung kim on 2023/07/19.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >>  8) & 0xFF) / 255.0
        let blue = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
    
    static let backgroundColor = Color(hex: "#B2E3FF")
}
