//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/11.
//

import SwiftUI
import SpriteKit

struct DrivingPalView: View {
<<<<<<< HEAD
    private let planeImage = "planeWithShadow"
=======
>>>>>>> 739828d ([feat][#6] 좌에서 우로 움직이는 배경씬 생성)
    var scene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
<<<<<<< HEAD
            
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
=======
        }
            .ignoresSafeArea()
>>>>>>> 739828d ([feat][#6] 좌에서 우로 움직이는 배경씬 생성)
    }
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView()
    }
}
