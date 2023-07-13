//
//  DrivePalWidgetExtensionAttributes.swift
//  DrivePal
//
//  Created by jaelyung kim on 2023/07/12.
//

import SwiftUI
import ActivityKit

struct DrivePalWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var count: Int
        var imageName: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
