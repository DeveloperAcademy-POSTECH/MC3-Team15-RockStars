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
            return "\(locationHandler.kilometerPerHour)\(I18N.debugUpdateSuccess)"
        case .inProgress:
            return I18N.debugUpdateMessage
        case .failure:
            return I18N.debugUpdateFailure
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
