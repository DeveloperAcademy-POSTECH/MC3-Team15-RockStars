//
//  PlaneView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/25.
//

import SwiftUI

struct PlaneView: View {
    
    @State private var animationBoundY = CGFloat.zero
    @State private var planeHeight = UIScreen.height - 50
    @State private var planeDegree = Double.zero
    @State private var movePalX = CGFloat.zero
    @Binding var motionStatus: MotionStatus
    
    private let palImage = "planeWithShadow"
    private let initHeight = UIScreen.height - 50
    
    var body: some View {
            Image(palImage)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.width - 100)
                .padding(.vertical)
                .position(x: UIScreen.width / 2,
                          y: planeHeight + animationBoundY)
                .rotationEffect(.degrees(planeDegree))
                .shake(movePalX)
                .onChange(of: motionStatus, perform: actOn)
    }
}

struct PlaneView_Previews: PreviewProvider {
    static var previews: some View {
        PlaneView(motionStatus: .constant(.none))
    }
}

private extension PlaneView {
    private func actOn(_ motion: MotionStatus) {
        if motion == .normal {
            takeoffAnimation()
            doongsilAnimation()
        } else if motion == .landing {
            landingAnimation()
            animationBoundY = 0
        } else if [MotionStatus.suddenAcceleration, .suddenStop].contains(motion) {
            shakeAnimation(motion)
        }
    }
    
    private func shakeAnimation(_ currentStatus: MotionStatus) {
        guard [MotionStatus.suddenAcceleration, .suddenStop].contains(currentStatus) else {
            movePalX = 0
            return
        }
        withAnimation(Animation.linear(duration: 1.0).delay(0.5).repeatCount(2)) {
            movePalX = -10
        }
    }
    
    func doongsilAnimation() {
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
            animationBoundY = 20
        }
    }
    
    private func landingAnimation() {
        withAnimation(.linear(duration: 1.0)) {
            planeHeight = initHeight
            planeDegree = 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                planeDegree = 8
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation {
                planeDegree = 5
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation {
                planeDegree = 0
            }
        }
    }
    
    private func takeoffAnimation() {
        withAnimation(.linear(duration: 1.0)) {
            planeHeight = UIScreen.height / 3 * 2
            planeDegree = -10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                planeDegree = -7
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation {
                planeDegree = -3
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                planeDegree = 0
            }
        }
    }
}
