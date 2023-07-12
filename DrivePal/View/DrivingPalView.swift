//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/11.
//

import SwiftUI
import SpriteKit

struct DrivingPalView: View {
    private let planeImage = "planeWithShadow"
    var scene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
            
            VStack {
                Spacer()
                Image(planeImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .padding(.vertical)
            }
        }
        .ignoresSafeArea()
    }
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView()
    }
}
