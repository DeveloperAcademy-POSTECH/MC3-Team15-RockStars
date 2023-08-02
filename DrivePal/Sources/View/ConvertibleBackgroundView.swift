//
//  ConvertibleBackgroundView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/25.
//

import SwiftUI
import SpriteKit

struct ConvertibleBackgroundView: View {
    private var normalScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .blueSky
        return scene
    }
    
    private var suddenAccelerationScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .lightningSky
        return scene
    }
    
    private var suddenStopScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .meteorSky
        return scene
    }
    
    private var takeOffAndLandingScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .airport
        return scene
    }
    
    @Binding var motionStatus: MotionStatus
    @State private var lightningYAxis = -UIScreen.height
    @State private var meteorYAxis = -UIScreen.height
    
    var body: some View {
        ZStack {
            // MARK: - BackgroundView
            SpriteView(scene: normalScene)
            
            DrivingStartView(motionStatus: $motionStatus)
                .opacity(motionStatus == .none ? 1 : 0)
            
            SpriteView(scene: takeOffAndLandingScene)
                .opacity([.takingOff, .landing].contains(motionStatus) ? 1 : 0)
            
            ZStack {
                SpriteView(scene: suddenAccelerationScene)
                Image(.pouringLightning)
                    .resizable()
                    .scaledToFill()
                    .position(x: UIScreen.width / 2, y: lightningYAxis)
            }
            .opacity(motionStatus == .suddenAcceleration ? 1 : 0)
            .onChange(of: motionStatus, perform: lightningAnimation)
            
            ZStack {
                SpriteView(scene: suddenStopScene)
                Image(.pouringMeteor)
                    .resizable()
                    .scaledToFill()
                    .position(x: UIScreen.width / 2, y: meteorYAxis)
            }
            .opacity(motionStatus == .suddenStop ? 1 : 0)
            .onChange(of: motionStatus, perform: meteorAnimation)
        }
    }
    
    private func meteorAnimation(_ status: MotionStatus) {
        if status != .suddenStop { return }
        withAnimation(.linear(duration: 5.0)) {
            meteorYAxis = UIScreen.height * 2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
            meteorYAxis = -UIScreen.height
        }
        
    }
    
    private func lightningAnimation(_ status: MotionStatus) {
        if status != .suddenAcceleration { return }
        withAnimation(.linear(duration: 5.0)) {
            lightningYAxis = UIScreen.height * 2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
            lightningYAxis = -UIScreen.height
        }
    }
}

struct ConvertibleBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertibleBackgroundView(motionStatus: .constant(.none))
    }
}
