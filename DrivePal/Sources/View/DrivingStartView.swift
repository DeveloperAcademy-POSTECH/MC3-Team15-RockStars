//
//  DrivingStartView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/25.
//

import SwiftUI

struct DrivingStartView: View {
    @Binding var motionStatus: MotionStatus
    @Binding var hasNotLocationAuthorization: Bool
    @EnvironmentObject var locationHandler: LocationsHandler
    
    var body: some View {
        ZStack {
            Image(.backgroundAirport)
                .resizable()
                .scaledToFill()
                .position(x: UIScreen.width / 2, y: UIScreen.height / 2)
                .onTapGesture {
                    hasNotLocationAuthorization = !locationHandler.isAuthorizedStatus()
                    if !hasNotLocationAuthorization {
                        motionStatus = .takingOff
                    }
                }
            Image(.startButtonImage)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 20)
                .position(x: UIScreen.width / 2, y: UIScreen.height / 3)
        }
    }
}
