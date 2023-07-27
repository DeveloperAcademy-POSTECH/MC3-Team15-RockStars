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
        scene.backgroundImageNamed = .startRunway
        return scene
    }
    
    private var landingScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .finishAirport
        return scene
    }
    
    @Binding var motionStatus: MotionStatus
    
    var body: some View {
        ZStack {
            // MARK: - BackgroundView
            SpriteView(scene: normalScene)
            
            DrivingStartView(motionStatus: $motionStatus)
                .opacity(motionStatus == .none ? 1 : 0)
            
            SpriteView(scene: takeOffScene)
                .opacity(motionStatus == .takingOff ? 1 : 0)
            
            SpriteView(scene: abnormalScene)
                .opacity([MotionStatus.suddenAcceleration, .suddenStop].contains(motionStatus) ? 1 : 0)
            
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
