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
            VStack(alignment: .leading) {
                HStack(alignment: VerticalAlignment.top) {
                    Image(context.state.driveState.lockScreenImageName)
                        .resizable()
                        .frame(width: 54, height: 53)
                        .padding(.trailing, 5)
                    
                    VStack(alignment: .leading) {
                        Text(I18N.normalDrivingNow)
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.bottom, 2)
                        HStack(alignment: VerticalAlignment.top) {
                            Image(.locationPinBlack)
                                .resizable()
                                .frame(width: 8, height: 10)
                            Text(context.state.driveState.address)
                                .font(.system(size: 12))
                        }
                    }
                }
                .frame(width: UIScreen.width / 1.52)
                
                LinearProgressView(progress: context.state.driveState.progress < 1.0 ? context.state.driveState.progress : 1.0, linearColor: .lockScreenForegroundColor)
                    .background(Color.lockScreenBackgroundColor)
                    .frame(width: 256)
                HStack {
                    Text("\(I18N.warningTextLA) \(context.state.driveState.count.description)\(I18N.warningCountLA)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.lockScreenForegroundColor)
                        .padding(.trailing, 13)
                    Text("\(I18N.drivingTimeTextLA) \(context.state.driveState.timestamp / 60) min")
                        .font(.system(size: 20, weight: .bold))
                }
            }
            .padding(20)

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
                    ExpandedView(expandedImageName: context.state.driveState.expandedImageName, progress: context.state.driveState.progress, count: context.state.driveState.count, timestamp: context.state.driveState.timestamp, motionStatus: context.state.driveState.motionStatus, address: context.state.driveState.address)
                }
            } compactLeading: {
                HStack {
                    Image(context.state.driveState.leadingImageName)
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
                            Text("\(I18N.warningTextLA) \( context.state.driveState.count.description)\(I18N.warningCountLA)")
                                .foregroundColor(context.state.driveState.count < 4 ? Color.compactNormalCircular : Color.compactWarningCircular)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Image(context.state.driveState.trailingImageName)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 1)
            } minimal: {
                Image(context.state.driveState.leadingImageName)
                    .resizable()
                    .scaledToFit()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
