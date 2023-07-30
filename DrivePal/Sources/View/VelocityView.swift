//
//  VelocityView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/18.
//

import SwiftUI

struct VelocityView: View {
    @EnvironmentObject var locationHandler: LocationsHandler
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
            Image(.gauge)
                .frame(width: 108)
            // TODO: - font size가 120이라 데이터 읽어오는 중일 떼, 실패했을 때의 메시지를 짧고 간결하게 바꿔야함
            Text(message)
                .font(.system(size: 120, weight: .black, design: .rounded))
            
            if locationHandler.authorizationStatus  == .inProgress {
                ProgressView()
            }
        }
    }
}

struct VelocityView_Previews: PreviewProvider {
    @StateObject static private var locationHandler = LocationsHandler()
    
    static var previews: some View {
        VelocityView()
            .environmentObject(locationHandler)
    }
}
