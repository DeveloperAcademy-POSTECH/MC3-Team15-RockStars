//
//  VelocityView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/18.
//

import SwiftUI

struct VelocityView: View {
    @EnvironmentObject var locationHandler: LocationsHandler
    @State private var message = ""
    
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
            message = "\(locationHandler.kilometerPerHour)\(I18N.debugUpdateSuccess)"
        case .failure:
            message = I18N.debugUpdateFailure
        case .inProgress:
            message = I18N.debugUpdateMessage
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
