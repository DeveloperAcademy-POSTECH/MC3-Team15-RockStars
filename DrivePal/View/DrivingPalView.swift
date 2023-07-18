//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/13.
//

import SwiftUI
import CoreMotion
import SpriteKit

struct DrivingPalView: View {
    
    private enum MotionStatus {
        case normal, suddenAcceleration, suddenStop
    }
    
    private let planeImage = "planeWithShadow"
    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    private let motionUpdateInterval = 1.0 / 3.0
    private let startThreshold = -1.1
    private let stopThreshold = 0.75
    
    @State private var motionStatus = MotionStatus.normal
    @State private var zAcceleration = Double.zero
    @StateObject var locationHandler = LocationsHandler()
    // TODO: - 주행 모델이라고 해서 들어가보니까 Activity를 다루는 모델이라서 네이밍 변경 필요.
    @EnvironmentObject var model: DriveModel
    
    private let palImage = "planeWithShadow"
    @State private var viewOpacity = 0.0
    @State private var movePalX = CGFloat.zero
    @State private var movePalY = CGFloat.zero
    
    // TODO: - 뷰 생성 로직이 여기 담겨도 좋을까요?
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
    
    var body: some View {
        ZStack {
            // MARK: - Background scene
            SpriteView(scene: normalScene)
            
            if [MotionStatus.suddenStop, .suddenAcceleration].contains(motionStatus) {
                SpriteView(scene: abnormalScene)
                    .opacity(viewOpacity)
                    .onAppear {
                        viewOpacity = 0.0
                        withAnimation(.easeIn(duration: 0.5)) {
                            viewOpacity = 1.0
                        }
                        withAnimation(.easeOut(duration: 0.5).delay(4.0)) {
                            viewOpacity = 0.0
                        }
                    }
            }
            
            // driving pal
            VStack {
                Spacer()
                Image(palImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .padding(.vertical)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3 * 2 + movePalY)
                    .modifier(Shake(animatableData: CGFloat(movePalX)))
                    .onAppear {
                        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                            movePalY = 20
                        }
                    }
                    .onChange(of: motionStatus, perform: { currentStatus in
                        if currentStatus != .normal {
                            withAnimation(Animation.linear(duration: 1.0).delay(0.5).repeatCount(2)) {
                                movePalX = currentStatus == .normal ? 0 : -10
                            }
                        } else {
                            movePalX = 0
                        }
                    })
            }
            
            VelocityView()
                .environmentObject(locationHandler)
        }
        .onAppear(perform: startAccelerometers)
        .ignoresSafeArea()
    }
    
    private func sleepThreadBriefly() {
        motionManager.stopAccelerometerUpdates()
        Thread.sleep(forTimeInterval: 5)
        startAccelerometers()
    }
    
    private func startAccelerometers() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = motionUpdateInterval
        motionManager.startAccelerometerUpdates(to: operationQueue) { data, _ in
            guard let data else { return }
            zAcceleration = data.acceleration.z
            
            if zAcceleration > stopThreshold {
                motionStatus = .suddenStop
                sleepThreadBriefly()
            } else if zAcceleration < startThreshold {
                motionStatus = .suddenAcceleration
                sleepThreadBriefly()
            } else {
                motionStatus = .normal
            }
        }
    }
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView(model: DriveModel())
    }
}
