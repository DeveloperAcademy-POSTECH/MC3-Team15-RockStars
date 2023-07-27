//
//  Color+Extension.swift
//  DrivePal
//
//  Created by jaelyung kim on 2023/07/19.
//

import Foundation
import SwiftUI

extension Color {
    init(_ hex: UInt, alpha: Double = 1.0) {
            let red = Double((hex >> 16) & 0xff) / 255.0
            let green = Double((hex >> 8) & 0xff) / 255.0
            let blue = Double(hex & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    // MARK: - Result Analysis View
    static let resultBackgroundColor = Color(0xB2E3FF)
    static let resultTextColor = Color(0x0C205A)
    
    // MARK: - Dynamic Island
    /// compact
    static let compactNormalCircular = Color(0x4DBBDB)
    static let compactWarningCircular = Color(0xFF5050)
    
    /// expanded
    static let expandedNormal = Color(0x01F0FF)
    static let expandedWarning = Color(0xFF5050)
    static let expandedWarningAcceleration = Color(0xFF26A8)
    static let expandedWarningDeceleration = Color(0xDFFF1C)
    
    /// lockscreen
    static let lockScreenForegroundColor = Color(0x4D52DB)
    static let lockScreenBackgroundColor = Color(0x6B6B6B)
}
