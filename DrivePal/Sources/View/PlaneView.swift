//
//  PlaneView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/25.
//

import SwiftUI

struct PlaneView: View {
    
    @State private var animationBoundY = CGFloat.zero
    @State private var planeDegree = Double.zero
    @State private var planeOpacity = 1.0
    @Binding var motionStatus: MotionStatus
    
    @State private var planeHeight = UIScreen.height - 80
    private let initHeight = UIScreen.height - 80
    // TODO: - lazy하게 수정하려면 코드를 어떻게 변경해야 할까요
    
    private var isPlaneInDanger: Bool {
        return [MotionStatus.suddenStop, .suddenAcceleration].contains(motionStatus)
    }
    
    var body: some View {
        Image(isPlaneInDanger ? .palImageInBadResult : .palImage)
                .resizable()
                .scaledToFit()
                .frame(width: 158)
                .padding(.vertical)
                .position(x: UIScreen.width / 3,
                          y: planeHeight + animationBoundY)
                .rotationEffect(.degrees(planeDegree))
                .onChange(of: motionStatus, perform: actOn)
                .opacity(planeOpacity)
    }
}

struct PlaneView_Previews: PreviewProvider {
    static var previews: some View {
        PlaneView(motionStatus: .constant(.none))
    }
}

private extension PlaneView {
    private func actOn(_ motion: MotionStatus) {
        if motion == .takingOff {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: takeoffAnimation)
        } else if motion == .normal {
            doongsilAnimation()
        } else if motion == .landing {
            landingAnimation()
            animationBoundY = 0
        } else if isPlaneInDanger {
            inDangerAnimation()
        }
    }
    
    private func inDangerAnimation() {
        animationBoundY = 0
        withAnimation(.linear(duration: 1.0).repeatCount(5)) {
            planeOpacity = .zero
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
            planeOpacity = 1.0
        }
    }
    
    private func doongsilAnimation() {
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
            animationBoundY = 60
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
            planeHeight = UIScreen.height / 3 + 30
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
