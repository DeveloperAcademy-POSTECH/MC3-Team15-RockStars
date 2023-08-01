//
//  VelocityView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/18.
//

import SwiftUI

struct VelocityView: View {
    @EnvironmentObject var locationHandler: LocationsHandler
    @Binding var motionStatus: MotionStatus
    
    private var isPalInDanger: Bool {
        return [MotionStatus.suddenStop, .suddenAcceleration].contains(motionStatus)
    }
    
    private var message: String {
        switch locationHandler.authorizationStatus {
        case .success:
            return "\(locationHandler.kilometerPerHour)"
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
            // TODO: - font size가 120이라 데이터 읽어오는 중일 떼, 실패했을 때의 메시지를 짧고 간결하게 바꿔야함
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
