//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/11.
//

import SwiftUI
import SpriteKit

struct DrivingPalView: View {
    var scene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
        }
            .ignoresSafeArea()
    }
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView()
    }
}
