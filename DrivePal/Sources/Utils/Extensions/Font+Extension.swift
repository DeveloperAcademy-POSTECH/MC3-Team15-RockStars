//
//  Font+Extension.swift
//  DrivePal
//
//  Created by 제나 on 2023/08/01.
//

import SwiftUI

extension Font {
    static func pixelFont(size fontSize: CGFloat) -> Font {
        let familyName = "Galmuri9"
        return Font.custom(familyName, size: fontSize)
    }
}
