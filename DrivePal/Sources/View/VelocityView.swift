//
//  VelocityView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/18.
//

import SwiftUI

struct VelocityView: View {
    @EnvironmentObject var locationHandler: LocationsHandler
    let motionStatus: MotionStatus
    
    private var isPalInDanger: Bool {
        return [MotionStatus.suddenStop, .suddenAcceleration].contains(motionStatus)
    }
    
    private var message: String {
        switch locationHandler.authorizationStatus {
        case .success:
            return "\(locationHandler.speedModel.kilometerPerHour)"
        case .inProgress:
            return I18N.debugUpdateMessage
        case .failure:
            return I18N.debugUpdateFailure
        }
    }
    
    var body: some View {
        HStack {
            Image(.gauge)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: isPalInDanger ? 0 : 108)
                .opacity(isPalInDanger ? 0 : 1)
                .padding(.trailing, isPalInDanger ? 0 : 20)
                .foregroundColor(.white)
            Text(message)
                .stroke(width: motionStatus == .normal ? 0 : 5)
                .font(.system(size: isPalInDanger ? 100 : 80, weight: .black, design: .rounded))
                .shadow(radius: 4.0, y: 4.0)
                .foregroundColor(motionStatus == .normal ? .white : (
                    motionStatus == .suddenStop ? .suddenStopTextColor : .suddenAccelerationTextColor
                ))
            
            if locationHandler.authorizationStatus  == .inProgress {
                ProgressView()
            }
        }
    }
}
