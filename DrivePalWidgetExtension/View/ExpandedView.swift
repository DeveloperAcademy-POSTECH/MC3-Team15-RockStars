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
        VStack {
            HStack(alignment: VerticalAlignment.top) {
                expandedLeadingImage
                    .frame(width: 54, height: 53)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text(motionStatusDescription)
                        .font(.system(size: 16, weight: .semibold))
                    HStack {
                        Image(locationPinImage)
                            .resizable()
                            .frame(width: 8, height: 10)
                        Text(I18N.currentLocationLA)
                            .font(.system(size: 10))
                    }
                }
                
                Spacer()
            }
            .frame(width: UIScreen.width / 1.52)
            .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                LinearProgressView(progress: progress < 1.0 ? progress : 1.0, linearColor: linearColor)
                
                HStack {
                    Text("\(I18N.warningTextLA) \(countDescription)\(I18N.warningCountLA)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(warningColor)
                        
                    Spacer()
                    
                    Text("\(I18N.drivingTimeTextLA) \(timestamp / 60) min")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.trailing, 30)
                }
                
            }
            .frame(width: UIScreen.width / 1.52)
        }
    }
    
    @ViewBuilder private var expandedLeadingImage: some View {
        if motionStatus == .suddenAcceleration || motionStatus == .suddenStop {
            ZStack {
                Image(.backgroundWarnSign)
                    .resizable()
                Image(expandedImageName)
                    .resizable()
            }
        } else {
            Image(expandedImageName)
                .resizable()
        }
    }
    
    private var isStatusInNormal: Bool {
        return motionStatus == .normal && count < 4
    }
    
    private var isStatusInSuddenAction: Bool {
        return [.suddenAcceleration, .suddenStop].contains(motionStatus)
    }
    
    private var motionStatusDescription: String {
        if isStatusInNormal {
            return I18N.normalDrivingNow
        } else if motionStatus == .suddenAcceleration {
            return I18N.suddenAcceleratedNow
        } else if motionStatus == .suddenStop {
            return I18N.suddenDeceleratedNow
        } else {
            return I18N.badDrivingNow
        }
    }
    
    private var locationPinImage: String {
        if isStatusInNormal {
            return .locationPinBlue
        } else if motionStatus == .suddenAcceleration {
            return .locationPinPink
        } else if motionStatus == .suddenStop {
            return .locationPinYellow
        } else {
            return .locationPinRed
        }
    }
    
    private var countDescription: String {
        if isStatusInSuddenAction {
            return I18N.countOneMoreWarning
        } else {
            return count.description
        }
    }
    
    private var textOpacity: Double {
        if isStatusInNormal {
            return 0.4
        } else if isStatusInSuddenAction {
            return 1.0
        } else {
            return 0.8
        }
    }
    
    private var warningColor: Color {
        if isStatusInNormal {
            return .expandedNormal
        } else if motionStatus == .suddenAcceleration {
            return .expandedWarningAcceleration
        } else if motionStatus == .suddenStop {
            return .expandedWarningDeceleration
        } else {
            return .expandedWarning
        }
    }
    
    private var linearColor: Color {
        if isStatusInNormal {
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