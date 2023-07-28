//
//  ExpandedView.swift
//  DrivePalWidgetExtension
//
//  Created by jaelyung kim on 2023/07/25.
//

import SwiftUI

struct ExpandedView: View {
    @State var expandedImageName: String
    @State var progress: Double
    @State var count: Int
    @State var timestamp: Int
    @State var motionStatus: MotionStatus
    
    var body: some View {
        ZStack {
            HStack(alignment: VerticalAlignment.top) {
                expandedLeadingImage
                    .border(Color.red)
                VStack(alignment: .leading) {
                    Text(motionStatusDescription)
                        .font(.system(size: 20, weight: .semibold))
                    HStack {
                        Image(locationPinImage)
                            .resizable()
                            .frame(width: 8, height: 10)
                        Text(I18N.currentLocationLA)
                            .font(.system(size: 10))
                    }
                    .padding(.bottom, 17)
                    HStack {
                        Text(I18N.warningTextLA)
                            .font(.system(size: 8))
                            .opacity(textOpacity)
                        Text(countDescription)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(warningColor)
                        
                        Spacer()
                        
                        Text(I18N.drivingTimeTextLA)
                            .font(.system(size: 8))
                            .opacity(textOpacity)
                        Text("\(timestamp / 60) min")
                            .font(.system(size: 15, weight: .bold))
                            .opacity(textOpacity)
                    }
                    .frame(width: UIScreen.width / 2.7)
                }
                .border(Color.blue)
                Spacer()
            }
            .padding(.leading, 40)
            LinearProgressView(progress: progress < 1.0 ? progress : 1.0, linearColor: linearColor)
                .frame(width: 256)
                .offset(y: 17)
                .border(Color.yellow)
        }
    }
    
    @ViewBuilder var expandedLeadingImage: some View {
        if motionStatus == .suddenAcceleration || motionStatus == .suddenStop {
            ZStack {
                Image(.backgroundWarnSign)
                    .resizable()
                Image("\(expandedImageName)")
                    .resizable()
            }
            .frame(width: 54, height: 53)
            .padding(.trailing, 5)
        } else {
            Image("\(expandedImageName)")
                .resizable()
                .frame(width: 54, height: 53)
                .padding(.trailing, 5)
        }
    }
    
    var motionStatusDescription: String {
        if motionStatus == .normal && count < 4 {
            return I18N.normalDrivingNow
        } else if motionStatus == .suddenAcceleration {
            return I18N.suddenAcceleratedNow
        } else if motionStatus == .suddenStop {
            return I18N.suddenDeceleratedNow
        } else {
            return I18N.badDrivingNow
        }
    }
    
    var locationPinImage: String {
        if motionStatus == .normal && count < 4 {
            return .locationPinBlue
        } else if motionStatus == .suddenAcceleration {
            return .locationPinPink
        } else if motionStatus == .suddenStop {
            return .locationPinYellow
        } else {
            return .locationPinRed
        }
    }
    
    var countDescription: String {
        if motionStatus == .suddenAcceleration || motionStatus == .suddenStop {
            return I18N.countOneMoreWarning
        } else {
            return count.description
        }
    }
    
    var textOpacity: Double {
        if motionStatus == .normal && count < 4 {
            return 0.4
        } else if motionStatus == .suddenAcceleration || motionStatus == .suddenStop {
            return 1.0
        } else {
            return 0.8
        }
    }
    
    var warningColor: Color {
        if motionStatus == .normal && count < 4 {
            return .expandedNormal
        } else if motionStatus == .suddenAcceleration {
            return .expandedWarningAcceleration
        } else if motionStatus == .suddenStop {
            return .expandedWarningDeceleration
        } else {
            return .expandedWarning
        }
    }
    
    var linearColor: Color {
        if motionStatus == .normal && count < 4 {
            return .expandedNormal
        } else if motionStatus == .suddenAcceleration {
            return .expandedWarningAcceleration
        } else if motionStatus == .suddenStop {
            return .expandedWarningDeceleration
        } else {
            return .expandedWarning
        }
    }
}
