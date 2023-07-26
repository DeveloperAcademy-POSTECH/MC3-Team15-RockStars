//
//  DrivingStartView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/25.
//

import SwiftUI

struct DrivingStartView: View {
    @Binding var motionStatus: MotionStatus
    
    var body: some View {
        ZStack {
            Image("blueSky")
                .resizable()
                .scaledToFill()
                .position(x: UIScreen.width / 2, y: UIScreen.height / 2)
                .onTapGesture {
                    motionStatus = .takingOff
                }
            Text("PRESS TO START")
                .foregroundColor(.white)
                .font(.headline)
                .position(x: UIScreen.width / 2, y: UIScreen.height / 2)
        }
    }
}

struct DrivingStartView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingStartView(motionStatus: .constant(.none))
    }
}
