//
//  DrivePalWidgetExtensionAttributes.swift
//  DrivePal
//
//  Created by jaelyung kim on 2023/07/12.
//

import SwiftUI
import ActivityKit

struct DrivePalWidgetExtensionAttributes: ActivityAttributes {
    public typealias DriveStatus = ContentState
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var driveState: DriveState
    }
}

struct DriveState: Codable, Hashable {
    var count: Int
    var imageName: String
    var timestamp: Int
    
    var description: String {
        return String("count: \(count)\nimage name: \(imageName)\ntimestamp: \(timestamp)")
    }
}
