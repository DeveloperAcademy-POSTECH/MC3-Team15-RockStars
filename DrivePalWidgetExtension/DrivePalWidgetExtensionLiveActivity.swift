//
//  DrivePalWidgetExtensionLiveActivity.swift
//  DrivePalWidgetExtension
//
//  Created by 제나 on 2023/07/11.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DrivePalWidgetExtensionLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DriveAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Image("\(context.state.driveState.leadingImageName)")
                HStack {
                    Text(context.state.driveState.count.description)
                    Text(" Times")
                }
            }

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                }
                DynamicIslandExpandedRegion(.trailing) {
                }
                DynamicIslandExpandedRegion(.center) {
                }
                DynamicIslandExpandedRegion(.bottom, priority: 1.0) {
                    if context.state.driveState.motionStatus == "normal" {
                        if context.state.driveState.count < 4 {
                            NormalDrivingView(expandedImageName: context.state.driveState.expandedImageName, progress: context.state.driveState.progress, count: context.state.driveState.count, timestamp: context.state.driveState.timestamp)
                        } else {
                            AfterFourWarningsView(expandedImageName: context.state.driveState.expandedImageName, progress: context.state.driveState.progress, count: context.state.driveState.count, timestamp: context.state.driveState.timestamp)
                        }
                    } else if context.state.driveState.motionStatus == "suddenStop" {
                        SuddenStopView(expandedImageName: context.state.driveState.expandedImageName, progress: context.state.driveState.progress, count: context.state.driveState.count, timestamp: context.state.driveState.timestamp)
                    } else if context.state.driveState.motionStatus == "suddenAcceleration" {
                        SuddenAccelerationView(expandedImageName: context.state.driveState.expandedImageName, progress: context.state.driveState.progress, count: context.state.driveState.count, timestamp: context.state.driveState.timestamp)
                    }
                }
            } compactLeading: {
                HStack {
                    Image("\(context.state.driveState.leadingImageName)")
                        .resizable()
                        .scaledToFit()
                }
                .padding(.leading, 1)
            } compactTrailing: {
                ZStack {
                    if !context.state.driveState.isWarning {
                        HStack {
                            CircularProgressView(progress: context.state.driveState.progress < 1.0 ? context.state.driveState.progress : 1.0)
                                .frame(width: 12, height: 12)
                            Text(context.state.driveState.count.description)
                                .foregroundColor(context.state.driveState.count < 4 ? Color.compactNormalCircular : Color.compactWarningCircular)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Image("\(context.state.driveState.trailingImageName)")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 1)
            } minimal: {
                Image("\(context.state.driveState.leadingImageName)")
                    .resizable()
                    .scaledToFit()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct DrivePalWidgetExtensionLiveActivity_Previews: PreviewProvider {
    static let attributes = DriveAttributes()
    static let contentState = DriveAttributes.ContentState(driveState: DriveState(count: 0, progress: 0.0, leadingImageName: "normal1", trailingImageName: "", expandedImageName: "normal1", timestamp: 0, isWarning: false, motionStatus: "normal"))

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
