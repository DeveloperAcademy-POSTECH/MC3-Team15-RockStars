//
//  VelocityView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/18.
//

import SwiftUI

struct VelocityView: View {
    @EnvironmentObject var locationHandler: LocationsHandler
    @State private var message: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(message)
            
            if locationHandler.authorizationStatus  == .inProgress {
                ProgressView()
            }
        }
        .padding(.bottom, 30)
        .onChange(of: locationHandler.authorizationStatus, perform: updateMessage)
    }
    
    private func updateMessage(_ current: AuthorizationStatus) {
        switch current {
        case .success:
            message = "km/h: \(locationHandler.kilometerPerHour)"
        case .failure:
            message = "현재 지역에서 데이터를 읽어오는데 실패했습니다.."
        case .inProgress:
            message = "데이터를 읽어오고 있습니다.."
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
