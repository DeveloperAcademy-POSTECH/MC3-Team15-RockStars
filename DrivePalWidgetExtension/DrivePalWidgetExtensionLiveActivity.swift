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
                    Image("\(context.state.driveState.leadingImageName)")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("부주의 : \(context.state.driveState.count.description)번")
                            .foregroundColor(.blue)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.driveState.description)
                    // more content
                }
            } compactLeading: {
                Image("\(context.state.driveState.leadingImageName)")
                    .resizable()
                    .scaledToFit()
            } compactTrailing: {
                ZStack {
                    if !context.state.driveState.isWarning {
                        HStack {
                            Text("부주의 : \(context.state.driveState.count.description)번")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Image("\(context.state.driveState.trailingImageName)")
                        .resizable()
                        .scaledToFit()
                }
            } minimal: {
                Image("\(context.state.driveState.leadingImageName)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct DrivePalWidgetExtensionLiveActivity_Previews: PreviewProvider {
    static let attributes = DriveAttributes()
    static let contentState = DriveAttributes.ContentState(driveState: DriveState(count: 0, leadingImageName: "warning1", trailingImageName: "warningCircle1", timestamp: 0, isWarning: false))

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
