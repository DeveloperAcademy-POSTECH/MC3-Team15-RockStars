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
    var progress: Double
    var leadingImageName: String
    var trailingImageName: String
    var timestamp: Int
    var isWarning: Bool
    var motionStatus: String
    
    var description: String {
        return String("count: \(count)\nprogress: \(progress)\nleadingImageName: \(leadingImageName)\ntrailingImageName: \(trailingImageName)\ntimestamp: \(timestamp)\nisWarning: \(isWarning)\nmotionStatus: \(motionStatus)")
    }
}
