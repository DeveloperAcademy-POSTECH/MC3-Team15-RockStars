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
                            Text("경고 \(context.state.driveState.count.description)번")
                                .foregroundColor(context.state.driveState.count < 4 ? Color(hex: "#4DBBDB") : Color(hex: "#FF5050"))
                                .font(.system(size: 12))
                        }
                    }
                    
                    Image("\(context.state.driveState.trailingImageName)")
                        .resizable()
                        .scaledToFit()
                }
                .padding(.trailing, 1)
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
    static let contentState = DriveAttributes.ContentState(driveState: DriveState(count: 0, progress: 0.0, leadingImageName: "warning1", trailingImageName: "warningCircle1", timestamp: 0, isWarning: false))

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
                    
struct CircularProgressView: View {
    @State var progress: Double = 0.0

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(CircularProgressViewStyle(tint: progress < 1 ? Color(hex: "#4DBBDB") : Color(hex: "#FF5050")))
                
        }
    }
}
