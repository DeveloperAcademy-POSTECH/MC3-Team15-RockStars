//
//  ExitButton.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/27.
//

import SwiftUI

struct ExitButton: View {
    @Binding var motionStatus: MotionStatus
    
    var body: some View {
        Button {
            withAnimation {
                motionStatus = .landing
            }
        } label: {
            Image(.exit)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
        }
    }
}
