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
                    .onAppear(perform: showAbnormalBackground)
            }
            
            // driving pal
            VStack {
                Spacer()
                Image(palImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.width - 100)
                    .padding(.vertical)
                    .position(x: UIScreen.width / 2, y: UIScreen.height / 3 * 2 + movePalY)
                    .shake(movePalX)
                    .onAppear(perform: moveVerticallyPal)
                    .onChange(of: motionStatus, perform: moveHorizontallyPal)
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
    
    private func showAbnormalBackground() {
        let blinkSecond = 4.0
        // 초기화
        viewOpacity = 0.0
        // 비정상 배경 뷰 보이게 함
        withAnimation(.easeIn(duration: 0.5)) {
            viewOpacity = 1.0
        }
        // 비정상 배경 뷰 숨김
        withAnimation(.easeOut(duration: 0.5).delay(blinkSecond)) {
            viewOpacity = 0.0
        }
    }
    
    private func moveVerticallyPal() {
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
            movePalY = 20
        }
    }
    
    private func moveHorizontallyPal(_ currentStatus: MotionStatus) {
        withAnimation(Animation.linear(duration: 1.0).delay(0.5).repeatCount(2)) {
            movePalX = currentStatus == .normal ? 0 : -10
        }
    }
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView()
    }
}
