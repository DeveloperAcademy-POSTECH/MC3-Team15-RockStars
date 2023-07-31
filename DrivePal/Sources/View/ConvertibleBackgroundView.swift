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
    
    private var abnormalScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .redSky
        return scene
    }
    
    private var takeOffScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .airport
        return scene
    }
    
    private var landingScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .airport
        return scene
    }
    
    @Binding var motionStatus: MotionStatus
    @State private var lightningYAxis = -UIScreen.height
    
    var body: some View {
        ZStack {
            // MARK: - BackgroundView
            SpriteView(scene: normalScene)
            
            DrivingStartView(motionStatus: $motionStatus)
                .opacity(motionStatus == .none ? 1 : 0)
            
            SpriteView(scene: takeOffScene)
                .opacity(motionStatus == .takingOff ? 1 : 0)
            
            ZStack {
                SpriteView(scene: abnormalScene)
                Image(.pouringLightning)
                    .resizable()
                    .scaledToFill()
                    .position(x: UIScreen.width / 2, y: lightningYAxis)
            }
            .opacity([MotionStatus.suddenAcceleration, .suddenStop].contains(motionStatus) ? 1 : 0)
            .onChange(of: motionStatus) { status in
                if ![MotionStatus.suddenAcceleration, .suddenStop].contains(status) { return }
                withAnimation(.linear(duration: 5.0)) {
                    lightningYAxis = UIScreen.height * 2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
                    lightningYAxis = -UIScreen.height
                }
            }
            
            SpriteView(scene: landingScene)
                .opacity(motionStatus == .landing ? 1 : 0)
        }
    }
}

struct ConvertibleBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertibleBackgroundView(motionStatus: .constant(.none))
    }
}
