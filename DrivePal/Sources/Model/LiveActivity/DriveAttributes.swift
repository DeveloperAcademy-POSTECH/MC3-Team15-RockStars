//
//  DrivePalWidgetExtensionAttributes.swift
//  DrivePal
//
//  Created by jaelyung kim on 2023/07/12.
//

import SwiftUI
import ActivityKit

struct DriveAttributes: ActivityAttributes {
    public typealias DriveStatus = ContentState
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var driveState: DriveState
    }
}

struct DriveState: Codable, Hashable {
    var count: Int
    var suddenAccelerationCount: Int
    var suddenStopCount: Int
    var progress: Double
    var leadingImageName: String
    var trailingImageName: String
    var expandedImageName: String
    var lockScreenImageName: String
    var timestamp: Int
    var isWarning: Bool
    var motionStatus: MotionStatus
    var shouldDisplayAlert: Bool
    var address: String
}
