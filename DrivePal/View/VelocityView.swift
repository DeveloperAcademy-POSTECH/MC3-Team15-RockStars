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
            return "km/h: \(locationHandler.speedModel.kilometerPerHour)"
        case .inProgress:
            return "데이터를 읽어오고 있습니다.."
        case .failure:
            return "현재 지역에서 데이터를 읽어오는데 실패했습니다.."
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(message)
            
            if locationHandler.authorizationStatus  == .inProgress {
                ProgressView()
            }
        }
        .padding(.bottom, 30)
    }
}

struct VelocityView_Previews: PreviewProvider {
    @StateObject static private var locationHandler = LocationsHandler()
    
    static var previews: some View {
        VelocityView()
            .environmentObject(locationHandler)
    }
}
