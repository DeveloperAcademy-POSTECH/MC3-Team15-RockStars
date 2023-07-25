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
    }
}

struct VelocityView_Previews: PreviewProvider {
    @StateObject static private var locationHandler = LocationsHandler()
    
    static var previews: some View {
        VelocityView()
            .environmentObject(locationHandler)
    }
}
