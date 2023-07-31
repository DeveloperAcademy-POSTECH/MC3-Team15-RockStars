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
        HStack(spacing: 30) {
            Group {
                Image(.gauge)
                    .renderingMode(.template)
                    .frame(width: 108)
                // TODO: - font size가 120이라 데이터 읽어오는 중일 떼, 실패했을 때의 메시지를 짧고 간결하게 바꿔야함
                Text(message)
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .shadow(radius: 4.0, y: 4.0)
            }
            .foregroundColor(isPalInDanger ? .inDangerTextColor : .white)
            .shadow(color: isPalInDanger ? .white : .clear, radius: 1.0)
            
            if locationHandler.authorizationStatus  == .inProgress {
                ProgressView()
            }
        }
    }
}
