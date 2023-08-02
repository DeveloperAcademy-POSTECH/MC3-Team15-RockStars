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
    
    // MARK: - Velocity View
    static let suddenStopTextColor = Color(0x4036F0)
    static let suddenAccelerationTextColor = Color(0xFF5050)
    
    // MARK: - Result Analysis View
    static let wordsFromResultColor = Color(0xE8F1FF)
    static let dataBoxBorderColor = Color(0xF5F5F5)
    static let dataGoodValueBackgroundColor = Color(0x3594FF)
    static let dataBadValueBackgroundColor = Color(0xFF7988)
    static let dataTextColor = Color(0x585858)
    
    // MARK: - Dynamic Island
    /// compact
    static let compactNormalCircular = Color(0x4DBBDB)
    static let compactWarningCircular = Color(0xFF5050)
    
    /// expanded
    static let expandedNormal = Color(0x01F0FF)
    static let expandedWarning = Color(0xFF5050)
    static let expandedWarningAcceleration = Color(0xDFFF1C)
    static let expandedWarningDeceleration = Color(0xFF26A8)
    
    /// lockscreen
    static let lockScreenForegroundColor = Color(0x4D52DB)
    static let lockScreenBackgroundColor = Color(0x6B6B6B)
}
